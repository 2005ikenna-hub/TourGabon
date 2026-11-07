const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

router.post('/register', authController.inscrireUtilisateur);
router.post('/login', authController.connecterUtilisateur);

module.exports = router;