const bcrypt = require('bcryptjs');
const db = require('../config/xmlforge');
const { str } = db.sql;
const { signToken } = require('../middleware/auth');

const TYPES_PUBLICS = ['Local', 'Étranger'];
const LANGUES = ['fr', 'en'];

const profil = (u) => ({
  id: u.id_utilisateur,
  nom: u.nom,
  email: u.email,
  type: u.type,
  langue_preference: u.langue_preference,
});

exports.inscrireUtilisateur = async (req, res) => {
  try {
    const { nom, email, mots_de_passe, type, langue_preference } = req.body;
    if (!nom || !email || !mots_de_passe || !email.includes('@') || mots_de_passe.length < 6) {
      return res.status(400).json({ success: false, message: 'Nom, e-mail valide et mot de passe (6 caractères min.) requis' });
    }
    // Un compte public est toujours "Local" ou "Étranger" : le rôle Admin ne s'obtient pas par l'API.
    const typeFinal = type === 'Etranger' ? 'Étranger' : TYPES_PUBLICS.includes(type) ? type : 'Local';
    const langue = LANGUES.includes(langue_preference) ? langue_preference : 'fr';

    const existant = await db.rows(`SELECT id_utilisateur FROM Utilisateurs WHERE email = ${str(email.trim().toLowerCase())}`);
    if (existant.length > 0) {
      return res.status(409).json({ success: false, message: 'Cet e-mail est déjà utilisé' });
    }
    const hash = await bcrypt.hash(mots_de_passe, 10);
    const r = await db.query(
      `INSERT INTO Utilisateurs (nom, email, mots_de_passe, type, langue_preference) VALUES (${str(nom.trim())}, ${str(email.trim().toLowerCase())}, ${str(hash)}, ${str(typeFinal)}, ${str(langue)})`
    );
    res.status(201).json({ success: true, message: 'Utilisateur inscrit avec succès', id_utilisateur: r.row?.id_utilisateur });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};

exports.connecterUtilisateur = async (req, res) => {
  try {
    const { email, mots_de_passe } = req.body;
    if (!email || !mots_de_passe) {
      return res.status(400).json({ success: false, message: 'E-mail et mot de passe requis' });
    }
    const rows = await db.rows(`SELECT * FROM Utilisateurs WHERE email = ${str(email.trim().toLowerCase())} LIMIT 1`);
    const user = rows[0];
    if (!user || !(await bcrypt.compare(mots_de_passe, user.mots_de_passe))) {
      return res.status(401).json({ success: false, message: 'Email ou mot de passe incorrect' });
    }
    res.status(200).json({ success: true, message: 'Connexion réussie', token: signToken(user), user: profil(user) });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};
