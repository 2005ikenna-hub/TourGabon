const db = require('../config/xmlforge');
const { str, dec, int } = db.sql;

const SELECT = `SELECT s.id_site AS id, t.nom AS nom, t.description AS description, s.latitude AS latitude, s.longitude AS longitude, s.categorie AS categorie, s.url_photos AS url_photos, t.code_langue AS code_langue FROM Sites_Touristiques s INNER JOIN Traductions_Sites t ON s.id_site = t.id_site`;

const format = (r) => ({
  id: r.id,
  nom: r.nom,
  description: r.description ?? '',
  latitude: Number(r.latitude),
  longitude: Number(r.longitude),
  categorie: r.categorie ?? '',
  url_photos: r.url_photos ?? '',
});

exports.getAllSites = async (req, res) => {
  try {
    const lang = ['fr', 'en'].includes(req.query.lang) ? req.query.lang : 'fr';
    const rows = await db.rows(`${SELECT} WHERE t.code_langue = ${str(lang)} ORDER BY s.id_site ASC LIMIT 1000`);
    let result = rows;
    if (lang !== 'fr') {
      // un site sans traduction dans la langue demandée est renvoyé en français
      const connus = new Set(rows.map((r) => r.id));
      const fr = await db.rows(`${SELECT} WHERE t.code_langue = 'fr' ORDER BY s.id_site ASC LIMIT 1000`);
      result = [...rows, ...fr.filter((r) => !connus.has(r.id))].sort((a, b) => a.id - b.id);
    }
    res.status(200).json({ success: true, data: result.map(format) });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};

// Réservé à l'administrateur
exports.ajouterSite = async (req, res) => {
  try {
    const { latitude, longitude, url_photos, categorie, nom_fr, description_fr } = req.body;
    if (!nom_fr || latitude === undefined || longitude === undefined) {
      return res.status(400).json({ success: false, message: 'nom_fr, latitude et longitude requis' });
    }
    const r = await db.query(
      `INSERT INTO Sites_Touristiques (latitude, longitude, url_photos, categorie) VALUES (${dec(latitude)}, ${dec(longitude)}, ${str(url_photos || null)}, ${str(categorie || null)})`
    );
    const id = r.row.id_site;
    await db.query(
      `INSERT INTO Traductions_Sites (id_site, code_langue, nom, description) VALUES (${int(id)}, 'fr', ${str(nom_fr)}, ${str(description_fr || '')})`
    );
    res.status(201).json({ success: true, id_site: id });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};

// Réservé à l'administrateur (les traductions, événements et avis liés sont supprimés en cascade)
exports.supprimerSite = async (req, res) => {
  try {
    await db.query(`DELETE FROM Sites_Touristiques WHERE id_site = ${int(req.params.id)}`);
    res.status(200).json({ success: true });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};
