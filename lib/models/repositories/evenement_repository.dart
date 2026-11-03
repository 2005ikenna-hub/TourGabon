// lib/models/repositories/evenement_repository.dart
import '../data_sources/xmlforge_database.dart';

class EvenementRepository {
  final XmlForgeDatabase _dataSource = XmlForgeDatabase.instance;

  // CREATE : Planifier et publier une micro-aventure ou une animation locale
  Future<bool> creerEvenement(String idSite, String titre, String desc, String debut, String fin, String idCreateur) async {
    final String query = '''
      INSERT INTO evenements (id_site, titre, description, date_debut, date_fin, id_createur)
      VALUES ($idSite, '${titre.replaceAll("'", "''")}', '${desc.replaceAll("'", "''")}', '$debut', '$fin', $idCreateur);
    ''';
    final response = await _dataSource.sendFrame(2, {'session_token': _dataSource.sessionToken, 'query': query});
    return response['status'] == 2;
  }

  // READ : Récupérer l'agenda en cours (filtré par ordre chronologique à venir)
  Future<List<Map<String, dynamic>>> obtenirAgendaActuel() async {
    // Note : XMLForge n'acceptant pas les calculs complexes de fonctions de dates, on extrait l'agenda ordonné
    const String query = "SELECT * FROM evenements ORDER BY date_debut ASC;";
    final response = await _dataSource.sendFrame(2, {'session_token': _dataSource.sessionToken, 'query': query});

    if (response['status'] == 2 && response.containsKey('result')) {
      return List<Map<String, dynamic>>.from(response['result']['rows'] as List);
    }
    return [];
  }

  // UPDATE : Reporter ou modifier les détails logistiques d'un festival/marché
  Future<bool> modifierEvenement(String idEvenement, String titre, String debut, String fin) async {
    final String query = '''
      UPDATE evenements 
      SET titre = '${titre.replaceAll("'", "''")}', date_debut = '$debut', date_fin = '$fin' 
      WHERE id = $idEvenement;
    ''';
    final response = await _dataSource.sendFrame(2, {'session_token': _dataSource.sessionToken, 'query': query});
    return response['status'] == 2;
  }

  // DELETE : Annuler un événement culturel
  Future<bool> annulerEvenement(String idEvenement) async {
    final String query = "DELETE FROM evenements WHERE id = $idEvenement;";
    final response = await _dataSource.sendFrame(2, {'session_token': _dataSource.sessionToken, 'query': query});
    return response['status'] == 2;
  }
}
