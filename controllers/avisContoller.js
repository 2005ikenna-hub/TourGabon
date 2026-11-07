const db = require('../config/db');

// Récupérer les avis d'un site touristique spécifique
exports.getAvisBySite = async (req, res) => {
    try {
        const { id_site } = req.params;
        const [rows] = await db.query(
            `SELECT a.*, u.nom as nom_utilisateur 
             FROM Avis a 
             JOIN Utilisateurs u ON a.id_utilisateur = u.id_utilisateur 
             WHERE a.id_site = ?`, 
            [id_site]
        );
        res.status(200).json({ success: true, data: rows });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

// Ajouter un avis sur un site
exports.ajouterAvis = async (req, res) => {
    try {
        const { id_site, id_utilisateur, note, commentaire } = req.body;
        const [result] = await db.query(
            `INSERT INTO Avis (id_site, id_utilisateur, note, commentaire) VALUES (?, ?, ?, ?)`,
            [id_site, id_utilisateur, note, commentaire]
        );
        res.status(201).json({ 
            success: true, 
            message: "Avis ajouté avec succès", 
            id_avis: result.insertId 
        });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};