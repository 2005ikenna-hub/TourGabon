import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tour_gabon/main.dart';

Future<void> ouvrirApplication(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('affiche et filtre les lieux touristiques', (
    WidgetTester tester,
  ) async {
    await ouvrirApplication(tester);

    await tester.scrollUntilVisible(
      find.text('Parc national de Loango'),
      300,
      scrollable: find
          .descendant(
            of: find.byKey(const ValueKey('discover-scroll')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(find.text('Explorez le Gabon'), findsOneWidget);
    expect(find.text('Parc national de Loango'), findsOneWidget);
    expect(find.text('Pointe-Denis'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Loango');
    await tester.pumpAndSettle();

    expect(find.text('Parc national de Loango'), findsOneWidget);
    expect(find.text('Pointe-Denis'), findsNothing);
  });

  testWidgets('affiche les principales villes avec l’ambiance Ville', (
    WidgetTester tester,
  ) async {
    await ouvrirApplication(tester);

    await tester.tap(find.text('Ville'));
    await tester.pumpAndSettle();

    expect(find.text('5 lieux'), findsOneWidget);
    final scrollable = find
        .descendant(
          of: find.byKey(const ValueKey('discover-scroll')),
          matching: find.byType(Scrollable),
        )
        .first;
    for (final city in [
      'Libreville',
      'Port-Gentil',
      'Franceville',
      'Lambaréné',
      'Oyem',
    ]) {
      await tester.scrollUntilVisible(
        find.text(city),
        300,
        scrollable: scrollable,
      );
      expect(find.text(city), findsOneWidget);
    }
  });

  testWidgets('charge et fait défiler les photos de Libreville', (
    WidgetTester tester,
  ) async {
    await ouvrirApplication(tester);

    await tester.tap(find.text('Ville'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('site-card-7')),
      300,
      scrollable: find
          .descendant(
            of: find.byKey(const ValueKey('discover-scroll')),
            matching: find.byType(Scrollable),
          )
          .first,
    );

    expect(find.byKey(const ValueKey('site-photo-carousel-7')), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                'images/libreville/baie1.jpg',
      ),
      findsOneWidget,
    );

    await tester.pump(const Duration(seconds: 4));
    await tester.pump(const Duration(milliseconds: 700));
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                'images/libreville/baie2.jpg',
      ),
      findsOneWidget,
    );
  });

  testWidgets('affiche et fait défiler la galerie de culture gabonaise', (
    WidgetTester tester,
  ) async {
    await ouvrirApplication(tester);

    await tester.tap(find.text('Culture'));
    await tester.pumpAndSettle();

    final cultureCard = find.byKey(const ValueKey('site-card-11'));
    await tester.scrollUntilVisible(
      cultureCard,
      300,
      scrollable: find
          .descendant(
            of: find.byKey(const ValueKey('discover-scroll')),
            matching: find.byType(Scrollable),
          )
          .first,
    );

    expect(
      find.byKey(const ValueKey('site-photo-carousel-11')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('site-photo-carousel-11')),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName ==
                  'images/culture/culture1.jpg',
        ),
      ),
      findsOneWidget,
    );

    await tester.pump(const Duration(seconds: 4));
    await tester.pump(const Duration(milliseconds: 700));
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('site-photo-carousel-11')),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName ==
                  'images/culture/culture2.jpg',
        ),
      ),
      findsOneWidget,
    );
  });

  testWidgets('affiche et fait défiler la galerie des hôtels', (
    WidgetTester tester,
  ) async {
    await ouvrirApplication(tester);

    await tester.tap(find.text('Hôtel'));
    await tester.pumpAndSettle();

    final hotelCard = find.byKey(const ValueKey('site-card-12'));
    await tester.scrollUntilVisible(
      hotelCard,
      300,
      scrollable: find
          .descendant(
            of: find.byKey(const ValueKey('discover-scroll')),
            matching: find.byType(Scrollable),
          )
          .first,
    );

    final carousel = find.byKey(const ValueKey('site-photo-carousel-12'));
    expect(carousel, findsOneWidget);
    expect(
      find.descendant(
        of: carousel,
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName ==
                  'images/hotels/hotel1.jpg',
        ),
      ),
      findsOneWidget,
    );

    await tester.pump(const Duration(seconds: 4));
    await tester.pump(const Duration(milliseconds: 700));
    expect(
      find.descendant(
        of: carousel,
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName ==
                  'images/hotels/hotel2.jpg',
        ),
      ),
      findsOneWidget,
    );
  });

  testWidgets('fait défiler les photos du parc de la Lopé', (
    WidgetTester tester,
  ) async {
    await ouvrirApplication(tester);

    final lopeCard = find.byKey(const ValueKey('site-card-3'));
    await tester.scrollUntilVisible(
      lopeCard,
      300,
      scrollable: find
          .descendant(
            of: find.byKey(const ValueKey('discover-scroll')),
            matching: find.byType(Scrollable),
          )
          .first,
    );

    expect(find.byKey(const ValueKey('lopez-hover-video')), findsOneWidget);
    expect(find.byKey(const ValueKey('lope-photo-carousel')), findsOneWidget);
    expect(find.text('Survole ou appuie pour lancer la vidéo'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName == 'images/lopé1.jpg',
      ),
      findsOneWidget,
    );

    await tester.pump(const Duration(seconds: 4));
    await tester.pump(const Duration(milliseconds: 700));
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName == 'images/lopé2.jpg',
      ),
      findsOneWidget,
    );
  });

  testWidgets('fait défiler les photos du Cap Estérias', (
    WidgetTester tester,
  ) async {
    await ouvrirApplication(tester);

    final capCard = find.byKey(const ValueKey('site-card-6'));
    await tester.scrollUntilVisible(
      capCard,
      300,
      scrollable: find
          .descendant(
            of: find.byKey(const ValueKey('discover-scroll')),
            matching: find.byType(Scrollable),
          )
          .first,
    );

    expect(find.byKey(const ValueKey('site-photo-carousel-6')), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName == 'images/cap1.jpg',
      ),
      findsOneWidget,
    );

    await tester.pump(const Duration(seconds: 4));
    await tester.pump(const Duration(milliseconds: 700));
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName == 'images/cap2.png',
      ),
      findsOneWidget,
    );
  });

  testWidgets('ouvre la fiche du lieu sélectionné', (
    WidgetTester tester,
  ) async {
    await ouvrirApplication(tester);

    final siteCard = find.byKey(const ValueKey('site-card-1'));
    await tester.scrollUntilVisible(
      siteCard,
      300,
      scrollable: find
          .descendant(
            of: find.byKey(const ValueKey('discover-scroll')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.tap(siteCard);
    await tester.pumpAndSettle();

    expect(find.text('Photos du parc'), findsOneWidget);
    expect(
      find.text('Un gorille dans la végétation de la forêt tropicale.'),
      findsOneWidget,
    );
    expect(find.text('Localisation'), findsOneWidget);
    expect(find.text('Latitude'), findsOneWidget);
  });

  testWidgets('ouvre la carte interactive du Gabon', (
    WidgetTester tester,
  ) async {
    await ouvrirApplication(tester);

    await tester.tap(find.text('Carte'));
    await tester.pumpAndSettle();

    expect(find.text('Carte du Gabon'), findsOneWidget);
    expect(find.text('Me localiser'), findsOneWidget);
    expect(find.text('Itinéraire vers Loango'), findsOneWidget);
    expect(find.text('© OpenStreetMap contributors'), findsOneWidget);
  });
}
