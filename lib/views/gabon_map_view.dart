import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

const _forest = Color(0xFF145C43);
const _ocean = Color(0xFF167F9C);
const _ink = Color(0xFF18352A);
const _muted = Color(0xFF77847B);
const _loango = LatLng(-2.25, 9.6167);

class GabonMapView extends StatefulWidget {
  const GabonMapView({super.key});

  @override
  State<GabonMapView> createState() => _GabonMapViewState();
}

class _GabonMapViewState extends State<GabonMapView> {
  final MapController _mapController = MapController();

  Position? _position;
  List<LatLng> _routePoints = const [];
  double? _routeDistanceMeters;
  Duration? _routeDuration;
  String? _errorMessage;
  bool _isLocating = false;
  bool _isRouting = false;
  bool _mapReady = false;
  bool _permissionPermanentlyDenied = false;

  Future<bool> _localiser() async {
    setState(() {
      _isLocating = true;
      _errorMessage = null;
      _permissionPermanentlyDenied = false;
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _setError('Active la localisation de ton appareil puis réessaie.');
        return false;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        _permissionPermanentlyDenied = true;
        _setError(
          'L’accès à la position est bloqué. Autorise-le dans les réglages.',
        );
        return false;
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.unableToDetermine) {
        _setError('Autorise l’accès à ta position pour te localiser.');
        return false;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );
      if (!mounted) return false;
      setState(() {
        _position = position;
        _routePoints = const [];
        _routeDistanceMeters = null;
        _routeDuration = null;
      });
      if (_mapReady) {
        _mapController.move(LatLng(position.latitude, position.longitude), 12);
      }
      return true;
    } on TimeoutException {
      _setError('La localisation prend trop de temps. Vérifie le signal GPS.');
      return false;
    } on LocationServiceDisabledException {
      _setError('Active la localisation de ton appareil puis réessaie.');
      return false;
    } on PermissionDeniedException {
      _setError('L’accès à ta position a été refusé.');
      return false;
    } on PlatformException catch (error) {
      _setError('Impossible de récupérer ta position : ${error.message}');
      return false;
    } on Exception catch (error) {
      _setError('Impossible de récupérer ta position : $error');
      return false;
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  void _setError(String message) {
    if (!mounted) return;
    setState(() => _errorMessage = message);
  }

  Future<void> _tracerItineraire() async {
    if (_position == null && !await _localiser()) return;
    if (!mounted) return;

    final position = _position;
    if (position == null) return;

    setState(() {
      _isRouting = true;
      _errorMessage = null;
      _routePoints = const [];
      _routeDistanceMeters = null;
      _routeDuration = null;
    });

    final uri = Uri.https(
      'router.project-osrm.org',
      '/route/v1/driving/'
          '${position.longitude},${position.latitude};'
          '${_loango.longitude},${_loango.latitude}',
      {'overview': 'full', 'geometries': 'geojson', 'steps': 'false'},
    );

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 30));
      if (response.statusCode != 200) {
        throw const FormatException('Le service de trajet est indisponible.');
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Réponse invalide du service de trajet.');
      }
      final routes = decoded['routes'];
      if (decoded['code'] != 'Ok' || routes is! List || routes.isEmpty) {
        throw StateError(
          'Aucun itinéraire routier n’a été trouvé pour cette position.',
        );
      }
      final route = routes.first;
      if (route is! Map<String, dynamic>) {
        throw const FormatException('Données d’itinéraire invalides.');
      }
      final distance = route['distance'];
      final duration = route['duration'];
      final geometry = route['geometry'];
      if (distance is! num ||
          duration is! num ||
          geometry is! Map<String, dynamic> ||
          geometry['coordinates'] is! List) {
        throw const FormatException('Données d’itinéraire incomplètes.');
      }

      final coordinates = geometry['coordinates'] as List;
      final points = <LatLng>[];
      for (final coordinate in coordinates) {
        if (coordinate is! List ||
            coordinate.length < 2 ||
            coordinate[0] is! num ||
            coordinate[1] is! num) {
          throw const FormatException('Tracé d’itinéraire invalide.');
        }
        points.add(
          LatLng(
            (coordinate[1] as num).toDouble(),
            (coordinate[0] as num).toDouble(),
          ),
        );
      }
      if (points.length < 2) {
        throw const FormatException('Le tracé reçu est incomplet.');
      }

      if (!mounted) return;
      setState(() {
        _routePoints = points;
        _routeDistanceMeters = distance.toDouble();
        _routeDuration = Duration(seconds: duration.round());
      });
      _afficherItineraire();
    } on TimeoutException {
      _setError('Le calcul du trajet a expiré. Vérifie ta connexion internet.');
    } on http.ClientException catch (error) {
      _setError('Le service de trajet est inaccessible : ${error.message}');
    } on FormatException catch (error) {
      _setError(error.message);
    } on StateError catch (error) {
      _setError(error.message.toString());
    } on Exception catch (error) {
      _setError('Impossible de calculer le trajet : $error');
    } finally {
      if (mounted) setState(() => _isRouting = false);
    }
  }

  void _afficherItineraire() {
    if (!_mapReady || _routePoints.isEmpty) return;
    _mapController.fitCamera(
      CameraFit.coordinates(
        coordinates: _routePoints,
        padding: const EdgeInsets.fromLTRB(48, 48, 48, 48),
        maxZoom: 12,
      ),
    );
  }

  Future<void> _ouvrirReglages() async {
    try {
      final opened = await Geolocator.openAppSettings();
      if (!opened && mounted) {
        _setError('Ouvre les réglages de l’application pour autoriser le GPS.');
      }
    } on PlatformException catch (error) {
      _setError('Impossible d’ouvrir les réglages : ${error.message}');
    }
  }

  String _dureeFormatee(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours == 0) return '$minutes min';
    return '$hours h ${minutes.toString().padLeft(2, '0')} min';
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>[
      Marker(
        point: _loango,
        width: 52,
        height: 76,
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on, color: _forest, size: 42),
            Text(
              'Loango',
              style: TextStyle(
                color: _ink,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                shadows: [Shadow(color: Colors.white, blurRadius: 4)],
              ),
            ),
          ],
        ),
      ),
      if (_position case final position?)
        Marker(
          point: LatLng(position.latitude, position.longitude),
          width: 44,
          height: 44,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: _ocean, width: 3),
              boxShadow: const [
                BoxShadow(color: Color(0x33000000), blurRadius: 8),
              ],
            ),
            child: const Icon(Icons.person_pin_circle, color: _ocean, size: 27),
          ),
        ),
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFE1EFF1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(Icons.map_rounded, color: _ocean),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Carte du Gabon',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Ta position et la route vers Loango',
                      style: TextStyle(color: _muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                tooltip: 'Recentrer la carte sur Loango',
                onPressed: () {
                  _mapController.move(_loango, 7);
                },
                icon: const Icon(Icons.park_outlined),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _loango,
                      initialZoom: 6,
                      minZoom: 3,
                      maxZoom: 18,
                      onMapReady: () {
                        _mapReady = true;
                        _afficherItineraire();
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.tour_gabon',
                      ),
                      if (_routePoints.isNotEmpty)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: _routePoints,
                              color: _ocean,
                              strokeWidth: 6,
                              borderColor: Colors.white,
                              borderStrokeWidth: 2,
                            ),
                          ],
                        ),
                      MarkerLayer(markers: markers),
                    ],
                  ),
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '© OpenStreetMap contributors',
                        style: TextStyle(color: _ink, fontSize: 9),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: FloatingActionButton.small(
                      heroTag: 'center-user-location',
                      tooltip: 'Centrer sur ma position',
                      backgroundColor: Colors.white,
                      foregroundColor: _ocean,
                      onPressed: _position == null
                          ? _localiser
                          : () => _mapController.move(
                              LatLng(_position!.latitude, _position!.longitude),
                              12,
                            ),
                      child: const Icon(Icons.my_location),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_routeDistanceMeters != null && _routeDuration != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F0EB),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.route_rounded, color: _forest),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${(_routeDistanceMeters! / 1000).toStringAsFixed(0)} km'
                      '  ·  ${_dureeFormatee(_routeDuration!)} en voiture',
                      style: const TextStyle(
                        color: _ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: const Color(0xFFFFECE8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xFF9B3A2D),
                    size: 19,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Color(0xFF7F3026),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  if (_permissionPermanentlyDenied)
                    TextButton(
                      onPressed: _ouvrirReglages,
                      child: const Text('Réglages'),
                    ),
                ],
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 4),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isLocating || _isRouting ? null : _localiser,
                  icon: _isLocating
                      ? const SizedBox(
                          width: 17,
                          height: 17,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.my_location),
                  label: const Text('Me localiser'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    foregroundColor: _ocean,
                    side: const BorderSide(color: _ocean),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  onPressed: _isLocating || _isRouting
                      ? null
                      : _tracerItineraire,
                  icon: _isRouting
                      ? const SizedBox(
                          width: 17,
                          height: 17,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.directions),
                  label: Text(
                    _isRouting ? 'Calcul…' : 'Itinéraire vers Loango',
                  ),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: _forest,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 2, 20, 8),
          child: Text(
            'Pour calculer la route, ta position est envoyée au service public OSRM.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _muted, fontSize: 10),
          ),
        ),
      ],
    );
  }
}
