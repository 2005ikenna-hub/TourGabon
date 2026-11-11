// lib/models/repositories/avis_repository.dart
import '../data_sources/api_client.dart';

class AvisRepository {
  AvisRepository({ApiClient? api}) : _api = api ?? ApiClient.instance;

  final ApiClient _api;

  /// GET /api/avis/site/:id
  Future<List<Map<String, dynamic>>> obtenirAvisDuSite(String idSite) async {
    final reponse = await _api.get('/api/avis/site/$idSite') as Map<String, dynamic>;
    return List<Map<String, dynamic>>.from(reponse['data'] as List);
  }

  /// POST /api/avis — l'auteur est identifié par le jeton (connexion requise).
  Future<void> publierAvis(String idSite, int note, String commentaire) async {
    await _api.post('/api/avis', {
      'id_site': int.parse(idSite),
      'note': note,
      'commentaire': commentaire,
    });
  }
}
