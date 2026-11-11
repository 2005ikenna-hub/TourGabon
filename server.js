require('dotenv').config();
const express = require('express');
const cors = require('cors');

const siteRoutes = require('./routes/siteRoutes');
const authRoutes = require('./routes/authRoutes');
const avisRoutes = require('./routes/avisRoutes');
const evenementRoutes = require('./routes/evenementRoutes');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.use('/api/sites', siteRoutes);
app.use('/api/auth', authRoutes);
app.use('/api/avis', avisRoutes);
app.use('/api/evenements', evenementRoutes);

app.get('/', (req, res) => {
  res.send("API TourGabon en cours d'exécution...");
});

app.listen(PORT, () => {
  console.log(`Serveur démarré sur http://localhost:${PORT}`);
});
