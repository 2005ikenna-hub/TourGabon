import '../site_touristique.dart';
import 'site_catalog.dart';

class DemoSiteCatalog implements SiteCatalog {
  const DemoSiteCatalog();

  static const _sites = [
    SiteTouristique(
      id: '1',
      nom: 'Parc national de Loango',
      description:
          'Entre forêt, lagunes et océan, Loango révèle la richesse des '
          'paysages gabonais. Cette visite est aussi l’occasion de découvrir '
          'les liens entre les habitants, leur environnement et les savoirs '
          'transmis au fil des générations. En explorant ce territoire, '
          'respectez les communautés locales et les équilibres naturels qui '
          'font partie du patrimoine du Gabon.',
      latitude: -2.2500,
      longitude: 9.6167,
      categorie: 'Nature',
      urlPhotos: '',
    ),
    SiteTouristique(
      id: '2',
      nom: 'Pointe-Denis',
      description:
          'Face à Libreville, Pointe-Denis invite à découvrir la vie du '
          'littoral gabonais, entre traversées en bateau, plages et rencontres '
          'locales. Prenez le temps d’observer les usages du lieu et de '
          'respecter les traditions ainsi que les espaces partagés par les '
          'habitants et les visiteurs.',
      latitude: 0.3500,
      longitude: 9.3167,
      categorie: 'Plage',
      urlPhotos: '',
    ),
    SiteTouristique(
      id: '3',
      nom: 'Parc national de la Lopé',
      description:
          'La Lopé rassemble forêts, savanes et traces d’une longue présence '
          'humaine. Ce paysage invite à mieux comprendre le patrimoine '
          'gabonais et la relation durable entre les populations et leur '
          'territoire. La visite prend tout son sens lorsqu’elle s’accompagne '
          'd’écoute, de respect des sites patrimoniaux et de considération '
          'pour les communautés voisines.',
      latitude: -0.5000,
      longitude: 11.5000,
      categorie: 'Nature',
      urlPhotos: '',
    ),
    SiteTouristique(
      id: '4',
      nom: 'Lambaréné',
      description:
          'Au bord de l’Ogooué, Lambaréné est une ville façonnée par le fleuve '
          'et les échanges entre les communautés de la région des lacs. '
          'Découvrez son histoire et la diversité des cultures gabonaises '
          'à travers les récits, les rencontres et les savoir-faire locaux. '
          'Une visite attentive permet de mieux apprécier la mémoire vivante '
          'de cette région.',
      latitude: -0.7000,
      longitude: 10.2333,
      categorie: 'Ville',
      urlPhotos: '',
    ),
    SiteTouristique(
      id: '5',
      nom: 'Parc national de Pongara',
      description:
          'Accessible en bateau depuis Libreville, Pongara associe mangroves, '
          'plages et forêt littorale. Ces milieux sont étroitement liés aux '
          'modes de vie et aux savoirs des communautés côtières. Découvrez '
          'ce patrimoine naturel et humain avec attention : respectez les '
          'lieux, la faune et les personnes qui font vivre ce territoire.',
      latitude: 0.1000,
      longitude: 9.3500,
      categorie: 'Nature',
      urlPhotos: '',
    ),
    SiteTouristique(
      id: '6',
      nom: 'Cap Esterias',
      description:
          'Au nord de Libreville, Cap Esterias offre une découverte du '
          'littoral gabonais entre plages et forêt côtière. Cette escapade '
          'permet d’apprécier les liens entre le paysage, les activités '
          'quotidiennes et les traditions locales. En chemin, privilégiez '
          'les échanges respectueux et prenez soin des espaces partagés.',
      latitude: 0.6000,
      longitude: 9.3500,
      categorie: 'Plage',
      urlPhotos: '',
    ),
    SiteTouristique(
      id: '7',
      nom: 'Libreville',
      description:
          'Capitale du Gabon, Libreville s’étend entre l’estuaire du Komo '
          'et l’océan Atlantique. Ses marchés, ses quartiers et ses lieux '
          'culturels racontent une ville façonnée par les rencontres et '
          'les traditions de tout le pays.',
      latitude: 0.4162,
      longitude: 9.4673,
      categorie: 'Ville',
      urlPhotos: '',
    ),
    SiteTouristique(
      id: '8',
      nom: 'Port-Gentil',
      description:
          'Deuxième grande ville du Gabon, Port-Gentil vit au rythme du '
          'littoral, du port et des échanges maritimes. Découvrez ses '
          'quartiers, ses plages et la culture des communautés de la '
          'province de l’Ogooué-Maritime.',
      latitude: -0.7193,
      longitude: 8.7815,
      categorie: 'Ville',
      urlPhotos: '',
    ),
    SiteTouristique(
      id: '9',
      nom: 'Franceville',
      description:
          'Au sud-est du pays, Franceville est une ville importante du '
          'Haut-Ogooué et une porte d’entrée vers les paysages du plateau '
          'Batéké. Ses marchés et sa vie quotidienne reflètent les '
          'traditions et le dynamisme de la région.',
      latitude: -1.6333,
      longitude: 13.5833,
      categorie: 'Ville',
      urlPhotos: '',
    ),
    SiteTouristique(
      id: '10',
      nom: 'Oyem',
      description:
          'Au nord du Gabon, Oyem est le principal centre urbain du Woleu-Ntem. '
          'La ville est un point de rencontre pour découvrir les savoir-faire, '
          'les marchés et les traditions des communautés du Nord.',
      latitude: 1.5995,
      longitude: 11.5793,
      categorie: 'Ville',
      urlPhotos: '',
    ),
    SiteTouristique(
      id: '11',
      nom: 'Culture gabonaise',
      description:
          'Découvrez la diversité des traditions du Gabon à travers les '
          'danses, les cérémonies, les arts et les savoir-faire transmis '
          'entre générations. Ces images évoquent différentes expressions '
          'culturelles du pays : chacune s’inscrit dans une communauté et '
          'un contexte qui méritent écoute et respect.',
      latitude: 0.4162,
      longitude: 9.4673,
      categorie: 'Culture',
      urlPhotos: '',
    ),
    SiteTouristique(
      id: '12',
      nom: 'Hébergements au Gabon',
      description:
          'Cette galerie rassemble des images d’hôtels et de leurs espaces '
          'de séjour. Le Radisson Blu et l’Hôtel Le Cristal sont identifiables '
          'sur certaines photos ; les autres établissements ne sont pas '
          'confirmés. Le repère sur la carte est indicatif et situé à '
          'Libreville : vérifiez directement les adresses, services et '
          'disponibilités auprès des hôtels.',
      latitude: 0.4162,
      longitude: 9.4673,
      categorie: 'Hôtel',
      urlPhotos: '',
    ),
  ];

  @override
  Future<List<SiteTouristique>> obtenirSitesParLangue(String codeLangue) async {
    return _sites;
  }
}
