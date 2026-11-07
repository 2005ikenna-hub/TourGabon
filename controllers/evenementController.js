const db = require('../config/db');

// Récupérer tous les événements
exports.getAllEvenements = async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM Evenements');
        res.status(200).json({ success: true, data: rows });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

// Ajouter un événement
exports.ajouterEvenement = async (req, res) => {
    try {
        const { titre, description, date_debut, date_fin, id_site } = req.body;
        const [result] = await db.query(
            `INSERT INTO Evenements (titre, description, date_debut, date_fin, id_site) VALUES (?, ?, ?, ?, ?)`,
            [titre, description, date_debut, date_fin, id_site]
        );
        res.status(201).json({ 
            success: true, 
            message: "Événement ajouté avec succès", 
            id_evenement: result.insertId 
        });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};