import '../site_touristique.dart';
import 'site_catalog.dart';

class DemoSiteCatalog implements SiteCatalog {
  const DemoSiteCatalog();

  static const _sites = [
    SiteTouristique(
      id: '1',
      nom: 'Parc national de Loango',
      description:
          '• Particularité : Célèbre mondialement pour ses éléphants, buffles et gorilles qui marchent directement sur les plages sauvages de l’océan Atlantique.\n\n'
          '• Position & Valeur : Situé sur la côte atlantique (Ogooué-Maritime), c’est un joyau mondialement reconnu et inscrit au patrimoine naturel de l’UNESCO.\n\n'
          '• Avantage : Observation unique de la grande faune sauvage terrestre au bord de l’eau.\n\n'
          '• Pourquoi le visiter : Pour vivre une aventure équatoriale hors du commun et observer des animaux sauvages dans un décor de rêve entre forêt et vagues.\n\n'
          '📸 **Galerie commentée & Points d’intérêt du Parc de Loango** :\n'
          '1. *Lodge sur pilotis au bord de la lagune* : Hébergement éco-touristique harmonieux suspendu au-dessus de l’eau.\n'
          '2. *Ponton et quais en bois* : Point de départ idéal pour les safaris nautiques et l’observation de la faune aquatique.\n'
          '3. *Gorille des plaines de l’Ouest* : Rencontre exceptionnelle avec les grands singes dans leur habitat naturel protégé.\n'
          '4. *Éléphants sur la plage* : L’inoubliable spectacle des pachydermes marchant le long des vagues de l’océan Atlantique.\n'
          '5. *Lodge au crépuscule* : Vue magique et apaisante des structures en bois illuminées au coucher du soleil.',
      latitude: -2.2500,
      longitude: 9.6167,
      categorie: 'Nature',
      urlPhotos: 'https://images.unsplash.com/photo-1516026672322-bc52d61a55d5?auto=format&fit=crop&w=1200&q=85',
    ),
    SiteTouristique(
      id: '2',
      nom: 'Pointe-Denis',
      description:
          '• Particularité : Une presqu’île paradisiaque de sable blanc fin bordée de cocotiers et de mangroves, accessible en 30 minutes de bateau depuis Libreville.\n\n'
          '• Position & Valeur : Située dans l’Estuaire, face à la capitale, c’est la station balnéaire emblématique et la plus prisée du Gabon.\n\n'
          '• Avantage : Évasion rapide loin de l’agitation urbaine, calme absolu, baignade et détente.\n\n'
          '• Pourquoi le visiter : Pour se relaxer sur des plages de rêve, observer la ponte des tortues marines et déguster du poisson frais les pieds dans le sable.',
      latitude: 0.3500,
      longitude: 9.3167,
      categorie: 'Plage',
      urlPhotos: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=85',
    ),
    SiteTouristique(
      id: '3',
      nom: 'Parc national de la Lopé',
      description:
          '• Particularité : Une transition écologique unique entre la forêt tropicale dense et les savanes herbeuses, berceau de vestiges préhistoriques.\n\n'
          '• Position & Valeur : Situé au centre du Gabon (classé au patrimoine mondial de l’UNESCO), il témoigne des changements climatiques anciens de la Terre.\n\n'
          '• Avantage : Richesse exceptionnelle en grands primates (mandrills, chimpanzés) et sites archéologiques majeurs.\n\n'
          '• Pourquoi le visiter : Pour plonger dans l’histoire millénaire du pays, randonner dans des paysages grandioses et observer une faune fascinante.',
      latitude: -0.5000,
      longitude: 11.5000,
      categorie: 'Nature',
      urlPhotos: 'https://images.unsplash.com/photo-1448375240586-882707db888b?auto=format&fit=crop&w=1200&q=85',
    ),
    SiteTouristique(
      id: '4',
      nom: 'Lambaréné',
      description:
          '• Particularité : Ville historique bâtie au bord du majestueux fleuve Ogooué et mondialement célèbre pour l’hôpital fondé par le Prix Nobel Albert Schweitzer.\n\n'
          '• Position & Valeur : Chef-lieu du Moyen-Ogooué, au cœur de la splendide région des lacs gabonais.\n\n'
          '• Avantage : Croisement culturel unique, paysages lacustres époustouflants et riche patrimoine humanitaire international.\n\n'
          '• Pourquoi le visiter : Pour naviguer sur le fleuve Ogooué en pirogue, découvrir l’histoire médicale humaniste et admirer la beauté des lacs.',
      latitude: -0.7000,
      longitude: 10.2333,
      categorie: 'Culture',
      urlPhotos: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&w=1200&q=85',
    ),
    SiteTouristique(
      id: '5',
      nom: 'Parc national de Pongara',
      description:
          '• Particularité : Un sanctuaire écologique où la forêt tropicale rencontre des plages sauvages abritant la plus grande concentration de tortues luths au monde.\n\n'
          '• Position & Valeur : Situé au sud de l’estuaire du Gabon, c’est un écosystème marin et terrestre d’une valeur écologique inestimable.\n\n'
          '• Avantage : Proximité immédiate de Libreville tout en offrant une immersion totale dans une nature vierge et préservée.\n\n'
          '• Pourquoi le visiter : Pour assister au spectacle grandiose de la ponte des tortues marines et explorer des labyrinthes de mangroves en kayak.',
      latitude: 0.1000,
      longitude: 9.3500,
      categorie: 'Nature',
      urlPhotos: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?auto=format&fit=crop&w=1200&q=85',
    ),
    SiteTouristique(
      id: '6',
      nom: 'Cap Esterias',
      description:
          '• Particularité : Un littoral rocheux et sablonneux spectaculaire bordé d’une forêt littorale luxuriante et d’eaux cristallines.\n\n'
          '• Position & Valeur : Situé à l’extrémité nord de la péninsule de Libreville, c’est un havre de paix côtier très prisé au Gabon.\n\n'
          '• Avantage : Cadre paisible et authentique, idéal pour la baignade, la pêche sportive et les balades en bord de mer.\n\n'
          '• Pourquoi le visiter : Pour admirer les couchers de soleil les plus somptueux sur l’océan Atlantique et profiter du calme de la nature marine.',
      latitude: 0.6000,
      longitude: 9.3500,
      categorie: 'Plage',
      urlPhotos: 'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1200&q=85',
    ),
  ];

  @override
  Future<List<SiteTouristique>> obtenirSitesParLangue(String codeLangue) async {
    return _sites;
  }
}
