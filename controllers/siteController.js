const db = require('../config/db');

exports.getAllSites = async (req, res) => {
  try {
    const lang = req.query.lang || 'fr';
    const query = `
      SELECT s.id_site AS id, 
             t.nom AS nom, 
             t.description AS description, 
             s.latitude AS latitude, 
             s.longitude AS longitude, 
             s.categorie AS categorie, 
             s.url_photos AS urlPhotos
      FROM Sites_Touristiques s 
      LEFT JOIN Traductions_Sites t ON s.id_site = t.id_site AND t.code_langue = ?
    `;
    const [rows] = await db.execute(query, [lang]);
    res.status(200).json({ success: true, data: rows });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};