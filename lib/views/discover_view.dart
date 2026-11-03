import 'package:flutter/material.dart';

import '../controllers/site_controller.dart';
import '../models/site_touristique.dart';
<<<<<<< HEAD
=======
import 'gabon_map_view.dart';
>>>>>>> feature/frontend-vue

const _gabonGreen = Color(0xFF009E49);
const _gabonYellow = Color(0xFFFCD116);
const _gabonBlue = Color(0xFF003DA5);
const _forest = _gabonGreen;
const _ink = Color(0xFF10251B);
const _muted = Color(0xFF6A796F);

class DiscoverView extends StatefulWidget {
  const DiscoverView({super.key, required this.controller});

  final SiteController controller;

  @override
  State<DiscoverView> createState() => _DiscoverViewState();
}

class _DiscoverViewState extends State<DiscoverView> {
  static const _categories = ['Tout', 'Nature', 'Plage', 'Culture'];

  final _searchController = TextEditingController();
  final _favorites = <String>{};
  List<SiteTouristique> _sites = [];
  String _selectedCategory = 'Tout';
  bool _isLoading = true;
  bool _hasError = false;
<<<<<<< HEAD
  bool _showFavorites = false;
=======
  int _currentIndex = 0; // 0: Explorer, 1: Carte du Gabon, 2: Favoris
>>>>>>> feature/frontend-vue

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
<<<<<<< HEAD
    final sites = _showFavorites
=======
    final sites = _currentIndex == 2
>>>>>>> feature/frontend-vue
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
<<<<<<< HEAD
        child: _isLoading
=======
        child: _currentIndex == 1
            ? GabonMapView(controller: widget.controller)
            : _isLoading
>>>>>>> feature/frontend-vue
            ? const Center(child: CircularProgressIndicator())
            : _hasError
            ? _buildErreur()
            : _buildCatalogue(),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
<<<<<<< HEAD
        selectedIndex: _showFavorites ? 1 : 0,
        onDestinationSelected: (index) {
          setState(() => _showFavorites = index == 1);
=======
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
>>>>>>> feature/frontend-vue
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explorer',
          ),
          NavigationDestination(
<<<<<<< HEAD
=======
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Carte du Gabon',
          ),
          NavigationDestination(
>>>>>>> feature/frontend-vue
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoris',
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
    final columns = width >= 1200 ? 4 : (width >= 900 ? 3 : (width >= 600 ? 2 : 1));
    final horizontalPadding = width >= 1200 ? 48.0 : (width >= 600 ? 32.0 : 20.0);
    final featuredSite = sites.isEmpty ? null : sites.first;

    return RefreshIndicator(
      onRefresh: _chargerSites,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: CustomScrollView(
            key: const ValueKey('discover-scroll'),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(horizontalPadding, 12, horizontalPadding, 0),
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      gradient: const LinearGradient(
                        colors: [_gabonGreen, _gabonYellow, _gabonBlue],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [_forest, Color(0xFF2C8A62)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: _forest.withValues(alpha: 0.22),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.forest_rounded,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      const SizedBox(width: 11),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TOURGABON',
                              style: TextStyle(
                                color: _forest,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.7,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'GABON, TERRE DE NATURE',
                              style: TextStyle(
                                color: _muted,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: IconButton(
                          tooltip: 'Actualiser',
                          onPressed: _chargerSites,
                          icon: const Icon(
                            Icons.refresh_rounded,
                            color: _forest,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _WelcomeBanner(
                    site: featuredSite,
<<<<<<< HEAD
                    isFavorites: _showFavorites,
                    onExplore: () => setState(() {
                      _showFavorites = false;
=======
                    isFavorites: _currentIndex == 2,
                    onExplore: () => setState(() {
                      _currentIndex = 0;
>>>>>>> feature/frontend-vue
                      _selectedCategory = 'Tout';
                    }),
                  ),
                  const SizedBox(height: 22),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(17),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF173B2C)
                              .withValues(alpha: 0.06),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
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
                          vertical: 17,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(17),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'CHOISIR UNE AMBIANCE',
                    style: TextStyle(
                      color: _muted,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 42,
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
                          _ => Icons.explore_rounded,
                        };

                        return InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () {
                            setState(() => _selectedCategory = category);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: selected ? _forest : Colors.white,
                              borderRadius: BorderRadius.circular(24),
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
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
<<<<<<< HEAD
                              _showFavorites
=======
                              _currentIndex == 2
>>>>>>> feature/frontend-vue
                                  ? 'Vos coups de cœur'
                                  : 'À ne pas manquer',
                              style: const TextStyle(
                                color: _ink,
                                fontSize: 21,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.4,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
<<<<<<< HEAD
                              _showFavorites
=======
                              _currentIndex == 2
>>>>>>> feature/frontend-vue
                                  ? 'Vos belles découvertes enregistrées'
                                  : 'Des expériences inoubliables vous attendent',
                              style: const TextStyle(
                                color: _muted,
                                fontSize: 11,
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
                  const SizedBox(height: 14),
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
<<<<<<< HEAD
                    _showFavorites && _favorites.isEmpty
=======
                    _currentIndex == 2 && _favorites.isEmpty
>>>>>>> feature/frontend-vue
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
              padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 20),
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
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: width >= 1200 ? 0.88 : (width >= 800 ? 0.84 : 0.67),
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
    final imageUrl = site == null ? _forestImage : _imageFor(site!);

    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: SizedBox(
        height: 224,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _GradientArtwork(
                colors: const [Color(0xFF174B38), Color(0xFF76A663)],
                icon: Icons.forest_rounded,
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xE610261C),
                    Color(0xAA10261C),
                    Color(0x1510261C),
                  ],
                  stops: [0, 0.62, 1],
                ),
              ),
            ),
            Positioned(
              right: -25,
              bottom: -50,
              child: Icon(
                Icons.eco_rounded,
                size: 190,
                color: Colors.white.withValues(alpha: 0.1),
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
                          color: Color(0xFFFFD27A),
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
                      fontSize: 27,
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
                          backgroundColor: const Color(0xFFFFD27A),
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
                        color: Colors.white,
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
        borderRadius: BorderRadius.circular(23),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF18352A).withValues(alpha: 0.075),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
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
                        color: Colors.white.withValues(alpha: 0.94),
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
                          borderRadius: BorderRadius.circular(20),
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
                  padding: const EdgeInsets.fromLTRB(12, 10, 10, 9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        site.nom,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _ink,
                          fontSize: 13,
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
                                fontSize: 10,
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
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 950),
                child: Padding(
                  padding: EdgeInsets.all(MediaQuery.sizeOf(context).width >= 900 ? 36 : 22),
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
  const _SiteAppearance(this.icon, this.colors);

  final IconData icon;
  final List<Color> colors;
}

const _forestImage =
    'https://images.unsplash.com/photo-1516026672322-bc52d61a55d5?auto=format&fit=crop&w=1200&q=85';

String _imageFor(SiteTouristique site) {
  if (site.urlPhotos.trim().isNotEmpty) {
    return site.urlPhotos.trim();
  }

  return switch (site.categorie.toLowerCase()) {
    'plage' => 'https://images.unsplash.com/photo-1500375592092-40eb2168fd21?auto=format&fit=crop&w=900&q=85',
    'culture' => 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&w=900&q=85',
    _ => 'https://images.unsplash.com/photo-1448375240586-882707db888b?auto=format&fit=crop&w=900&q=85',
  };
}

_SiteAppearance _appearanceFor(String category) {
  return switch (category.toLowerCase()) {
    'plage' => const _SiteAppearance(Icons.beach_access_outlined, [
      Color(0xFF003DA5),
      Color(0xFF00A9E0),
    ]),
    'culture' => const _SiteAppearance(Icons.museum_outlined, [
      Color(0xFFFCD116),
      Color(0xFFE5A900),
    ]),
    _ => const _SiteAppearance(Icons.park_outlined, [
      Color(0xFF009E49),
      Color(0xFF145C43),
    ]),
  };
}

class _SiteArtwork extends StatelessWidget {
  const _SiteArtwork({required this.site, required this.appearance});

  final SiteTouristique site;
  final _SiteAppearance appearance;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'site-artwork-${site.id}',
      child: Stack(
        fit: StackFit.expand,
        children: [
          _GradientArtwork(colors: appearance.colors, icon: appearance.icon),
          Image.network(
            _imageFor(site),
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const SizedBox.shrink(),
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
          Positioned(
            right: -14,
            top: -25,
            child: Icon(
              appearance.icon,
              size: 150,
              color: Colors.white.withValues(alpha: 0.22),
            ),
          ),
          Center(
            child: Icon(
              appearance.icon,
              size: 54,
              color: Colors.white.withValues(alpha: 0.95),
              shadows: const [Shadow(color: Colors.black26, blurRadius: 16)],
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientArtwork extends StatelessWidget {
  const _GradientArtwork({required this.colors, required this.icon});

  final List<Color> colors;
  final IconData icon;

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
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            right: -20,
            top: -28,
            child: Icon(
              icon,
              size: 180,
              color: Colors.white.withValues(alpha: 0.17),
            ),
          ),
          Center(
            child: Icon(
              icon,
              size: 58,
              color: Colors.white.withValues(alpha: 0.88),
            ),
          ),
        ],
      ),
    );
  }
}
