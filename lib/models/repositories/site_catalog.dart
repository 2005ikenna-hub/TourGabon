import '../site_touristique.dart';

abstract interface class SiteCatalog {
  Future<List<SiteTouristique>> obtenirSitesParLangue(String codeLangue);
}
