import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../controllers/site_controller.dart';
import '../models/site_touristique.dart';
import 'gabon_map_view.dart';

const _forest = Color(0xFF145C43);
const _ocean = Color(0xFF167F9C);
const _sunlight = Color(0xFFF2B72C);
const _ink = Color(0xFF18352A);
const _muted = Color(0xFF77847B);
const _canvas = Color(0xFFF7F8F3);

class DiscoverView extends StatefulWidget {
  const DiscoverView({super.key, required this.controller});

  final SiteController controller;

  @override
  State<DiscoverView> createState() => _DiscoverViewState();
}

class _DiscoverViewState extends State<DiscoverView> {
  static const _categories = [
    'Tout',
    'Nature',
    'Plage',
    'Culture',
    'Ville',
    'Hôtel',
  ];

  final _searchController = TextEditingController();
  final _favorites = <String>{};
  List<SiteTouristique> _sites = [];
  String _selectedCategory = 'Tout';
  bool _isLoading = true;
  bool _hasError = false;
  bool _showFavorites = false;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _chargerSites();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _chargerSites() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final sites = await widget.controller.obtenirSites();
      if (!mounted) return;
      setState(() {
        _sites = sites;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Impossible de charger les lieux : $error')),
      );
    }
  }

  List<SiteTouristique> get _sitesAffiches {
    final sites = _showFavorites
        ? _sites.where((site) => _favorites.contains(site.id)).toList()
        : _sites;
    return widget.controller.filtrerSites(
      sites,
      recherche: _searchController.text,
      categorie: _selectedCategory,
    );
  }

  void _basculerFavori(SiteTouristique site) {
    setState(() {
      if (!_favorites.add(site.id)) {
        _favorites.remove(site.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _selectedTabIndex == 2
            ? const GabonMapView()
            : _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _hasError
            ? _buildErreur()
            : _buildCatalogue(),
      ),
      bottomNavigationBar: NavigationBar(
        elevation: 8,
        backgroundColor: _canvas,
        selectedIndex: _selectedTabIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedTabIndex = index;
            _showFavorites = index == 1;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explorer',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoris',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map_rounded),
            label: 'Carte',
          ),
        ],
      ),
    );
  }

  Widget _buildErreur() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 44, color: _muted),
            const SizedBox(height: 12),
            const Text(
              'Les lieux ne sont pas disponibles pour le moment.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _chargerSites,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCatalogue() {
    final sites = _sitesAffiches;
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 800 ? 3 : 2;
    final featuredSite = sites.isEmpty ? null : sites.first;

    return RefreshIndicator(
      onRefresh: _chargerSites,
      child: CustomScrollView(
        key: const ValueKey('discover-scroll'),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE7EDE7)),
                          boxShadow: [
                            BoxShadow(
                              color: _forest.withValues(alpha: 0.08),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(17),
                          child: Image.asset(
                            'images/logo.jpg',
                            fit: BoxFit.cover,
                            semanticLabel: 'Logo TourGabon',
                          ),
                        ),
                      ),
                      const SizedBox(width: 13),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TOURGABON',
                              style: TextStyle(
                                color: _forest,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.7,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'L’ÉDEN VERT DE L’AFRIQUE',
                              style: TextStyle(
                                color: _muted,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        child: IconButton(
                          tooltip: 'Actualiser',
                          onPressed: _chargerSites,
                          icon: const Icon(
                            Icons.refresh_rounded,
                            color: _ocean,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _WelcomeBanner(
                    site: featuredSite,
                    isFavorites: _showFavorites,
                    onExplore: () => setState(() {
                      _showFavorites = false;
                      _selectedCategory = 'Tout';
                    }),
                  ),
                  const SizedBox(height: 22),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE9EEE8)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF173B2C)
                              .withValues(alpha: 0.055),
                          blurRadius: 20,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: 'Où souhaitez-vous aller ?',
                          hintStyle: const TextStyle(
                            color: Color(0xFF9AA59E),
                            fontSize: 14,
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: _forest,
                          ),
                          suffixIcon: _searchController.text.isEmpty
                              ? null
                              : IconButton(
                                  tooltip: 'Effacer la recherche',
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 18,
                          ),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'CHOISIR UNE AMBIANCE',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 11),
                  SizedBox(
                    height: 44,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final selected = _selectedCategory == category;
                        final icon = switch (category) {
                          'Nature' => Icons.forest_rounded,
                          'Plage' => Icons.waves_rounded,
                          'Culture' => Icons.museum_rounded,
                          'Ville' => Icons.location_city_rounded,
                          'Hôtel' => Icons.hotel_rounded,
                          _ => Icons.explore_rounded,
                        };

                        return InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () {
                            setState(() => _selectedCategory = category);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: selected ? _forest : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: selected
                                    ? _forest
                                    : const Color(0xFFE7EAE5),
                              ),
                              boxShadow: selected
                                  ? [
                                      BoxShadow(
                                        color: _forest.withValues(alpha: 0.16),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  icon,
                                  size: 16,
                                  color: selected ? Colors.white : _forest,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  category,
                                  style: TextStyle(
                                    color: selected ? Colors.white : _ink,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 27),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _showFavorites
                                  ? 'Vos coups de cœur'
                                  : 'À ne pas manquer',
                              style: const TextStyle(
                                color: _ink,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _showFavorites
                                  ? 'Vos belles découvertes enregistrées'
                                  : 'Des expériences inoubliables vous attendent',
                              style: const TextStyle(
                                color: _muted,
                                fontSize: 12,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F1EA),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${sites.length} lieu${sites.length == 1 ? '' : 'x'}',
                          style: const TextStyle(
                            color: _forest,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          if (sites.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    _showFavorites && _favorites.isEmpty
                        ? 'Ajoutez un lieu à vos favoris pour le retrouver ici.'
                        : 'Aucun lieu ne correspond à votre recherche.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: _muted),
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final site = sites[index];
                  return _SiteCard(
                    site: site,
                    isFavorite: _favorites.contains(site.id),
                    onFavoritePressed: () => _basculerFavori(site),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => SiteDetailView(
                          site: site,
                          isFavorite: _favorites.contains(site.id),
                          onFavoritePressed: () => _basculerFavori(site),
                        ),
                      ),
                    ),
                  );
                }, childCount: sites.length),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: width >= 800
                      ? 0.88
                      : width >= 600
                      ? 0.74
                      : 0.68,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _WelcomeBanner extends StatelessWidget {
  const _WelcomeBanner({
    required this.site,
    required this.isFavorites,
    required this.onExplore,
  });

  final SiteTouristique? site;
  final bool isFavorites;
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    final title = isFavorites ? 'Vos beaux souvenirs' : 'Explorez le Gabon';
    final photos = site == null ? const <_SitePhoto>[] : _photosFor(site!);

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: SizedBox(
        height: 236,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (photos.isNotEmpty)
              _AutoSlidingPhotos(photos: photos)
            else
              _GradientArtwork(
                colors: const [Color(0xFF174B38), Color(0xFF76A663)],
              ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xE610261C),
                    Color(0xA610261C),
                    Color(0x0010261C),
                  ],
                  stops: [0, 0.62, 1],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(21, 20, 19, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.wb_sunny_rounded,
                          color: _sunlight,
                          size: 13,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'L’AVENTURE COMMENCE ICI',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontSize: 29,
                      fontWeight: FontWeight.w900,
                      height: 1.06,
                      letterSpacing: -0.5,
                      shadows: const [
                        Shadow(color: Colors.black26, blurRadius: 12),
                      ],
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'La nature à l’état pur. Des souvenirs pour toujours.',
                    maxLines: 2,
                    style: TextStyle(
                      color: Color(0xFFE7EEE7),
                      fontSize: 11,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      FilledButton(
                        onPressed: onExplore,
                        style: FilledButton.styleFrom(
                          backgroundColor: _sunlight,
                          foregroundColor: const Color(0xFF233326),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 9,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Découvrir',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(Icons.arrow_forward_rounded, size: 14),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.location_on_rounded,
                        color: _sunlight,
                        size: 14,
                      ),
                      const SizedBox(width: 3),
                      const Text(
                        'Gabon, Afrique centrale',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SiteCard extends StatelessWidget {
  const _SiteCard({
    required this.site,
    required this.isFavorite,
    required this.onFavoritePressed,
    required this.onTap,
  });

  final SiteTouristique site;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final appearance = _appearanceFor(site.categorie);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF18352A).withValues(alpha: 0.07),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: ValueKey('site-card-${site.id}'),
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _SiteArtwork(site: site, appearance: appearance),
                    Positioned(
                      top: 9,
                      right: 9,
                      child: Material(
                        color: Colors.white.withValues(alpha: 0.96),
                        shape: const CircleBorder(),
                        child: IconButton(
                          tooltip: isFavorite
                              ? 'Retirer des favoris'
                              : 'Ajouter aux favoris',
                          visualDensity: VisualDensity.compact,
                          onPressed: onFavoritePressed,
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: isFavorite ? Colors.redAccent : _ink,
                            size: 19,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      bottom: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          site.categorie.toUpperCase(),
                          style: const TextStyle(
                            color: _forest,
                            fontSize: 9,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 12, 11),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        site.nom,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _ink,
                          fontSize: 14,
                          height: 1.2,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(
                            Icons.place_rounded,
                            size: 13,
                            color: _forest,
                          ),
                          const SizedBox(width: 3),
                          const Expanded(
                            child: Text(
                              'Gabon',
                              style: TextStyle(
                                color: _muted,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_outward_rounded,
                            size: 14,
                            color: _forest.withValues(alpha: 0.8),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SiteDetailView extends StatefulWidget {
  const SiteDetailView({
    super.key,
    required this.site,
    required this.isFavorite,
    required this.onFavoritePressed,
  });

  final SiteTouristique site;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;

  @override
  State<SiteDetailView> createState() => _SiteDetailViewState();
}

class _SiteDetailViewState extends State<SiteDetailView> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  void _basculerFavori() {
    setState(() => _isFavorite = !_isFavorite);
    widget.onFavoritePressed();
  }

  @override
  Widget build(BuildContext context) {
    final site = widget.site;
    final appearance = _appearanceFor(site.categorie);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            leading: IconButton(
              tooltip: 'Retour',
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.92),
              ),
            ),
            actions: [
              IconButton(
                tooltip: _isFavorite
                    ? 'Retirer des favoris'
                    : 'Ajouter aux favoris',
                onPressed: _basculerFavori,
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.redAccent : _ink,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.92),
                ),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _SiteArtwork(site: site, appearance: appearance),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5F1E9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      site.categorie,
                      style: const TextStyle(
                        color: _forest,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    site.nom,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(color: _ink, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    site.description,
                    style: const TextStyle(
                      color: Color(0xFF53645A),
                      fontSize: 16,
                      height: 1.55,
                    ),
                  ),
                  if (_photosFor(site).isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _SitePhotoGallery(photos: _photosFor(site)),
                  ],
                  const SizedBox(height: 24),
                  const Text(
                    'Localisation',
                    style: TextStyle(
                      color: _ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _CoordinateRow(
                    icon: Icons.my_location_outlined,
                    label: 'Latitude',
                    value: site.latitude.toStringAsFixed(4),
                  ),
                  const SizedBox(height: 8),
                  _CoordinateRow(
                    icon: Icons.explore_outlined,
                    label: 'Longitude',
                    value: site.longitude.toStringAsFixed(4),
                  ),
                  const SizedBox(height: 26),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _basculerFavori,
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                      ),
                      label: Text(
                        _isFavorite
                            ? 'Retirer des favoris'
                            : 'Enregistrer en favori',
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _forest,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoordinateRow extends StatelessWidget {
  const _CoordinateRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: _forest),
        const SizedBox(width: 9),
        Text(label, style: const TextStyle(color: _muted)),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(color: _ink, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _SiteAppearance {
  const _SiteAppearance(this.colors);

  final List<Color> colors;
}

const _loangoPhotos = [
  _SitePhoto(
    'images/loango1.jpg',
    'Un gorille dans la végétation de la forêt tropicale.',
  ),
  _SitePhoto(
    'images/loango2.jpeg',
    'Des éléphants traversent une clairière au milieu de la savane.',
  ),
  _SitePhoto(
    'images/loango3.jpg',
    'Un éléphant marche entre la végétation et le littoral.',
  ),
  _SitePhoto(
    'images/loango4.jpg',
    'Un lodge éclairé au bord de l’eau à la tombée du jour.',
  ),
  _SitePhoto(
    'images/loango5.jpg',
    'Vue aérienne d’un lodge installé au bord de la lagune.',
  ),
  _SitePhoto('images/loango6.jpg', 'Portrait d’un gorille dans la forêt.'),
  _SitePhoto(
    'images/loango7.jpg',
    'Une passerelle en bois mène à un lodge au bord de l’eau.',
  ),
  _SitePhoto(
    'images/loango8.jpg',
    'Un lodge entouré de forêt tropicale et de palmiers.',
  ),
];

const _lopePhotos = [
  _SitePhoto(
    'images/lopé1.jpg',
    'Les collines verdoyantes et les cours d’eau du parc de la Lopé.',
  ),
  _SitePhoto(
    'images/lopé2.jpg',
    'La savane et les méandres de l’Ogooué traversent le paysage.',
  ),
  _SitePhoto(
    'images/lopé3.jpg',
    'Une famille d’éléphants se déplace dans la savane.',
  ),
  _SitePhoto(
    'images/lopé4.jpg',
    'Portrait d’un mandrill, primate emblématique des forêts gabonaises.',
  ),
  _SitePhoto(
    'images/lopé5.jpg',
    'Les rochers et les eaux du fleuve au cœur du parc.',
  ),
  _SitePhoto(
    'images/lopé6.jpg',
    'La montagne et les rives du fleuve composent un paysage remarquable.',
  ),
  _SitePhoto(
    'images/lopé7.jpg',
    'Des buffles roux profitent d’une clairière près de la forêt.',
  ),
  _SitePhoto(
    'images/lopé8.png',
    'Des buffles roux dans la savane du parc national de la Lopé.',
  ),
  _SitePhoto(
    'images/lopé9.jpg',
    'Une vue panoramique des savanes et des forêts de la Lopé.',
  ),
];

const _capEsteriasPhotos = [
  _SitePhoto(
    'images/cap1.jpg',
    'Un abri de plage entouré de cocotiers au Cap Estérias.',
  ),
  _SitePhoto(
    'images/cap2.png',
    'Vue aérienne de la côte, des plages et de la végétation du Cap Estérias.',
  ),
  _SitePhoto(
    'images/cap3.jpg',
    'La forêt côtière rejoint les plages et les eaux de l’Atlantique.',
  ),
  _SitePhoto(
    'images/cap4.jpg',
    'Le panneau du Cap Estérias marque l’entrée de cette destination littorale.',
  ),
  _SitePhoto(
    'images/cap5.jpg',
    'Des visiteurs découvrent un sentier dans la végétation de la région.',
  ),
  _SitePhoto(
    'images/cap6.jpg',
    'Vue aérienne des aménagements et de la végétation environnante.',
  ),
  _SitePhoto(
    'images/cap7.jpg',
    'Des bâtiments et des voies au cœur d’un environnement verdoyant.',
  ),
  _SitePhoto(
    'images/cap8.jpg',
    'Un bâtiment récent dans la région du Cap Estérias.',
  ),
  _SitePhoto(
    'images/cap-.webp',
    'Une plage bordée de palmiers face à l’océan Atlantique.',
  ),
];

const _librevillePhotos = [
  _SitePhoto(
    'images/libreville/baie1.jpg',
    'Vue sur la baie et les aménagements du front de mer de Libreville.',
  ),
  _SitePhoto(
    'images/libreville/baie2.jpg',
    'Un espace de loisirs et de rencontre aménagé au bord de la baie.',
  ),
  _SitePhoto(
    'images/libreville/baie3.jpg',
    'Le front de mer de Libreville illuminé en soirée.',
  ),
  _SitePhoto(
    'images/libreville/baie4.jpg',
    'Un espace de glisse fréquenté par les jeunes de Libreville.',
  ),
  _SitePhoto(
    'images/libreville/emmeraude1.jpg',
    'Émeraude Mall, un lieu de commerce et de rencontre dans la capitale.',
  ),
  _SitePhoto(
    'images/libreville/emmeraude2.jpg',
    'Des immeubles contemporains dans le paysage urbain de Libreville.',
  ),
  _SitePhoto(
    'images/libreville/emmeraude3.jpg',
    'Émeraude Mall photographié de nuit dans la capitale.',
  ),
  _SitePhoto(
    'images/libreville/lbreville1.jpg',
    'La façade du bâtiment La Concorde à Libreville.',
  ),
  _SitePhoto(
    'images/libreville/libreville1.jpg',
    'Un bâtiment administratif remarquable du centre de Libreville.',
  ),
  _SitePhoto(
    'images/libreville/libreville2.jpg',
    'Vue d’ensemble d’un bâtiment moderne de la capitale gabonaise.',
  ),
];

const _culturePhotos = [
  _SitePhoto(
    'images/culture/culture1.jpg',
    'Une célébration met à l’honneur les danses et les tenues traditionnelles.',
  ),
  _SitePhoto(
    'images/culture/culture2.jpg',
    'Des danseuses portent des parures et des motifs de peinture corporelle.',
  ),
  _SitePhoto(
    'images/culture/culture3.jpg',
    'Une cérémonie rassemble des participants vêtus de leurs parures.',
  ),
  _SitePhoto(
    'images/culture/culture4.jpg',
    'Des motifs et ornements traditionnels accompagnent une rencontre culturelle.',
  ),
  _SitePhoto(
    'images/culture/culture5.jpg',
    'Illustration de masques associés aux différentes régions du Gabon.',
  ),
  _SitePhoto(
    'images/culture/culture6.jpg',
    'Une représentation de danse et de musique traditionnelles.',
  ),
  _SitePhoto(
    'images/culture/culture7.jpg',
    'Une danse masquée met en valeur les arts et les traditions locales.',
  ),
  _SitePhoto(
    'images/culture/culture8.jpg',
    'Une affiche annonce une célébration culturelle à Libreville.',
  ),
  _SitePhoto(
    'images/culture/culture9.jpg',
    'Une participante porte une tenue de cérémonie richement ornée.',
  ),
  _SitePhoto(
    'images/culture/culture10.jpg',
    'Un masque rituel porté lors d’une manifestation culturelle.',
  ),
];

const _hotelPhotos = [
  _SitePhoto(
    'images/hotels/hotel1.jpg',
    'Façade du Radisson Blu, reconnaissable à son enseigne.',
  ),
  _SitePhoto(
    'images/hotels/hotel2.jpg',
    'Entrée du Radisson Blu photographiée en soirée.',
  ),
  _SitePhoto(
    'images/hotels/hotel3.jpg',
    'Hall d’accueil et espace de réception d’un hôtel.',
  ),
  _SitePhoto(
    'images/hotels/hotel4.jpg',
    'Espace extérieur de l’Hôtel Le Cristal.',
  ),
  _SitePhoto(
    'images/hotels/hotel5.jpg',
    'Terrasse et service de restauration de l’Hôtel Le Cristal.',
  ),
  _SitePhoto(
    'images/hotels/hotel6.jpg',
    'Vue extérieure d’un établissement hôtelier.',
  ),
  _SitePhoto(
    'images/hotels/hotel7.jpg',
    'Piscine et espaces de détente d’un hôtel.',
  ),
  _SitePhoto(
    'images/hotels/hotel8.jpg',
    'Piscine éclairée en soirée dans un cadre hôtelier.',
  ),
  _SitePhoto(
    'images/hotels/hotel9.jpg',
    'Hôtel avec piscine et espaces de séjour extérieurs.',
  ),
];

List<_SitePhoto> _photosFor(SiteTouristique site) {
  final name = site.nom.toLowerCase();
  if (name.contains('libreville')) return _librevillePhotos;
  if (name.contains('culture gabonaise')) return _culturePhotos;
  if (name.contains('hébergements au gabon')) return _hotelPhotos;
  if (name.contains('loango')) return _loangoPhotos;
  if (name.contains('lopé') || name.contains('lope')) return _lopePhotos;
  if (name.contains('cap esterias') || name.contains('cap estérias')) {
    return _capEsteriasPhotos;
  }
  return const [];
}

class _SitePhoto {
  const _SitePhoto(this.assetPath, this.caption);

  final String assetPath;
  final String caption;
}

class _AutoSlidingPhotos extends StatefulWidget {
  const _AutoSlidingPhotos({super.key, required this.photos});

  final List<_SitePhoto> photos;

  @override
  State<_AutoSlidingPhotos> createState() => _AutoSlidingPhotosState();
}

class _AutoSlidingPhotosState extends State<_AutoSlidingPhotos> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    if (widget.photos.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 4), (_) {
        if (!_pageController.hasClients) return;
        final nextPage = (_currentPage + 1) % widget.photos.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.photos.length,
      onPageChanged: (page) => _currentPage = page,
      itemBuilder: (context, index) => Image.asset(
        widget.photos[index].assetPath,
        fit: BoxFit.cover,
        semanticLabel: widget.photos[index].caption,
      ),
    );
  }
}

class _SitePhotoGallery extends StatelessWidget {
  const _SitePhotoGallery({required this.photos});

  final List<_SitePhoto> photos;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Photos du parc',
          style: TextStyle(
            color: _ink,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: photos.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final photo = photos[index];
              return SizedBox(
                width: 280,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: _ink.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Image.asset(
                            photo.assetPath,
                            fit: BoxFit.cover,
                            semanticLabel: photo.caption,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            photo.caption,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _ink,
                              fontSize: 12,
                              height: 1.35,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

_SiteAppearance _appearanceFor(String category) {
  return switch (category.toLowerCase()) {
    'plage' => const _SiteAppearance([Color(0xFF38A5A0), Color(0xFFB5D99A)]),
    'culture' => const _SiteAppearance([Color(0xFFB26A40), Color(0xFFE2B56F)]),
    'ville' => const _SiteAppearance([Color(0xFF167F9C), Color(0xFF75B9A6)]),
    _ => const _SiteAppearance([Color(0xFF176B4D), Color(0xFF9DBD73)]),
  };
}

class _SiteArtwork extends StatelessWidget {
  const _SiteArtwork({required this.site, required this.appearance});

  final SiteTouristique site;
  final _SiteAppearance appearance;

  @override
  Widget build(BuildContext context) {
    if (site.nom.toLowerCase().contains('lopé')) {
      return Hero(
        tag: 'site-artwork-${site.id}',
        child: _HoverVideo(photos: _photosFor(site)),
      );
    }

    return Hero(
      tag: 'site-artwork-${site.id}',
      child: Stack(
        fit: StackFit.expand,
        children: [
          _GradientArtwork(colors: appearance.colors),
          if (_photosFor(site).isNotEmpty)
            _AutoSlidingPhotos(
              key: ValueKey('site-photo-carousel-${site.id}'),
              photos: _photosFor(site),
            ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x00102418),
                  Color(0x25102418),
                  Color(0x57102418),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HoverVideo extends StatefulWidget {
  const _HoverVideo({required this.photos});

  final List<_SitePhoto> photos;

  @override
  State<_HoverVideo> createState() => _HoverVideoState();
}

class _HoverVideoState extends State<_HoverVideo> {
  VideoPlayerController? _controller;
  Future<void>? _initialization;
  Future<void>? _startRequest;
  bool _isHovered = false;
  bool _isMuted = kIsWeb;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _demarrer() async {
    _isHovered = true;
    if (mounted) setState(() {});

    final controller = _controller ??= VideoPlayerController.asset(
      'videos/lope.mp4',
    );
    if (controller.value.isInitialized && controller.value.isPlaying) return;

    final pendingStart = _startRequest;
    if (pendingStart != null) {
      await pendingStart;
      return;
    }

    final startRequest = _preparerEtLire(controller);
    _startRequest = startRequest;
    try {
      await startRequest;
    } finally {
      if (identical(_startRequest, startRequest)) _startRequest = null;
    }
  }

  Future<void> _preparerEtLire(VideoPlayerController controller) async {
    try {
      if (!controller.value.isInitialized) {
        if (mounted) setState(() => _isLoading = true);
        _initialization ??= controller.initialize();
        await _initialization;
      }

      await controller.setLooping(true);
      await controller.setVolume(_isMuted ? 0 : 1);
      if (_isHovered) await controller.play();
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = null;
      });
    } on Exception catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Vidéo indisponible : $error';
      });
    }
  }

  Future<void> _basculerSon() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    final mute = !_isMuted;
    try {
      final volumeUpdate = controller.setVolume(mute ? 0 : 1);
      final playback = !mute && !controller.value.isPlaying
          ? controller.play()
          : Future<void>.value();
      await Future.wait([volumeUpdate, playback]);
      if (!mounted) return;
      setState(() => _isMuted = mute);
    } on Exception catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Impossible de régler le son : $error');
    }
  }

  Future<void> _arreter() async {
    _isHovered = false;
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    try {
      await controller.pause();
      await controller.seekTo(Duration.zero);
      if (mounted) setState(() {});
    } on Exception catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Impossible d’arrêter la vidéo : $error');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    return MouseRegion(
      key: const ValueKey('lopez-hover-video'),
      onEnter: (_) => _demarrer(),
      onHover: (_) {
        if (!_isHovered) _demarrer();
      },
      onExit: (_) => _arreter(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _AutoSlidingPhotos(
            key: const ValueKey('lope-photo-carousel'),
            photos: widget.photos,
          ),
          if (controller != null &&
              controller.value.isInitialized &&
              controller.value.isPlaying)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: controller.value.size.width,
                height: controller.value.size.height,
                child: VideoPlayer(controller),
              ),
            )
          else
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.94),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isLoading)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      IconButton(
                        tooltip: 'Lancer la vidéo',
                        visualDensity: VisualDensity.compact,
                        onPressed: _demarrer,
                        icon: const Icon(
                          Icons.play_circle_fill_rounded,
                          color: _forest,
                          size: 20,
                        ),
                      ),
                    Flexible(
                      child: Text(
                        _isLoading
                            ? 'Chargement de la vidéo…'
                            : 'Survole ou appuie pour lancer la vidéo',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _ink,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (controller?.value.isInitialized == true)
            Positioned(
              right: 10,
              bottom: 10,
              child: Material(
                color: Colors.white.withValues(alpha: 0.94),
                shape: const CircleBorder(),
                child: IconButton(
                  key: const ValueKey('lopez-video-sound'),
                  tooltip: _isMuted ? 'Activer le son' : 'Couper le son',
                  onPressed: _basculerSon,
                  icon: Icon(
                    _isMuted
                        ? Icons.volume_off_rounded
                        : Icons.volume_up_rounded,
                    color: _forest,
                  ),
                ),
              ),
            ),
          if (_errorMessage != null)
            Positioned(
              left: 10,
              right: 10,
              top: 10,
              child: Material(
                color: const Color(0xFFFFECE8),
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: Color(0xFF7F3026),
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _GradientArtwork extends StatelessWidget {
  const _GradientArtwork({required this.colors});

  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
    );
  }
}
