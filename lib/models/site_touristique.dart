// lib/models/site_touristique.dart
class SiteTouristique {
  final String id;
  final String nom;
  final String description;
  final double latitude;
  final double longitude;
  final String categorie;
  final String urlPhotos;

  SiteTouristique({
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
      nom: json['nom'] as String,
      description: json['description'] as String? ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      categorie: json['categorie'] as String,
      urlPhotos: json['url_photos'] as String? ?? '',
    );
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
