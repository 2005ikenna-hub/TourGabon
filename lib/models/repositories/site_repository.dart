// lib/models/repositories/site_repository.dart
import '../data_sources/api_client.dart';
import '../site_touristique.dart';
import 'site_catalog.dart';

/// Catalogue des sites fourni par l'API REST (GET /api/sites?lang=fr).
class SiteRepository implements SiteCatalog {
  SiteRepository({ApiClient? api}) : _api = api ?? ApiClient.instance;

  final ApiClient _api;

  @override
  Future<List<SiteTouristique>> obtenirSitesParLangue(String codeLangue) async {
    final reponse = await _api.get('/api/sites', query: {'lang': codeLangue});
    final data = (reponse as Map<String, dynamic>)['data'] as List<dynamic>;
    return data
        .map((json) => SiteTouristique.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}

/// Utilise l'API et, si elle est injoignable, le catalogue de secours.
class SiteCatalogAvecSecours implements SiteCatalog {
  const SiteCatalogAvecSecours(this._principal, this._secours);

  final SiteCatalog _principal;
  final SiteCatalog _secours;

  @override
  Future<List<SiteTouristique>> obtenirSitesParLangue(String codeLangue) async {
    try {
      final sites = await _principal.obtenirSitesParLangue(codeLangue);
      if (sites.isNotEmpty) return sites;
    } catch (_) {
      // API injoignable : on bascule sur les données locales
    }
    return _secours.obtenirSitesParLangue(codeLangue);
  }
}
