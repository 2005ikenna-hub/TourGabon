import 'package:flutter/material.dart';
import 'package:video_player_media_kit/video_player_media_kit.dart';

import 'controllers/site_controller.dart';
import 'models/repositories/demo_site_catalog.dart';
import 'models/repositories/site_catalog.dart';
import 'views/discover_view.dart';

void main() {
  VideoPlayerMediaKit.ensureInitialized(
    android: true,
    iOS: true,
    windows: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.siteCatalog = const DemoSiteCatalog()});

  final SiteCatalog siteCatalog;

  @override
  Widget build(BuildContext context) {
    const forest = Color(0xFF145C43);
    const ocean = Color(0xFF167F9C);
    const sunlight = Color(0xFFF2B72C);
    const cream = Color(0xFFF8F8F3);
    const ink = Color(0xFF18352A);

    return MaterialApp(
      title: 'TourGabon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: forest,
          onPrimary: Colors.white,
          secondary: ocean,
          onSecondary: Colors.white,
          tertiary: sunlight,
          onTertiary: ink,
          surface: cream,
          onSurface: ink,
          error: Color(0xFFB3261E),
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: cream,
        fontFamily: 'Roboto',
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: ink,
          displayColor: ink,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: forest,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          hintStyle: const TextStyle(color: Color(0xFF8A9890)),
          prefixIconColor: forest,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: ocean, width: 1.4),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          height: 76,
          backgroundColor: cream,
          indicatorColor: const Color(0xFFDCECE1),
          surfaceTintColor: Colors.transparent,
          shadowColor: const Color(0x1A18352A),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            return TextStyle(
              fontSize: 12,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w700
                  : FontWeight.w500,
              color: states.contains(WidgetState.selected)
                  ? forest
                  : const Color(0xFF77847B),
            );
          }),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: cream,
          surfaceTintColor: Colors.transparent,
          foregroundColor: forest,
        ),
      ),
      home: DiscoverView(controller: SiteController(siteCatalog)),
    );
  }
}
