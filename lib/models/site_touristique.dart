// lib/models/site_touristique.dart
class SiteTouristique {
  final String id;
  final String nom;
  final String description;
  final double latitude;
  final double longitude;
  final String categorie;
  final String urlPhotos;

  const SiteTouristique({
    required this.id,
    required this.nom,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.categorie,
    required this.urlPhotos,
  });

  factory SiteTouristique.fromJson(Map<String, dynamic> json) {
    return SiteTouristique(
      id: json['id'].toString(),
      nom: json['nom'] as String? ?? '',
      description: json['description'] as String? ?? '',
      latitude: _enDouble(json['latitude']),
      longitude: _enDouble(json['longitude']),
      categorie: json['categorie'] as String? ?? '',
      urlPhotos: (json['url_photos'] ?? json['urlPhotos']) as String? ?? '',
    );
  }

  // Les DECIMAL peuvent arriver sous forme de texte : on accepte nombre ou chaîne.
  static double _enDouble(Object? valeur) {
    if (valeur is num) return valeur.toDouble();
    return double.parse(valeur.toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'categorie': categorie,
      'url_photos': urlPhotos,
    };
  }
}
