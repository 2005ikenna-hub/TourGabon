const mysql = require('mysql2/promise');

const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'tourGabon_db',
  port: 3307 // <-- Mets bien 3307 ici si c'est ton port XAMPP actuel
});

module.exports = pool;