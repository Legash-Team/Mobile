import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:egash_mobile/models/donor_model.dart';
import 'package:egash_mobile/providers/auth_provider.dart';
import 'package:egash_mobile/screens/profile_screen.dart';
import 'package:provider/provider.dart';

void main() {
  group('Part 10 — Donor Short ID (Display & Copy)', () {
    test('DonorInfo parses shortId correctly from JSON', () {
      final json = {
        'id': 'donor123',
        'shortId': '#LEG-1042',
        'name': 'Abebe Bikila',
        'phone': '+251911223344',
        'bloodType': 'O+',
        'fin': 'FIN-998877',
        'gender': 'male',
      };

      final donor = DonorInfo.fromJson(json);
      expect(donor.id, 'donor123');
      expect(donor.shortId, '#LEG-1042');
      expect(donor.name, 'Abebe Bikila');
      expect(donor.toJson()['shortId'], '#LEG-1042');
    });

    test('DonorInfo handles absent or null shortId gracefully', () {
      final json = {
        'id': 'donor456',
        'name': 'Almaz Ayana',
        'phone': '+251922334455',
      };

      final donor = DonorInfo.fromJson(json);
      expect(donor.id, 'donor456');
      expect(donor.shortId, isNull);
      expect(donor.toJson().containsKey('shortId'), isFalse);
    });

    testWidgets('ProfileScreen displays Donor ID and allows copying to clipboard',
        (WidgetTester tester) async {
      final authProvider = AuthProvider();
      authProvider.updateDonor(
        DonorInfo(
          id: 'donor123',
          shortId: '#LEG-1042',
          name: 'Abebe Bikila',
          phone: '+251911223344',
          bloodType: 'O+',
          fin: 'FIN-998877',
          gender: 'male',
        ),
      );

      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>.value(
          value: authProvider,
          child: const MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );

      // Scroll until copy icon is visible
      await tester.scrollUntilVisible(
        find.byIcon(Icons.copy_rounded),
        100,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('Donor ID'), findsOneWidget);
      expect(find.text('#LEG-1042'), findsOneWidget);
      expect(find.byIcon(Icons.copy_rounded), findsOneWidget);

      // Tap copy icon
      await tester.tap(find.byIcon(Icons.copy_rounded));
      await tester.pump();

      expect(find.text('Donor ID copied to clipboard'), findsOneWidget);
    });

    testWidgets('ProfileScreen displays "Not assigned" when shortId is missing',
        (WidgetTester tester) async {
      final authProvider = AuthProvider();
      authProvider.updateDonor(
        DonorInfo(
          id: 'donor789',
          name: 'Kenenisa Bekele',
          phone: '+251933445566',
          bloodType: 'A+',
          fin: 'FIN-112233',
        ),
      );

      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>.value(
          value: authProvider,
          child: const MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );

      await tester.scrollUntilVisible(
        find.text('Donor ID'),
        100,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('Donor ID'), findsOneWidget);
      expect(find.text('Not assigned'), findsOneWidget);
      // Copy icon should not be shown when there's no valid shortId
      expect(find.byIcon(Icons.copy_rounded), findsNothing);
    });
  });
}
