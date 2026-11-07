const express = require('express');
const router = express.Router();
const avisController = require('../controllers/avisController');

// Routes pour les avis
router.get('/site/:id_site', avisController.getAvisBySite);
router.post('/', avisController.ajouterAvis);

module.exports = router;