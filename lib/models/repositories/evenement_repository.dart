// lib/models/repositories/evenement_repository.dart
import '../data_sources/api_client.dart';

class EvenementRepository {
  EvenementRepository({ApiClient? api}) : _api = api ?? ApiClient.instance;

  final ApiClient _api;

  /// GET /api/evenements?avenir=1 — agenda en cours et à venir, trié par date.
  Future<List<Map<String, dynamic>>> obtenirAgendaActuel() async {
    final reponse = await _api.get('/api/evenements', query: {'avenir': '1'}) as Map<String, dynamic>;
    return List<Map<String, dynamic>>.from(reponse['data'] as List);
  }

  /// POST /api/evenements — réservé aux comptes Admin et Local.
  Future<void> creerEvenement({
    required String idSite,
    required String titre,
    required String description,
    required String debut, // 'AAAA-MM-JJ HH:MM:SS'
    required String fin,
  }) async {
    await _api.post('/api/evenements', {
      'id_site': int.parse(idSite),
      'titre': titre,
      'description': description,
      'date_debut': debut,
      'date_fin': fin,
    });
  }
}
