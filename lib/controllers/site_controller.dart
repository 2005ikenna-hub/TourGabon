import '../models/repositories/site_catalog.dart';
import '../models/site_touristique.dart';

class SiteController {
  const SiteController(this._catalog);

  final SiteCatalog _catalog;

  Future<List<SiteTouristique>> obtenirSites() {
    return _catalog.obtenirSitesParLangue('fr');
  }

  List<SiteTouristique> filtrerSites(
    List<SiteTouristique> sites, {
    String recherche = '',
    String categorie = 'Tout',
  }) {
    final normalizedQuery = recherche.trim().toLowerCase();

    return sites.where((site) {
      final matchesCategory =
          categorie == 'Tout' || site.categorie == categorie;
      final matchesQuery = normalizedQuery.isEmpty ||
          site.nom.toLowerCase().contains(normalizedQuery) ||
          site.description.toLowerCase().contains(normalizedQuery) ||
          site.categorie.toLowerCase().contains(normalizedQuery);

      return matchesCategory && matchesQuery;
    }).toList();
  }
}
