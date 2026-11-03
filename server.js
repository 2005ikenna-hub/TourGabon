const express = require('express');
const app = express();

app.get('/', (req, res) => {
  res.json({ message: 'API Tourisme Gabon opérationnelle' });
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Serveur démarré sur le port ${PORT}`);
});