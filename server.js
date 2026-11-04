const express = require('express');
const cors = require('cors');
require('dotenv').config();

const siteRoutes = require('./routes/siteRoutes');
const authRoutes = require('./routes/authRoutes');

const app = express();
const PORT = process.env.PORT || 3000;

// Middlewares
app.use(cors());
app.use(express.json());

// Déclaration des routes API
app.use('/api/sites', siteRoutes);
app.use('/api/auth', authRoutes);

// Route de test
app.get('/', (req, res) => {
  res.send('API TourGabon en cours d\'exécution...');
});

// Lancement du serveur
app.listen(PORT, () => {
  console.log(`Serveur démarré sur http://localhost:${PORT}`);
});