const express = require('express');
const router = express.Router();
const evenementController = require('../controllers/evenementController');

router.get('/', evenementController.getAllEvenements);
router.post('/', evenementController.ajouterEvenement);

module.exports = router;