// lib/models/repositories/utilisateur_repository.dart
import '../utilisateur.dart';
import '../data_sources/xmlforge_database.dart';

class UtilisateurRepository {
  final XmlForgeDatabase _dataSource = XmlForgeDatabase.instance;

  // CREATE : Inscription d'un nouvel utilisateur
  Future<bool> inscrireUtilisateur(Utilisateur user, String motDePasseHache) async {
    final String query = '''
      INSERT INTO utilisateurs (nom, email, mot_de_passe, type, langue)
      VALUES ('${user.nom.replaceAll("'", "''")}', '${user.email.replaceAll("'", "''")}', '$motDePasseHache', '${user.type}', '${user.langue}');
    ''';
    final response = await _dataSource.sendFrame(2, {'session_token': _dataSource.sessionToken, 'query': query});
    return response['status'] == 2;
  }

  // READ : Connexion et récupération du profil utilisateur
  Future<Utilisateur?> connecterUtilisateur(String email, String motDePasseHache) async {
    final String query = "SELECT * FROM utilisateurs WHERE email = '${email.replaceAll("'", "''")}' AND mot_de_passe = '$motDePasseHache' LIMIT 1;";
    final response = await _dataSource.sendFrame(2, {'session_token': _dataSource.sessionToken, 'query': query});

    if (response['status'] == 2 && response.containsKey('result')) {
      final List<dynamic> rows = response['result']['rows'] as List<dynamic>;
      if (rows.isNotEmpty) {
        return Utilisateur.fromJson(rows.first as Map<String, dynamic>);
      }
    }
    return null;
  }

  // UPDATE : Mise à jour des préférences (Changement de langue ou de profil)
  Future<bool> mettreAJourPreferences(String idUser, String typeProfil, String codeLangue) async {
    final String query = '''
      UPDATE utilisateurs 
      SET type = '$typeProfil', langue = '$codeLangue' 
      WHERE id = $idUser;
    ''';
    final response = await _dataSource.sendFrame(2, {'session_token': _dataSource.sessionToken, 'query': query});
    return response['status'] == 2;
  }

  // DELETE : Clôture / Suppression du compte utilisateur
  Future<bool> supprimerCompte(String idUser) async {
    final String query = "DELETE FROM utilisateurs WHERE id = $idUser;";
    final response = await _dataSource.sendFrame(2, {'session_token': _dataSource.sessionToken, 'query': query});
    return response['status'] == 2;
  }
}
