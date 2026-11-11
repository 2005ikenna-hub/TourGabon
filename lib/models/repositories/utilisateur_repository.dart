// lib/models/repositories/utilisateur_repository.dart
import '../data_sources/api_client.dart';
import '../utilisateur.dart';

class UtilisateurRepository {
  UtilisateurRepository({ApiClient? api}) : _api = api ?? ApiClient.instance;

  final ApiClient _api;

  /// POST /api/auth/register — le mot de passe est haché côté serveur.
  Future<void> inscrire({
    required String nom,
    required String email,
    required String motDePasse,
    required String type,
    required String langue,
  }) async {
    await _api.post('/api/auth/register', {
      'nom': nom,
      'email': email,
      'mots_de_passe': motDePasse,
      'type': type,
      'langue_preference': langue,
    });
  }

  /// POST /api/auth/login — mémorise le jeton JWT pour les requêtes suivantes.
  Future<Utilisateur> connecter(String email, String motDePasse) async {
    final reponse = await _api.post('/api/auth/login', {
      'email': email,
      'mots_de_passe': motDePasse,
    }) as Map<String, dynamic>;
    _api.definirToken(reponse['token'] as String);
    return Utilisateur.fromJson(reponse['user'] as Map<String, dynamic>);
  }

  void deconnecter() => _api.definirToken(null);
}
