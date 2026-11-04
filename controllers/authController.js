const db = require('../config/db');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET || 'tour_gabon_secret_key';

exports.inscrireUtilisateur = async (req, res) => {
  try {
    const { nom, email, mots_de_passe, type, langue_preference } = req.body;
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(mots_de_passe, salt);

    const query = `
      INSERT INTO Utilisateurs (nom, email, mots_de_passe, type, langue_preference)
      VALUES (?, ?, ?, ?, ?)
    `;
    const [result] = await db.execute(query, [nom, email, hashedPassword, type || 'Local', langue_preference || 'fr']);

    res.status(201).json({
      success: true,
      message: 'Utilisateur inscrit avec succès',
      id_utilisateur: result.insertId
    });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};

exports.connecterUtilisateur = async (req, res) => {
  try {
    const { email, mots_de_passe } = req.body;
    const query = `SELECT * FROM Utilisateurs WHERE email = ? LIMIT 1`;
    const [rows] = await db.execute(query, [email]);

    if (rows.length === 0) {
      return res.status(401).json({ success: false, message: 'Email ou mot de passe incorrect' });
    }

    const user = rows[0];
    const isMatch = await bcrypt.compare(mots_de_passe, user.mots_de_passe);
    if (!isMatch) {
      return res.status(401).json({ success: false, message: 'Email ou mot de passe incorrect' });
    }

    const token = jwt.sign(
      { id: user.id_utilisateur, email: user.email, type: user.type },
      JWT_SECRET,
      { expiresIn: '24h' }
    );

    res.status(200).json({
      success: true,
      message: 'Connexion réussie',
      token,
      user: {
        id: user.id_utilisateur,
        nom: user.nom,
        email: user.email,
        type: user.type,
        langue_preference: user.langue_preference
      }
    });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};