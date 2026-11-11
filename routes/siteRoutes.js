const express = require('express');
const router = express.Router();
const siteController = require('../controllers/siteController');
const { requireAuth, requireType } = require('../middleware/auth');

router.get('/', siteController.getAllSites);
router.post('/', requireAuth, requireType('Admin'), siteController.ajouterSite);
router.delete('/:id', requireAuth, requireType('Admin'), siteController.supprimerSite);

module.exports = router;
