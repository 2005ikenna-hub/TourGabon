// lib/models/repositories/avis_repository.dart
import '../data_sources/xmlforge_database.dart';

class AvisRepository {
  final XmlForgeDatabase _dataSource = XmlForgeDatabase.instance;

  // CREATE : Laisser un avis communautaire évalué sur un lieu précis
  Future<bool> publierAvis(String idUser, String idSite, int note, String commentaire) async {
    final String query = '''
      INSERT INTO avis (id_utilisateur, id_site, note, commentaire)
      VALUES ($idUser, $idSite, $note, '${commentaire.replaceAll("'", "''")}');
    ''';
    final response = await _dataSource.sendFrame(2, {'session_token': _dataSource.sessionToken, 'query': query});
    return response['status'] == 2;
  }

  // READ : Extraire la liste des retours d'expériences laissés sur un site spécifique
  Future<List<Map<String, dynamic>>> obtenirAvisDuSite(String idSite) async {
    final String query = "SELECT a.note, a.commentaire, a.date_publication, u.nom FROM avis a INNER JOIN utilisateurs u ON a.id_utilisateur = u.id WHERE a.id_site = $idSite;";
    final response = await _dataSource.sendFrame(2, {'session_token': _dataSource.sessionToken, 'query': query});

    if (response['status'] == 2 && response.containsKey('result')) {
      return List<Map<String, dynamic>>.from(response['result']['rows'] as List);
    }
    return [];
  }

  // UPDATE : Permettre à un internaute de corriger son commentaire
  Future<bool> modifierMonAvis(String idAvis, int nouvelleNote, String nouveauCommentaire) async {
    final String query = '''
      UPDATE avis 
      SET note = $nouvelleNote, commentaire = '${nouveauCommentaire.replaceAll("'", "''")}' 
      WHERE id = $idAvis;
    ''';
    final response = await _dataSource.sendFrame(2, {'session_token': _dataSource.sessionToken, 'query': query});
    return response['status'] == 2;
  }

  // DELETE : Retirer / Supprimer la publication d'un avis
  Future<bool> supprimerAvis(String idAvis) async {
    final String query = "DELETE FROM avis WHERE id = $idAvis;";
    final response = await _dataSource.sendFrame(2, {'session_token': _dataSource.sessionToken, 'query': query});
    return response['status'] == 2;
  }
}
