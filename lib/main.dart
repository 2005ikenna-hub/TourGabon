import 'package:flutter/material.dart';

import 'models/repositories/demo_site_catalog.dart';
import 'models/repositories/site_catalog.dart';
import 'models/repositories/site_repository.dart';
import 'views/login_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.siteCatalog});

  /// Par défaut : l'API REST, avec le catalogue local en secours si elle est injoignable.
  final SiteCatalog? siteCatalog;

  @override
  Widget build(BuildContext context) {
    const gabonGreen = Color(0xFF009E49);
    const gabonYellow = Color(0xFFFCD116);
    const gabonBlue = Color(0xFF003DA5);
    const cream = Color(0xFFF7F9F6);

    return MaterialApp(
      title: 'TourGabon - Découvrez le Gabon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: gabonGreen,
          primary: gabonGreen,
          secondary: gabonYellow,
          tertiary: gabonBlue,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: cream,
        fontFamily: 'Roboto',
        navigationBarTheme: NavigationBarThemeData(
          height: 72,
          backgroundColor: Colors.white,
          indicatorColor: gabonYellow.withValues(alpha: 0.3),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            return TextStyle(
              fontSize: 12,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w700
                  : FontWeight.w500,
              color: states.contains(WidgetState.selected) ? gabonGreen : const Color(0xFF555555),
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            return IconThemeData(
              color: states.contains(WidgetState.selected) ? gabonGreen : const Color(0xFF666666),
            );
          }),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: cream,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: LoginView(
        siteCatalog: siteCatalog ??
            SiteCatalogAvecSecours(SiteRepository(), const DemoSiteCatalog()),
      ),
    );
  }
}
