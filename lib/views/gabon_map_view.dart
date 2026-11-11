// lib/views/gabon_map_view.dart
import 'package:flutter/material.dart';

import '../controllers/site_controller.dart';
import '../models/site_touristique.dart';
import 'package:tour_gabon/views/discover_view.dart';
import 'package:tour_gabon/views/site_photo.dart';

class GabonMapView extends StatefulWidget {
  const GabonMapView({super.key, required this.controller});

  final SiteController controller;

  @override
  State<GabonMapView> createState() => _GabonMapViewState();
}

class _GabonMapViewState extends State<GabonMapView> {
  List<SiteTouristique> _sites = [];
  bool _isLoading = true;
  String? _selectedProvince;

  static const _gabonGreen = Color(0xFF009E49);
  static const _gabonYellow = Color(0xFFFCD116);
  static const _gabonBlue = Color(0xFF003DA5);
  static const _ink = Color(0xFF10251B);
  static const _muted = Color(0xFF6A796F);

  final List<Map<String, dynamic>> _provinces = [
    {
      'nom': 'Estuaire',
      'chefLieu': 'Libreville',
      'description': 'Capitale politique, plages de sable fin, Pointe Denis et parc national d’Akanda.',
      'icon': Icons.location_city_rounded,
      'color': _gabonGreen,
    },
    {
      'nom': 'Ogooué-Maritime',
      'chefLieu': 'Port-Gentil',
      'description': 'Capitale économique, littoral atlantique, lagunes et réserve de Loango.',
      'icon': Icons.waves_rounded,
      'color': _gabonBlue,
    },
    {
      'nom': 'Haut-Ogooué',
      'chefLieu': 'Franceville',
      'description': 'Plateaux spectaculaires, sources chaudes de Lekedi et faune diversifiée.',
      'icon': Icons.terrain_rounded,
      'color': _gabonYellow,
    },
    {
      'nom': 'Moyen-Ogooué',
      'chefLieu': 'Lambaréné',
      'description': 'Terre du Dr. Albert Schweitzer, lacs pittoresques et navigation sur l’Ogooué.',
      'icon': Icons.water_rounded,
      'color': Color(0xFF145C43),
    },
    {
      'nom': 'Ogooué-Ivindo',
      'chefLieu': 'Makokou',
      'description': 'Forêts primaires denses, majestueuses chutes de Kongou et parc national d’Ivindo.',
      'icon': Icons.park_rounded,
      'color': Color(0xFF0D6836),
    },
    {
      'nom': 'Woleu-Ntem',
      'chefLieu': 'Oyem',
      'description': 'Plateau septentrional, collines verdoyantes, culture et traditions fang.',
      'icon': Icons.eco_rounded,
      'color': Color(0xFF2C8A62),
    },
  ];

  @override
  void initState() {
    super.initState();
    _chargerSites();
  }

  Future<void> _chargerSites() async {
    try {
      final sites = await widget.controller.obtenirSites();
      if (!mounted) return;
      setState(() {
        _sites = sites;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 1100;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Carte & Régions du Gabon',
          style: TextStyle(fontWeight: FontWeight.w800, color: _ink),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(
            height: 4,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [_gabonGreen, _gabonYellow, _gabonBlue],
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: _gabonGreen))
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 48 : 20,
                vertical: 24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Interactive Map Header Card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [_gabonGreen, Color(0xFF0A4E2B)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: _gabonGreen.withValues(alpha: 0.25),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _gabonYellow,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'CARTE INTERACTIVE',
                                      style: TextStyle(
                                        color: _ink,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1.1,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Explorez les Provinces du Gabon',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Cliquez sur une province pour découvrir ses richesses naturelles et touristiques.',
                                    style: TextStyle(
                                      color: Color(0xFFE2F0E7),
                                      fontSize: 13,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isDesktop) ...[
                              const SizedBox(width: 24),
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.map_rounded,
                                  size: 54,
                                  color: _gabonYellow,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Provinces & Pôles Touristiques',
                        style: TextStyle(
                          color: _ink,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isDesktop ? 3 : (width >= 650 ? 2 : 1),
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.5,
                        ),
                        itemCount: _provinces.length,
                        itemBuilder: (context, index) {
                          final prov = _provinces[index];
                          final isSelected = _selectedProvince == prov['nom'];
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedProvince = isSelected ? null : prov['nom'] as String;
                              });
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFFE5F1E9) : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected ? _gabonGreen : Colors.grey.shade200,
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: (prov['color'] as Color).withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          prov['icon'] as IconData,
                                          color: prov['color'] as Color,
                                          size: 22,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              prov['nom'] as String,
                                              style: const TextStyle(
                                                color: _ink,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            Text(
                                              'Chef-lieu : ${prov['chefLieu']}',
                                              style: TextStyle(
                                                color: prov['color'] as Color,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Text(
                                    prov['description'] as String,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: _muted,
                                      fontSize: 12,
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 36),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedProvince != null
                                ? 'Sites en $_selectedProvince'
                                : 'Tous les Sites du Gabon (${_sites.length})',
                            style: const TextStyle(
                              color: _ink,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (_selectedProvince != null)
                            TextButton(
                              onPressed: () => setState(() => _selectedProvince = null),
                              child: const Text('Voir tout'),
                            ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // List of sites
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _sites.length,
                        itemBuilder: (context, index) {
                          final site = _sites[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: SitePhoto(
                                  site: site,
                                  fallbackUrl: 'https://images.unsplash.com/photo-1448375240586-882707db888b?auto=format&fit=crop&w=200&q=80',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    width: 60,
                                    height: 60,
                                    color: _gabonGreen.withValues(alpha: 0.2),
                                    child: const Icon(Icons.park, color: _gabonGreen),
                                  ),
                                ),
                              ),
                              title: Text(
                                site.nom,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: _ink,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  '${site.categorie} • Lat: ${site.latitude.toStringAsFixed(2)}, Lon: ${site.longitude.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: _muted,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: _gabonGreen),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    // On passe ici le contrôleur requis en utilisant 'widget.controller'
                                    builder: (_) => DiscoverView(controller: widget.controller),
                                  ),
                                );



                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
