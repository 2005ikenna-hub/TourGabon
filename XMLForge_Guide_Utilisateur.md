# XMLForge — Guide utilisateur

> Ce guide explique comment utiliser XMLForge au quotidien : se connecter, créer des bases et des tables, manipuler les données, écrire des requêtes SQL, connecter une application externe en TCP/IP et comprendre les erreurs courantes.

## 1. Présentation

XMLForge est un système de gestion de bases de données relationnelles. Vous pouvez :

- créer et gérer vos bases, tables, colonnes et lignes depuis l'interface ;
- exécuter des requêtes SQL depuis l'éditeur intégré ;
- importer et exporter vos données (XML, SQL, projet complet) ;
- partager vos bases avec d'autres utilisateurs, avec des niveaux d'accès ;
- connecter vos propres applications (Python, Node.js, PHP, etc.) via une connexion TCP/IP.

## 2. Premier lancement et connexion

### 2.1 Création de votre compte à l'installation

Lors de l'installation, une fenêtre (modal) s'ouvre pour créer le **compte administrateur** :

1. Saisissez votre **adresse e-mail**.
2. Saisissez votre **nom**.
3. Choisissez un **mot de passe** et confirmez-le.
4. Validez.

Ce compte est celui avec lequel vous vous connecterez à l'application. Il dispose des droits d'administration (gestion des utilisateurs, historique et audit).

> Conservez bien votre mot de passe : c'est le seul compte existant au départ.

### 2.2 Connexion

1. Ouvrez XMLForge.
2. Sur la page de connexion, saisissez l'e-mail et le mot de passe du compte créé à l'installation.
3. Vous arrivez sur le **tableau de bord**.

Les pages **Historique**, **Audit** et **Utilisateurs** sont réservées à l'administrateur.

### 2.3 Où sont stockées mes données ?

Les données sont enregistrées automatiquement sur votre machine, dans le dossier `%LOCALAPPDATA%\XMLForge` (version installée). Ne modifiez pas ces fichiers à la main pendant que l'application fonctionne. Pour sauvegarder vos données, utilisez plutôt la fonction **Export complet** (voir section 3.8).

### 2.4 Vérifier que l'application fonctionne

L'application est démarrée lorsque l'interface s'ouvre et que vous pouvez vous connecter. Si vous utilisez des applications externes, le serveur TCP écoute par défaut sur le port **3307**.

## 3. Utilisation de l'application

### 3.1 Créer une base de données

1. Ouvrez **Mes bases de données** dans le tableau de bord.
2. Cliquez sur **Nouvelle base**.
3. Saisissez le **nom** et la **description**.
4. Choisissez le type : `PERSONAL` ou `COMMON`.
5. Pour une base `COMMON`, choisissez le niveau d'accès collectif : `VIEW`, `EDIT` ou `MANAGE`.
6. Cliquez sur **Créer la base**.

**Types de bases**

| Type       | Description                                                                                               |
| ---------- | --------------------------------------------------------------------------------------------------------- |
| `PERSONAL` | Privée par défaut. Seul son propriétaire y accède, mais il peut la partager.                               |
| `COMMON`   | Accessible à tous les utilisateurs actifs, selon le niveau collectif choisi (`VIEW`, `EDIT` ou `MANAGE`). |

**Règle de nommage** : le nom doit être un identifiant valide : lettres, chiffres et `_`, **sans commencer par un chiffre**. Exemples valides : `Bibliotheque`, `ma_base_2`. Exemple invalide : `2024_ventes`.

> Vous pouvez aussi créer une base avec `CREATE DATABASE nom` dans l'éditeur SQL. Dans ce cas, la base est toujours de type `PERSONAL` et vous en êtes propriétaire. Pour choisir le type, la description ou le niveau commun, utilisez le bouton **Nouvelle base**.

### 3.2 Ouvrir une base et créer une table

1. Dans le tableau de bord, cliquez sur **Ouvrir** sur la base voulue.
2. Dans l'espace de travail, cliquez sur **Nouvelle table**.
3. Définissez le **nom de la table**, les **colonnes**, leurs **types** et leurs **contraintes**.
4. Validez (votre niveau d'accès doit autoriser la modification de structure).

L'espace de travail affiche la liste des tables, le nombre de colonnes de chacune, leur état (archivée ou non) et leur protection éventuelle. Une table **protégée** nécessite de cliquer sur **Déverrouiller** et de saisir sa clé avant toute écriture ou modification de structure.

La même création est possible en SQL (voir section 4). Les clés primaires et étrangères doivent être déclarées **directement sur la colonne**, par exemple `id INT PRIMARY KEY` et `author_id INT REFERENCES authors(id)`.

### 3.3 Gérer les colonnes

Dans l'espace de travail, vous pouvez **ajouter**, **modifier** et **supprimer** des colonnes, si votre niveau d'accès le permet. Équivalents SQL : `ALTER TABLE ... ADD COLUMN`, `MODIFY COLUMN` et `DROP COLUMN`.

Lors d'une modification de colonne, l'application contrôle les noms, les types autorisés, l'obligation de valeur (`NOT NULL`), la longueur des `VARCHAR/CHAR`, les valeurs par défaut et les références. **Une modification incompatible avec les données déjà présentes est refusée.**

### 3.4 Insérer des données

Dans l'espace de travail, ouvrez la vue des lignes et utilisez l'action d'ajout de ligne. L'application vérifie les types, les valeurs obligatoires, les clés et la version des données. Si la colonne est `AUTO_INCREMENT`, la valeur est attribuée automatiquement.

Pour insérer plusieurs lignes ou des valeurs précises, utilisez l'éditeur SQL avec `INSERT INTO`.

### 3.5 Consulter les données

Sélectionnez une table pour afficher ses colonnes et ses lignes. Vous pouvez paginer, rechercher, filtrer et trier. L'éditeur SQL permet les mêmes lectures avec `SELECT`, y compris filtres, jointures, agrégats et pagination.

### 3.6 Modifier et supprimer des lignes

Les actions de ligne dans l'espace de travail permettent de modifier ou supprimer. L'application vérifie la protection de la table, vos droits d'écriture et que la ligne n'a pas été modifiée entre-temps par quelqu'un d'autre.

En SQL, `UPDATE` et `DELETE` **exigent obligatoirement une clause `WHERE`**. Cela évite de modifier ou supprimer toute une table par erreur.

### 3.7 Éditeur SQL

L'éditeur SQL permet d'exécuter les requêtes décrites en section 4 sur la base ouverte. Le point-virgule final est facultatif.

### 3.8 Import et export

Le tableau de bord propose **Importer** et **Export complet**. L'espace de travail propose **Exporter SQL**.

Imports disponibles :

- **XML** : structure, tables, colonnes et données ;
- **SQL** : un script SQL converti, avec les limites du SQL supporté (section 4) ;
- **Projet XMLForge** : structure, données et métadonnées d'un export complet.

L'espace de travail propose aussi la conversion XML vers SQL, SQL vers XML, la synchronisation XML et l'export d'une seule table.

> Faites régulièrement un **Export complet** : c'est votre sauvegarde.

### 3.9 Partage, archivage et protection

Selon vos droits, le tableau de bord permet de **modifier**, **dupliquer**, **gérer les accès**, **archiver/restaurer** et **supprimer** une base. L'espace de travail permet de **partager**, **archiver** des tables et **déverrouiller** les tables protégées.

Si deux personnes modifient la même donnée en même temps, un **dialogue de conflit** vous prévient et vous laisse décider.

## 4. SQL supporté

Les requêtes se saisissent dans l'éditeur SQL ou s'envoient par TCP (section 6). Les mots-clés sont insensibles à la casse. Le point-virgule final est facultatif.

### CREATE DATABASE — supporté avec restriction

```sql
CREATE DATABASE Bibliotheque;
```

Crée toujours une base `PERSONAL` appartenant à l'utilisateur courant. Pour choisir description, type ou niveau commun, utilisez **Nouvelle base** dans l'interface.

### CREATE TABLE — supporté avec restrictions

```sql
CREATE TABLE authors (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    name VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE books (
    id INT PRIMARY KEY AUTO_INCREMENT,
    author_id INT REFERENCES authors(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    price DECIMAL DEFAULT 0
);
```

Les contraintes se déclarent **au niveau de la colonne**. Les formes `PRIMARY KEY (a,b)` et `FOREIGN KEY (a) REFERENCES ...` placées en fin de table ne sont **pas acceptées** : la clé primaire est donc simple (une seule colonne).

### INSERT — supporté

```sql
INSERT INTO authors (name) VALUES ('Alice');
INSERT INTO books (title, author_id, price)
VALUES ('XML pratique', 1, 29.90), ('TCP en bref', 1, 12.50);
INSERT INTO authors VALUES ('Bob');
INSERT INTO authors VALUES ();
```

- Les colonnes peuvent être indiquées ou omises (dans ce cas, l'ordre du schéma est utilisé).
- Plusieurs lignes dans un seul `INSERT` sont acceptées et traitées en une seule opération.
- Littéraux valides : `NULL`, `TRUE`, `FALSE`, nombres, chaînes entre apostrophes.
- Une apostrophe dans une chaîne s'écrit `''` (exemple : `'l''été'`).

### SELECT — supporté

```sql
SELECT * FROM books;
SELECT id, title AS label FROM books WHERE price >= 10 ORDER BY price DESC LIMIT 20 OFFSET 0;
SELECT DISTINCT author_id FROM books;
SELECT b.title, a.name FROM books b INNER JOIN authors a ON b.author_id = a.id;
SELECT a.name, COUNT(*) AS total FROM authors a LEFT JOIN books b ON a.id = b.author_id GROUP BY a.name HAVING COUNT(*) >= 1;
```

Supportés :

- `*`, colonnes qualifiées (`table.colonne` ou `alias.colonne`), alias avec `AS`, `DISTINCT` ;
- `WHERE` avec parenthèses, `AND`, `OR` ;
- comparaisons `=`, `!=`, `<>`, `<`, `<=`, `>`, `>=` ;
- `LIKE`, `NOT LIKE`, `IN`, `NOT IN`, `BETWEEN`, `IS NULL`, `IS NOT NULL` ;
- `INNER JOIN`, `JOIN`, `LEFT JOIN`, `LEFT OUTER JOIN` ;
- `ORDER BY` sur plusieurs colonnes, `ASC`, `DESC` ;
- `LIMIT`, `OFFSET` ;
- `GROUP BY` et `HAVING`.

Le `LIMIT` par défaut est **100** lignes. Agrégats disponibles : `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`. `COUNT(DISTINCT ...)` est refusé.

### UPDATE — supporté avec restriction

```sql
UPDATE books SET price = 19.90, title = 'XML avancé' WHERE id = 1;
```

- Plusieurs colonnes peuvent être modifiées en une fois.
- Les valeurs de `SET` doivent être des **littéraux** : `price = price - 1` n'est pas supporté.
- `WHERE` est **obligatoire**.

### DELETE — supporté avec restriction

```sql
DELETE FROM books WHERE id = 2;
```

`WHERE` est obligatoire : `DELETE FROM books` est refusé. Si la condition correspond à plusieurs lignes, elles sont toutes supprimées.

### ALTER TABLE — supporté avec restrictions

```sql
ALTER TABLE books ADD COLUMN isbn VARCHAR(20) UNIQUE;
ALTER TABLE books MODIFY COLUMN title VARCHAR(250) NOT NULL;
ALTER TABLE books DROP COLUMN isbn;
ALTER TABLE books RENAME TO publications;
```

Seuls `ADD COLUMN`, `MODIFY COLUMN`, `DROP COLUMN` et `RENAME TO` sont supportés. **`RENAME COLUMN` n'est pas supporté.**

### DROP TABLE — supporté

```sql
DROP TABLE publications;
```

La suppression est refusée si la table est encore référencée par une clé étrangère d'une autre table.

### Index — supporté

```sql
CREATE INDEX books_author_idx ON books (author_id);
CREATE UNIQUE INDEX books_title_idx ON books (title);
DROP INDEX books_title_idx ON books;
```

Les index simples (une colonne) et composites (plusieurs colonnes) sont acceptés.

### USE et transactions — uniquement en session TCP

```sql
USE Bibliotheque;
BEGIN;
-- INSERT / UPDATE / DELETE ou modifications de structure
COMMIT;
-- ou ROLLBACK;
```

`START TRANSACTION` est un synonyme de `BEGIN`. Voir la section 7 pour le détail et les limites.

### Non supporté actuellement

- `RIGHT JOIN` ;
- `FULL JOIN` et `FULL OUTER JOIN` ;
- sous-requêtes ;
- `UNION` ;
- `COUNT(DISTINCT ...)` ;
- `RENAME COLUMN` ;
- contraintes de table composites (clé primaire ou étrangère sur plusieurs colonnes) ;
- expressions arithmétiques dans `UPDATE SET` ;
- `WITH`, `CASE`, `WINDOW`, `RETURNING` ;
- `CHECK` ;
- paramètres préparés (`?`, `$1`, `:name`) : la requête doit être envoyée comme texte SQL complet ;
- commentaires SQL.

## 5. Types de données, contraintes et règles de syntaxe

### 5.1 Types de données

| Famille    | Types supportés                                   | Remarques                                                      |
| ---------- | ------------------------------------------------- | -------------------------------------------------------------- |
| Entiers    | `INTEGER`, `INT`, `BIGINT`, `SMALLINT`, `TINYINT` | valeurs numériques validées                                    |
| Texte      | `TEXT`, `VARCHAR`, `CHAR`, `CLOB`                 | `VARCHAR(n)` et `CHAR(n)` contrôlent la longueur               |
| Décimal    | `REAL`, `FLOAT`, `DOUBLE`, `DECIMAL`, `NUMERIC`   | valeurs numériques validées                                    |
| Booléen    | `BOOLEAN`, `BOOL`                                 | littéraux `TRUE` et `FALSE`                                    |
| Date/heure | `DATE`, `DATETIME`, `TIMESTAMP`, `TIME`           | formats validés ; `CURRENT_TIMESTAMP` autorisé comme défaut    |
| Binaire    | `BLOB`                                            |                                                                |
| Structuré  | `JSON`                                            | le contenu est validé                                          |

Aucun autre type n'est garanti : un type inconnu provoque l'erreur `Type de colonne non supporté`. `NULL`, la chaîne vide et la chaîne `'NULL'` sont **trois valeurs différentes**.

### 5.2 Contraintes

| Fonctionnalité      | Statut                     | Syntaxe / limite                                                |
| ------------------- | -------------------------- | --------------------------------------------------------------- |
| `PRIMARY KEY`       | Supportée                  | sur une seule colonne, déclarée sur la colonne                  |
| `AUTO_INCREMENT`    | Supportée                  | compteur conservé, valeur jamais réutilisée après suppression   |
| `UNIQUE`            | Supportée                  | sur la colonne ou via un index unique                           |
| `NOT NULL`          | Supportée                  | contrôlée à l'insertion et à la modification                    |
| `DEFAULT`           | Supportée                  | littéral ou `CURRENT_TIMESTAMP`                                 |
| Clé étrangère       | Supportée avec restriction | `REFERENCES table(colonne)` ou `table.colonne`, sur la colonne  |
| Actions de clé étrangère | Supportées            | `NO ACTION`, `RESTRICT`, `CASCADE`, `SET NULL`                  |
| Index               | Supportée                  | simples et composites                                           |
| Protection de table | Supportée                  | clé de déverrouillage (via l'interface ou TCP)                  |
| Contrôle de version | Supportée                  | `expected_version` en TCP                                       |

Les contraintes de table composites et `CHECK` ne sont pas supportées.

### 5.3 Règles de syntaxe

**Identifiants (noms de bases, tables, colonnes)**

- Format : lettres, chiffres et `_`, **sans commencer par un chiffre** (`[A-Za-z_][A-Za-z0-9_]*`).
- Un identifiant peut aussi être entouré de backticks, mais le nom doit rester valide.
- Qualification limitée à `table.colonne` ou `alias.colonne`.

**Valeurs**

- Chaîne : `'Alice'` ; apostrophe échappée : `'l''été'`.
- Entier : `12` ; réel : `12.50`.
- Nul : `NULL`. Booléen : `TRUE` ou `FALSE`.
- Séparateurs : virgule et parenthèses ; point-virgule final facultatif.
- Les mots-clés sont insensibles à la casse (`select` = `SELECT`).

### 5.4 Exemples de requêtes invalides

```sql
SELECT FROM books;
```
Refusée : une liste de colonnes (ou `*`) est obligatoire.

```sql
INSERT books VALUES ('x');
```
Refusée : `INTO` est obligatoire.

```sql
UPDATE books SET title = 'x';
```
Refusée : `WHERE` est obligatoire.

```sql
DELETE FROM books;
```
Refusée : `WHERE` est obligatoire.

```sql
SELECT * FROM books RIGHT JOIN authors ON books.author_id = authors.id;
```
Refusée : `RIGHT JOIN` n'est pas supporté.

```sql
SELECT * FROM books WHERE id IN (SELECT id FROM authors);
```
Refusée : les sous-requêtes ne sont pas supportées.

```sql
UPDATE books SET price = price - 1 WHERE id = 1;
```
Refusée : les expressions arithmétiques ne sont pas supportées dans `SET`.

## 6. Connexion TCP/IP depuis une application externe

Vous pouvez connecter vos propres applications à XMLForge (Python, Node.js, PHP, etc.) via une connexion TCP.

### 6.1 Prérequis : créer un identifiant TCP

Les identifiants TCP sont **distincts** de votre mot de passe de connexion à l'interface. Créez un identifiant TCP **dédié à votre application** dans les **paramètres** de XMLForge, puis utilisez-le dans vos programmes.

### 6.2 Paramètres de connexion

- Hôte : `localhost` (ou l'adresse de la machine qui exécute XMLForge) ;
- Port par défaut : `3307` ;
- Encodage : UTF-8 ; contenu des messages : JSON ;
- Connexion persistante jusqu'à la fermeture (`MSG_CLOSE`), la coupure réseau ou l'expiration ;
- Expiration d'inactivité par défaut : **30 minutes** ; une session expirée doit être ré-authentifiée ;
- Taille maximale de données envoyées par connexion : **8 Mio** ;
- Plusieurs applications ou connexions peuvent se connecter en même temps.

### 6.3 Format des messages

Chaque message est exactement :

```text
[type : 1 octet][longueur : uint32 big-endian][contenu JSON UTF-8]
```

La longueur ne compte pas les cinq octets d'en-tête. Comme TCP peut fragmenter ou regrouper les messages, votre programme doit **lire jusqu'à obtenir la trame complète** (un seul appel de lecture ne suffit pas toujours).

### 6.4 Types de messages

| Type                  | Valeur | Direction          | Contenu                                                     |
| --------------------- | -----: | ------------------ | ----------------------------------------------------------- |
| `MSG_AUTH`            |      1 | client → serveur   | `username`, `password`, `database?`                         |
| `MSG_QUERY`           |      2 | client → serveur   | `session_token`, `query`, `expected_version?`, `table_key?` |
| `MSG_RESPONSE`        |      3 | serveur → client   | `status` et résultat                                        |
| `MSG_ERROR`           |      4 | serveur → client   | `code`, `message`, `error_code?`                            |
| `MSG_PING`            |      5 | client → serveur   | `{}`                                                        |
| `MSG_PONG`            |      6 | serveur → client   | `{}`                                                        |
| `MSG_SELECT_DATABASE` |      7 | client → serveur   | `session_token`, `database`                                 |
| `MSG_UNLOCK_TABLE`    |      8 | client → serveur   | `session_token`, `table`, `key`                             |
| `MSG_CLOSE`           |      9 | client → serveur   | `session_token`                                             |

### 6.5 Déroulement d'une session

```text
Connexion TCP
 → MSG_AUTH {username, password, database?}
 ← MSG_RESPONSE {status: 0, session_token, ...}
 → MSG_QUERY {session_token, query: "USE Bibliotheque"}
 ← MSG_RESPONSE {status: 2, result: {database_id, database_name}}
 → MSG_QUERY {session_token, query: "SELECT ..."}
 ← MSG_RESPONSE {status: 2, result: ...}
 → MSG_CLOSE {session_token}
 ← MSG_RESPONSE {status: 2, closed: true}
```

- `MSG_RESPONSE` avec `status = 0` : authentification réussie.
- `MSG_RESPONSE` avec `status = 2` : requête réussie.
- `MSG_ERROR` : l'opération a échoué ; utilisez `error_code` s'il est présent.
- `MSG_PING` peut être envoyé sans session et reçoit `MSG_PONG`.
- Chaque requête revérifie vos droits : un accès retiré prend effet immédiatement.

### 6.6 Envoyer et recevoir

**Pour envoyer** : sérialiser un objet JSON, l'encoder en UTF-8, calculer sa longueur **en octets**, ajouter le type sur 1 octet et la longueur sur 4 octets (big-endian), puis envoyer l'ensemble.

**Pour recevoir** : lire 5 octets, décoder la longueur, boucler jusqu'à obtenir exactement ce nombre d'octets, décoder l'UTF-8 puis analyser le JSON.

### 6.7 Exemple Python

```python
import json
import socket
import struct


def frame(message_type, payload):
    body = json.dumps(payload, separators=(",", ":")).encode("utf-8")
    return bytes([message_type]) + struct.pack("!I", len(body)) + body


def recv_exact(sock, size):
    data = b""
    while len(data) < size:
        chunk = sock.recv(size - len(data))
        if not chunk:
            raise ConnectionError("Connexion fermée")
        data += chunk
    return data


def receive(sock):
    header = recv_exact(sock, 5)
    size = struct.unpack("!I", header[1:5])[0]
    body = recv_exact(sock, size)
    return header[0], json.loads(body.decode("utf-8"))


with socket.create_connection(("127.0.0.1", 3307), timeout=30) as sock:
    sock.sendall(frame(1, {"username": "USER", "password": "PASSWORD"}))
    message_type, auth = receive(sock)
    token = auth["session_token"]

    sock.sendall(frame(2, {"session_token": token, "query": "USE Bibliotheque;"}))
    print(receive(sock))

    sock.sendall(frame(2, {"session_token": token, "query": "SELECT * FROM books;"}))
    print(receive(sock))

    sock.sendall(frame(9, {"session_token": token}))
    print(receive(sock))
```

Remplacez `USER` et `PASSWORD` par l'identifiant TCP créé dans les paramètres.

### 6.8 Exemple Node.js

Node.js n'a pas de client officiel, mais le protocole s'implémente avec le module standard `net` :

```js
import net from "node:net";

function frame(type, payload) {
  const body = Buffer.from(JSON.stringify(payload), "utf8");
  const header = Buffer.alloc(5);
  header.writeUInt8(type, 0);
  header.writeUInt32BE(body.length, 1);
  return Buffer.concat([header, body]);
}

const socket = net.createConnection({ host: "127.0.0.1", port: 3307 });
let buffer = Buffer.alloc(0);
let token;

socket.on("data", (chunk) => {
  buffer = Buffer.concat([buffer, chunk]);
  while (buffer.length >= 5) {
    const length = buffer.readUInt32BE(1);
    if (buffer.length < 5 + length) return;
    const type = buffer.readUInt8(0);
    const payload = JSON.parse(buffer.subarray(5, 5 + length).toString("utf8"));
    buffer = buffer.subarray(5 + length);
    console.log(type, payload);
    if (type === 3 && payload.status === 0) {
      token = payload.session_token;
      socket.write(
        frame(2, { session_token: token, query: "USE Bibliotheque;" }),
      );
    }
  }
});

socket.write(frame(1, { username: "USER", password: "PASSWORD" }));
```

Cet exemple illustre l'envoi et la lecture de messages regroupés. Une application réelle doit aussi gérer les erreurs, les délais d'attente et la fermeture propre.

### 6.9 Exemple PHP

```php
<?php
function frame(int $type, array $payload): string {
    $body = json_encode($payload, JSON_UNESCAPED_UNICODE | JSON_THROW_ON_ERROR);
    return pack('C', $type) . pack('N', strlen($body)) . $body;
}

$socket = stream_socket_client('tcp://127.0.0.1:3307', $errno, $error, 30);
if (!$socket) {
    throw new RuntimeException($error, $errno);
}

fwrite($socket, frame(1, ['username' => 'USER', 'password' => 'PASSWORD']));
$header = fread($socket, 5);
$type = ord($header[0]);
$length = unpack('N', substr($header, 1, 4))[1];
$body = '';
while (strlen($body) < $length) {
    $body .= fread($socket, $length - strlen($body));
}
$auth = json_decode($body, true, 512, JSON_THROW_ON_ERROR);
$token = $auth['session_token'];

fwrite($socket, frame(2, ['session_token' => $token, 'query' => 'SELECT * FROM books;']));
// Lire la réponse avec la même boucle : en-tête puis contenu.
fclose($socket);
```

Aucun client PHP officiel n'est fourni ; cet exemple montre comment implémenter le protocole.

### 6.10 Recommandations d'intégration

1. Créez un identifiant TCP **dédié** à chaque application.
2. Sélectionnez explicitement la base avec `USE` après la connexion.
3. Conservez le `session_token` et envoyez-le dans chaque message.
4. Traitez toujours `MSG_ERROR` et `error_code` au lieu de supposer que tout a réussi.
5. Utilisez `expected_version` pour détecter les conflits d'écriture.
6. Envoyez toutes les opérations d'une transaction sur **une seule connexion**.
7. Fermez proprement avec `MSG_CLOSE`.
8. N'accédez jamais directement aux fichiers de données : passez toujours par XMLForge.

## 7. Transactions (session TCP uniquement)

```text
USE Bibliotheque
BEGIN
INSERT INTO books (title) VALUES ('Transaction')
COMMIT
```

- `BEGIN` (ou `START TRANSACTION`) démarre une transaction.
- `COMMIT` valide, `ROLLBACK` annule et restaure l'état de la base au moment du `BEGIN`.
- Les modifications sont appliquées immédiatement : **il n'y a pas d'isolation**. Une autre connexion peut voir une modification non encore validée, et un `ROLLBACK` peut écraser une écriture faite entre-temps par quelqu'un d'autre.
- Une transaction ne couvre qu'**une seule base**.
- L'historique et l'audit ne sont pas annulés par un `ROLLBACK`.
- Les transactions ne sont disponibles que via TCP, pas depuis l'éditeur SQL de l'interface.

## 8. Résultats des requêtes

En TCP, une requête réussie renvoie un `MSG_RESPONSE` avec `status: 2`, un champ `result` et, pour les requêtes SQL ordinaires, des mesures de temps (`metrics`).

**Exemples de résultats**

```json
{"result":{"rows":[{"id":1,"title":"XML pratique"}],"columns":["id","title"],"total":1,"pagination":{"page":1,"page_size":100,"total":1,"total_pages":1,"current_page":1}}}
```

```json
{ "result": { "inserted": 1, "row": { "id": 1, "name": "Alice" } } }
```

```json
{ "result": { "updated": 1 } }
```

```json
{ "result": { "deleted": 1 } }
```

- `SELECT COUNT(*) FROM books` (seul agrégat, sans `GROUP BY`) renvoie `{"count": N, "table": "books"}`.
- Les modifications de structure renvoient par exemple `{"created":"books"}`, `{"dropped":"books"}`, `{"added":"isbn","table":"books"}` ou `{"renamed":"books","new_name":"publications"}`.

## 9. Gestion des erreurs

En TCP, une erreur arrive dans un `MSG_ERROR` :

```json
{
  "code": 3,
  "message": "Table active introuvable",
  "error_code": "TABLE_NOT_FOUND"
}
```

### Codes d'erreur courants

| `error_code`             | Signification                                                    |
| ------------------------ | ---------------------------------------------------------------- |
| `AUTH_FAILED`            | identifiant ou mot de passe TCP incorrect                        |
| `ACCESS_DENIED`          | droits insuffisants sur la base ou la table                      |
| `DATABASE_NOT_FOUND`     | la base demandée n'existe pas                                    |
| `DATABASE_NOT_SELECTED`  | aucune base sélectionnée : exécutez d'abord `USE nom_de_la_base` |
| `TABLE_NOT_FOUND`        | la table n'existe pas                                            |
| `COLUMN_NOT_FOUND`       | la colonne n'existe pas                                          |
| `SYNTAX_ERROR`           | erreur de syntaxe SQL                                            |
| `INVALID_QUERY`          | requête invalide ou construction non supportée                   |
| `DATA_INVALID`           | valeur incompatible avec le type de la colonne                   |
| `CONSTRAINT_VIOLATION`   | contrainte violée (clé unique, clé étrangère, `NOT NULL`...)     |
| `CONFLICT`               | la donnée a été modifiée entre-temps (conflit de version)        |
| `TRANSACTION_ACTIVE`     | une transaction est déjà en cours                                |
| `TRANSACTION_NOT_ACTIVE` | `COMMIT` ou `ROLLBACK` sans transaction en cours                 |
| `TRANSACTION_ERROR`      | erreur pendant la transaction                                    |
| `INTERNAL_ERROR`         | erreur interne du serveur                                        |

### Causes les plus fréquentes

- identifiants TCP incorrects ;
- aucune base sélectionnée (oubli de `USE`) ;
- droits insuffisants sur la base ou la table ;
- table ou colonne inexistante (faute de frappe) ;
- SQL invalide ou construction non supportée (voir « Non supporté actuellement ») ;
- valeur incompatible avec le type de la colonne ;
- contrainte violée (doublon sur une colonne `UNIQUE`, référence inexistante, valeur `NULL` sur une colonne `NOT NULL`) ;
- conflit de version : la donnée a été modifiée par quelqu'un d'autre ;
- table protégée non déverrouillée ;
- envoi de données trop volumineuses (au-delà de 8 Mio par connexion) ;
- session expirée après 30 minutes d'inactivité : reconnectez-vous.

## 10. Exemple complet : Users / Products / Orders

```sql
CREATE DATABASE Commerce;
USE Commerce;

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    price DECIMAL NOT NULL
);

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT REFERENCES users(id),
    product_id INT REFERENCES products(id),
    quantity INT DEFAULT 1
);

INSERT INTO users (name) VALUES ('Alice');
INSERT INTO products (name, price) VALUES ('Clavier', 49.90);
INSERT INTO orders (user_id, product_id, quantity) VALUES (1, 1, 2);

SELECT u.name, p.name, o.quantity
FROM orders o
INNER JOIN users u ON o.user_id = u.id
INNER JOIN products p ON o.product_id = p.id;

UPDATE products SET price = 44.90 WHERE id = 1;
DELETE FROM orders WHERE id = 1;
```

Les opérations de structure (`CREATE`, `ALTER`, `DROP`) nécessitent le droit correspondant sur la base ou la table. Les noms et valeurs ci-dessus sont des exemples : vos droits d'accès, vos tables et vos contraintes restent contrôlés par le serveur.

## 11. Limites actuelles

- pas d'isolation entre transactions concurrentes ; le `ROLLBACK` restaure l'état d'origine et peut écraser des écritures concurrentes ;
- une transaction ne couvre pas plusieurs bases ;
- `RIGHT JOIN`, `FULL JOIN`, sous-requêtes, `UNION`, `COUNT(DISTINCT ...)` et expressions SQL générales absents ;
- `UPDATE` et `DELETE` sans `WHERE` interdits ;
- clés primaires et étrangères composites non supportées ;
- les index sont reconstruits automatiquement après chaque redémarrage (le premier démarrage peut donc être un peu plus long sur de grosses bases) ;
- volume de données par connexion TCP limité à 8 Mio ;
- session TCP expirée après 30 minutes d'inactivité par défaut ;
- taille maximale des envois depuis l'interface : 16 Mio ;
- aucun client officiel pour Node.js et PHP (les exemples ci-dessus montrent comment implémenter le protocole) ;
- les connexions TCP ne sont **pas chiffrées** ;
- aucune garantie de performance comparable à un SGBD spécialisé sur de très gros volumes.

## 12. Sécurité

- L'accès à l'interface se fait avec votre compte (e-mail et mot de passe) ; l'accès TCP avec un identifiant TCP dédié.
- Les droits sont contrôlés à chaque opération : base, table, lecture, écriture, modification de structure, administration.
- Les tables sensibles peuvent être protégées par une clé de déverrouillage.
- **Les échanges TCP ne sont pas chiffrés** : identifiants et requêtes circulent en clair. Sur un réseau non fiable, utilisez un tunnel ou un proxy TLS (VPN, SSH, etc.) et évitez d'exposer le port TCP à Internet.
- Utilisez un mot de passe solide pour le compte administrateur et un identifiant TCP distinct par application.

## 13. Démarrage rapide

1. Installez XMLForge et créez votre compte dans la fenêtre qui s'ouvre à l'installation.
2. Lancez l'application et connectez-vous avec ce compte.
3. Cliquez sur **Nouvelle base** et renseignez le nom, la description et le type.
4. Ouvrez la base, puis cliquez sur **Nouvelle table**.
5. Ajoutez vos colonnes et vos contraintes.
6. Ajoutez des lignes depuis la vue des lignes ou avec `INSERT` dans l'éditeur SQL.
7. Consultez vos données avec `SELECT`.
8. Faites un **Export complet** pour sauvegarder votre travail.
9. Pour connecter une application : créez un identifiant TCP dans les paramètres, puis connectez-vous sur `localhost:3307` en suivant la section 6.

## 14. FAQ

**Comment créer une table ?**
Depuis l'espace de travail avec **Nouvelle table**, ou avec `CREATE TABLE` si vous avez le droit de modifier la structure.

**Comment insérer, lire, modifier et supprimer des données ?**
Avec la vue des lignes, ou avec `INSERT`, `SELECT`, `UPDATE`, `DELETE`. `UPDATE` et `DELETE` exigent un `WHERE`.

**Quel port utiliser pour connecter mon application ?**
Le port TCP par défaut est `3307`.

**Puis-je créer d'autres comptes ?**
Le compte créé à l'installation est administrateur. La gestion des utilisateurs se fait depuis la page **Utilisateurs**, réservée à l'administrateur.

**Les JOIN fonctionnent-ils ?**
`INNER JOIN`, `JOIN`, `LEFT JOIN` et `LEFT OUTER JOIN` fonctionnent. `RIGHT JOIN` et `FULL OUTER JOIN` ne fonctionnent pas.

**Les transactions fonctionnent-elles ?**
Oui, uniquement dans une session TCP, avec `BEGIN`/`START TRANSACTION`, `COMMIT` et `ROLLBACK`.

**Où sont mes données ?**
Dans le dossier `%LOCALAPPDATA%\XMLForge`. Ne modifiez pas ces fichiers pendant que l'application fonctionne ; utilisez l'**Export complet** pour sauvegarder.

**Comment gérer une erreur ?**
En TCP, lisez `MSG_ERROR` : `code`, `message` et `error_code`. Reportez-vous à la section 9.

**Le protocole est-il chiffré ?**
Non. Protégez le réseau séparément (voir section 12).

**Puis-je écrire directement dans les fichiers de données ?**
Non. Passez toujours par l'interface ou par la connexion TCP.

**Ma session TCP ne répond plus.**
Elle a probablement expiré après 30 minutes d'inactivité : reconnectez-vous avec `MSG_AUTH`.
