// lib/models/repositories/site_repository.dart
import '../site_touristique.dart';
import '../data_sources/xmlforge_database.dart';
import 'site_catalog.dart';

class SiteRepository implements SiteCatalog {
  final XmlForgeDatabase _dataSource = XmlForgeDatabase.instance;

  // CREATE : Ajouter un point d'intérêt fixe (Réservé admin côté contrôleur)
  Future<bool> ajouterSite(SiteTouristique site, String nomFr, String descFr) async {
    // 1. Insertion dans la table principale des coordonnées et médias
    final String querySite = '''
      INSERT INTO sites_touristiques (latitude, longitude, url_photos, categorie)
      VALUES (${site.latitude}, ${site.longitude}, '${site.urlPhotos}', '${site.categorie}');
    ''';
    final response = await _dataSource.sendFrame(2, {'session_token': _dataSource.sessionToken, 'query': querySite});

    if (response['status'] == 2 && response.containsKey('result')) {
      final String generatedId = response['result']['row']['id'].toString();

      // 2. Insertion de la version linguistique initiale par défaut (Français)
      final String queryTrad = '''
        INSERT INTO traductions_sites (id_site, code_langue, nom, description)
        VALUES ($generatedId, 'fr', '${nomFr.replaceAll("'", "''")}', '${descFr.replaceAll("'", "''")}');
      ''';
      await _dataSource.sendFrame(2, {'session_token': _dataSource.sessionToken, 'query': queryTrad});
      return true;
    }
    return false;
  }

  // READ : Obtenir le catalogue traduit selon la langue de l'utilisateur (Jointure SQL)
  @override
  Future<List<SiteTouristique>> obtenirSitesParLangue(String codeLangue) async {
    final String query = '''
      SELECT s.id, t.nom, t.description, s.latitude, s.longitude, s.categorie, s.url_photos 
      FROM sites_touristiques s 
      INNER JOIN traductions_sites t ON s.id = t.id_site 
      WHERE t.code_langue = '$codeLangue';
    ''';

    final response = await _dataSource.sendFrame(2, {'session_token': _dataSource.sessionToken, 'query': query});
    if (response['status'] == 2 && response.containsKey('result')) {
      final List<dynamic> rows = response['result']['rows'] as List<dynamic>;
      return rows.map((json) => SiteTouristique.fromJson(json as Map<String, dynamic>)).toList();
    }
    return [];
  }

  // UPDATE : Modifier les informations géographiques ou médias d'un site
  Future<bool> modifierSite(String idSite, double lat, double lng, String urlPhotos, String cat) async {
    final String query = '''
      UPDATE sites_touristiques 
      SET latitude = $lat, longitude = $lng, url_photos = '$urlPhotos', categorie = '$cat' 
      WHERE id = $idSite;
    ''';
    final response = await _dataSource.sendFrame(2, {'session_token': _dataSource.sessionToken, 'query': query});
    return response['status'] == 2;
  }

  // DELETE : Supprimer un site (la contrainte ON DELETE CASCADE nettoie les traductions associées)
  Future<bool> supprimerSite(String idSite) async {
    final String query = "DELETE FROM sites_touristiques WHERE id = $idSite;";
    final response = await _dataSource.sendFrame(2, {'session_token': _dataSource.sessionToken, 'query': query});
    return response['status'] == 2;
  }
}
