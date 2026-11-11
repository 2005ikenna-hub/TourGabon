import '../site_touristique.dart';
import 'site_catalog.dart';

/// Catalogue de secours (hors-ligne / API injoignable et tests).
/// Il reprend les mêmes sites que la base tourGabon_db (database/donnees.sql).
class DemoSiteCatalog implements SiteCatalog {
  const DemoSiteCatalog();

  static const _sites = [
    SiteTouristique(
      id: '1',
      nom: 'Parc national de Loango',
      description:
          'Situé sur la côte atlantique, dans la province de l\'Ogooué-Maritime (Gamba), Loango est célèbre pour ses paysages mêlant plages, lagunes, savanes et forêt. On y observe des éléphants de forêt, des buffles, des hippopotames, des gorilles et, de juillet à septembre, des baleines à bosse au large.',
      latitude: -2.25,
      longitude: 9.6167,
      categorie: 'Nature',
      urlPhotos: '',
    ),
    SiteTouristique(
      id: '2',
      nom: 'Parc national de la Lopé',
      description:
          'Situé dans la province de l\'Ogooué-Ivindo, ce parc est inscrit au patrimoine mondial de l\'UNESCO (2007) pour son écosystème de forêt-savane et ses sites archéologiques. Il abrite l\'une des plus grandes concentrations de mandrills au monde.',
      latitude: -0.5,
      longitude: 11.5,
      categorie: 'Nature',
      urlPhotos: '',
    ),
    SiteTouristique(
      id: '3',
      nom: 'Parc national d\'Ivindo et chutes de Kongou',
      description:
          'Parc de forêt dense du nord-est du Gabon, inscrit au patrimoine mondial de l\'UNESCO en 2021. Il est connu pour les chutes de Kongou, parmi les plus impressionnantes d\'Afrique centrale, et pour ses clairières (baïs) fréquentées par les éléphants et les gorilles.',
      latitude: 0.58,
      longitude: 12.5,
      categorie: 'Nature',
      urlPhotos: '',
    ),
    SiteTouristique(
      id: '4',
      nom: 'Parc national de Moukalaba-Doudou',
      description:
          'Situé dans le sud-ouest du pays (province de la Nyanga), ce parc de forêt et de savane est réputé pour ses gorilles des plaines de l\'Ouest et ses chimpanzés. C\'est une destination pour les amateurs de randonnée et d\'observation de la faune.',
      latitude: -2.9,
      longitude: 10.55,
      categorie: 'Nature',
      urlPhotos: '',
    ),
    SiteTouristique(
      id: '5',
      nom: 'Parc national de Mayumba',
      description:
          'Parc côtier et marin du sud du Gabon, célèbre pour la ponte des tortues luth et pour l\'observation des baleines à bosse en saison. Ses longues plages sauvages bordent l\'océan Atlantique.',
      latitude: -3.43,
      longitude: 10.65,
      categorie: 'Nature',
      urlPhotos: '',
    ),
    SiteTouristique(
      id: '6',
      nom: 'Parc national de Pongara',
      description:
          'Situé à proximité de Libreville, sur l\'estuaire du Komo, le parc de Pongara protège plages, mangroves et forêt côtière. C\'est un site majeur de ponte des tortues luth, de novembre à février environ.',
      latitude: 0.1,
      longitude: 9.35,
      categorie: 'Nature',
      urlPhotos: '',
    ),
    SiteTouristique(
      id: '7',
      nom: 'Parc national des Monts de Cristal',
      description:
          'Massif forestier du nord-ouest du Gabon, à environ une heure et demie de Libreville, riche en cascades, en rivières et en biodiversité. Il offre des sentiers de randonnée et une grande variété d\'oiseaux et de primates.',
      latitude: 0.45,
      longitude: 10.3,
      categorie: 'Nature',
      urlPhotos: '',
    ),
    SiteTouristique(
      id: '8',
      nom: 'Parc national de Minkébé',
      description:
          'L\'un des parcs les plus vastes et les plus isolés du Gabon, dans l\'extrême nord-est. Cette forêt primaire protège notamment des éléphants de forêt et d\'autres espèces rares. L\'accès y est difficile et réservé aux expéditions bien préparées.',
      latitude: 1.5,
      longitude: 12.8,
      categorie: 'Nature',
      urlPhotos: '',
    ),
    SiteTouristique(
      id: '9',
      nom: 'Parc national d\'Akanda',
      description:
          'Situé au nord de Libreville, ce parc protège des mangroves et des vasières de la baie de Corisco, essentielles pour les oiseaux migrateurs. Il est reconnu comme zone humide d\'importance internationale (Ramsar).',
      latitude: 0.6667,
      longitude: 9.5333,
      categorie: 'Nature',
      urlPhotos: '',
    ),
    SiteTouristique(
      id: '10',
      nom: 'Hôpital Albert Schweitzer de Lambaréné',
      description:
          'Fondé en 1913 par le docteur Albert Schweitzer sur les rives de l\'Ogooué, l\'hôpital de Lambaréné est un lieu d\'histoire de la médecine en Afrique. Un musée permet de découvrir la vie et l\'oeuvre du docteur.',
      latitude: -0.7,
      longitude: 10.23,
      categorie: 'Culture',
      urlPhotos: '',
    ),
    SiteTouristique(
      id: '11',
      nom: 'Musée national des Arts et Traditions du Gabon',
      description:
          'Situé à Libreville, ce musée présente des objets d\'art et de tradition des différents peuples du Gabon, dont des masques et des statues rituelles. C\'est une bonne introduction à la diversité culturelle du pays.',
      latitude: 0.39,
      longitude: 9.45,
      categorie: 'Culture',
      urlPhotos: '',
    ),
    SiteTouristique(
      id: '12',
      nom: 'Église Saint-Michel de Nkembo',
      description:
          'Église catholique du quartier de Nkembo à Libreville, remarquable par son architecture et ses décors en bois. Elle est l\'un des édifices religieux les plus visités de la capitale.',
      latitude: 0.4116,
      longitude: 9.45,
      categorie: 'Culture',
      urlPhotos: '',
    ),
    SiteTouristique(
      id: '13',
      nom: 'Marché de Mont-Bouët',
      description:
          'Le plus grand marché de Libreville, où l\'on trouve produits frais, épices, tissus, artisanat et objets du quotidien. C\'est un lieu vivant pour découvrir la vie locale et la cuisine gabonaise.',
      latitude: 0.4005,
      longitude: 9.4528,
      categorie: 'Culture',
      urlPhotos: '',
    ),
    SiteTouristique(
      id: '14',
      nom: 'Boulevard Triomphal Omar Bongo',
      description:
          'Grande avenue du front de mer de Libreville, bordée par l\'océan et plusieurs bâtiments institutionnels. Elle sert de cadre aux grandes cérémonies nationales, comme les célébrations de la fête de l\'indépendance.',
      latitude: 0.39,
      longitude: 9.44,
      categorie: 'Culture',
      urlPhotos: '',
    ),
    SiteTouristique(
      id: '15',
      nom: 'Cap Estérias',
      description:
          'Station balnéaire au nord de Libreville, appréciée des habitants le week-end pour ses plages de sable et ses restaurants de poisson et de fruits de mer.',
      latitude: 0.6,
      longitude: 9.35,
      categorie: 'Plage',
      urlPhotos: '',
    ),
    SiteTouristique(
      id: '16',
      nom: 'Lagune Fernan-Vaz (Omboué)',
      description:
          'Vaste lagune de la province de l\'Ogooué-Maritime, entre l\'océan et la forêt, accessible depuis Omboué. Elle permet des excursions en pirogue, l\'observation de la nature et la découverte de la vie des villages de pêcheurs.',
      latitude: -1.57,
      longitude: 9.26,
      categorie: 'Nature',
      urlPhotos: '',
    ),
    SiteTouristique(
      id: '17',
      nom: 'Cap Lopez (Port-Gentil)',
      description:
          'Pointe nord de la presqu\'île de Port-Gentil, capitale économique du Gabon, appréciée pour ses plages et son ambiance maritime. C\'est un point de départ pour découvrir la côte et le delta.',
      latitude: -0.62,
      longitude: 8.71,
      categorie: 'Plage',
      urlPhotos: '',
    ),
    SiteTouristique(
      id: '18',
      nom: 'Pointe-Denis',
      description:
          'Presqu\'île située en face de Libreville, sur l\'estuaire du Komo, appréciée pour ses plages, ses balades en bateau et son ambiance détendue. On l\'atteint depuis Libreville par bateau.',
      latitude: 0.35,
      longitude: 9.3167,
      categorie: 'Plage',
      urlPhotos: '',
    ),
  ];

  @override
  Future<List<SiteTouristique>> obtenirSitesParLangue(String codeLangue) async {
    return _sites;
  }
}
