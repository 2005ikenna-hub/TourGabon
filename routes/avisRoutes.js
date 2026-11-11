const express = require('express');
const router = express.Router();
const avisController = require('../controllers/avisController');
const { requireAuth } = require('../middleware/auth');

router.get('/site/:id_site', avisController.getAvisBySite);
router.get('/evenement/:id_evenement', avisController.getAvisByEvenement);
router.post('/', requireAuth, avisController.ajouterAvis);

module.exports = router;
