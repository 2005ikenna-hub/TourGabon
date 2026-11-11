const express = require('express');
const router = express.Router();
const evenementController = require('../controllers/evenementController');
const { requireAuth, requireType } = require('../middleware/auth');

router.get('/', evenementController.getAllEvenements);
router.post('/', requireAuth, requireType('Admin', 'Local'), evenementController.ajouterEvenement);

module.exports = router;
