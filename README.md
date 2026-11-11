# TourGabon

Application mobile de tourisme au Gabon, en architecture MVC (cahier des charges : `docs/cahier_des_charges_mvc_tourisme_ameliore.pdf`).

```
Flutter (Vue)  ──HTTP/JSON──►  API Node.js/Express (Contrôleur)  ──TCP 3307──►  XMLForge (base tourGabon_db)
```

La vue Flutter ne parle jamais directement à la base : tout passe par l'API.

## 1. Base de données (XMLForge)

1. Dans XMLForge, créer la base `tourGabon_db` (ou importer `database/tourGabon_db.xml`, qui contient la structure).
2. Dans **Paramètres**, créer un identifiant TCP dédié à l'application (distinct du compte de l'interface).
3. Charger les données : `npm run seed` (crée les tables et insère les données) ou, si les tables existent déjà, `npm run seed -- --donnees`.

Contenu : 18 sites réels du Gabon (traduits fr/en), 21 événements (calendrier 2026-2027), 10 comptes et 23 avis de démonstration.
Compte de test : `admin@tourgabon.example` / `Gabon@2026` (mêmes mots de passe pour tous les comptes de démonstration).
Types de compte : `Admin`, `Local`, `Étranger`.

## 2. API Node.js

```
npm install
cp .env.example .env     # renseigner XMLFORGE_USER, XMLFORGE_PASSWORD, JWT_SECRET
npm start                # http://localhost:3000
```

| Méthode | Route | Accès |
|---|---|---|
| GET | `/api/sites?lang=fr` | public |
| POST / DELETE | `/api/sites`, `/api/sites/:id` | Admin |
| GET | `/api/evenements?avenir=1` | public |
| POST | `/api/evenements` | Admin, Local |
| GET | `/api/avis/site/:id`, `/api/avis/evenement/:id` | public |
| POST | `/api/avis` | utilisateur connecté |
| POST | `/api/auth/register`, `/api/auth/login` | public |

## 3. Application Flutter

```
flutter pub get
flutter run                                   # émulateur Android : API sur http://10.0.2.2:3000
flutter run --dart-define=API_BASE_URL=http://192.168.1.20:3000   # téléphone réel
```

Si l'API est injoignable, l'application affiche le catalogue local (`lib/models/repositories/demo_site_catalog.dart`).

## 4. Photos des sites

Chaque site s'affiche avec une vraie photo du Gabon, choisie dans cet ordre :

1. `url_photos` (colonne de la table `Sites_Touristiques`) si elle est renseignée ;
2. sinon l'image principale de l'article Wikipédia du site, récupérée par `lib/models/data_sources/site_photo_service.dart` (images libres de Wikimedia Commons) ;
3. sinon une image de secours selon la catégorie (Nature / Culture / Plage).

Pour imposer une photo précise, renseigner `url_photos` pour le site concerné. Pour changer l'article utilisé, modifier la table `_articles` de `site_photo_service.dart` (clé = id du site). Si un site n'a pas son propre article, le service retombe sur celui de la ville ou de la région voisine.
