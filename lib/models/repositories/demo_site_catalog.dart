import '../site_touristique.dart';
import 'site_catalog.dart';

class DemoSiteCatalog implements SiteCatalog {
  const DemoSiteCatalog();

  static const _sites = [
    SiteTouristique(
      id: '1',
      nom: 'Parc national de Loango',
      description:
          'Entre forêt, lagunes et océan, Loango offre un aperçu exceptionnel '
          'des paysages sauvages du Gabon.',
      latitude: -2.2500,
      longitude: 9.6167,
      categorie: 'Nature',
      urlPhotos: '',
    ),
    SiteTouristique(
      id: '2',
      nom: 'Pointe-Denis',
      description:
          'Une presqu’île appréciée pour ses plages, ses balades en bateau '
          'et sa proximité avec Libreville.',
      latitude: 0.3500,
      longitude: 9.3167,
      categorie: 'Plage',
      urlPhotos: '',
    ),
    SiteTouristique(
      id: '3',
      nom: 'Parc national de la Lopé',
      description:
          'Un vaste espace naturel réputé pour ses forêts, ses savanes et '
          'son patrimoine archéologique.',
      latitude: -0.5000,
      longitude: 11.5000,
      categorie: 'Nature',
      urlPhotos: '',
    ),
    SiteTouristique(
      id: '4',
      nom: 'Lambaréné',
      description:
          'Découvrez la ville au bord de l’Ogooué et son histoire au cœur '
          'de la région des lacs.',
      latitude: -0.7000,
      longitude: 10.2333,
      categorie: 'Culture',
      urlPhotos: '',
    ),
    SiteTouristique(
      id: '5',
      nom: 'Parc national de Pongara',
      description:
          'Mangroves, plages et forêts composent ce parc accessible depuis '
          'Libreville par bateau.',
      latitude: 0.1000,
      longitude: 9.3500,
      categorie: 'Nature',
      urlPhotos: '',
    ),
    SiteTouristique(
      id: '6',
      nom: 'Cap Esterias',
      description:
          'Une escapade côtière au nord de Libreville, entre plages et '
          'paysages de forêt littorale.',
      latitude: 0.6000,
      longitude: 9.3500,
      categorie: 'Plage',
      urlPhotos: '',
    ),
  ];

  @override
  Future<List<SiteTouristique>> obtenirSitesParLangue(String codeLangue) async {
    return _sites;
  }
}
