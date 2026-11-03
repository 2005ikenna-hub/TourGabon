// lib/models/utilisateur.dart
class Utilisateur {
  final String id;
  final String nom;
  final String email;
  final String type; // 'Étranger' ou 'Local'
  final String langue;

  Utilisateur({
    required this.id,
    required this.nom,
    required this.email,
    required this.type,
    required this.langue,
  });

  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      id: json['id'].toString(),
      nom: json['nom'] as String,
      email: json['email'] as String,
      type: json['type'] as String,
      langue: json['langue'] as String? ?? 'fr',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'email': email,
      'type': type,
      'langue': langue,
    };
  }
}
