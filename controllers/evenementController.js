const db = require('../config/xmlforge');
const { str, int, timestamp } = db.sql;

exports.getAllEvenements = async (req, res) => {
  try {
    const rows = await db.rows(
      `SELECT e.id_evenement AS id_evenement, e.id_site AS id_site, t.nom AS nom_site, e.titre AS titre, e.description AS description, e.date_debut AS date_debut, e.date_fin AS date_fin FROM Evenements e INNER JOIN Traductions_Sites t ON e.id_site = t.id_site WHERE t.code_langue = 'fr' ORDER BY e.date_debut ASC LIMIT 500`
    );
    let data = rows;
    if (req.query.avenir === '1') {
      // événements en cours ou à venir (le filtre par date est fait ici : XMLForge n'a pas de fonctions de date)
      const maintenant = new Date().toISOString().replace('T', ' ').slice(0, 19);
      data = rows.filter((e) => String(e.date_fin) >= maintenant);
    }
    res.status(200).json({ success: true, data });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};

// Réservé aux comptes Admin et Local ; le créateur est l'utilisateur du jeton
exports.ajouterEvenement = async (req, res) => {
  try {
    const { titre, description, date_debut, date_fin, id_site } = req.body;
    if (!titre || !description || !date_debut || !date_fin || id_site === undefined) {
      return res.status(400).json({ success: false, message: 'titre, description, date_debut, date_fin et id_site requis' });
    }
    const debut = timestamp(date_debut);
    const fin = timestamp(date_fin);
    if (fin < debut) {
      return res.status(400).json({ success: false, message: 'La date de fin précède la date de début' });
    }
    const r = await db.query(
      `INSERT INTO Evenements (id_site, titre, description, date_debut, date_fin, id_createur) VALUES (${int(id_site)}, ${str(titre)}, ${str(description)}, ${debut}, ${fin}, ${int(req.user.id)})`
    );
    res.status(201).json({ success: true, message: 'Événement ajouté avec succès', id_evenement: r.row?.id_evenement });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};
