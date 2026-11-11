import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tour_gabon/main.dart';
import 'package:tour_gabon/models/repositories/demo_site_catalog.dart';

Future<void> ouvrirEnInvite(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp(siteCatalog: DemoSiteCatalog()));
  await tester.pumpAndSettle();
  final invite = find.text('Continuer en mode invité');
  await tester.ensureVisible(invite);
  await tester.tap(invite);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('affiche et filtre les lieux touristiques', (
    WidgetTester tester,
  ) async {
    await ouvrirEnInvite(tester);

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

  testWidgets('ouvre la fiche du lieu sélectionné', (
    WidgetTester tester,
  ) async {
    await ouvrirEnInvite(tester);

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

    expect(find.text('Localisation'), findsOneWidget);
    expect(find.text('Latitude'), findsOneWidget);
  });
}
