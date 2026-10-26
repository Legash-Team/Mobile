import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:egash_mobile/models/donor_model.dart';
import 'package:egash_mobile/providers/auth_provider.dart';
import 'package:egash_mobile/screens/donor_faq_screen.dart';
import 'package:egash_mobile/screens/health_screen.dart';
import 'package:egash_mobile/utils/blood_compatibility.dart';
import 'package:egash_mobile/utils/wellness_content.dart';
import 'package:egash_mobile/widgets/blood_compatibility_card.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Blood Compatibility Utility Tests (Mirrors Backend)', () {
    test('All 8 supported blood types are recognized', () {
      for (final type in ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']) {
        expect(isBloodTypeKnown(type), isTrue);
        expect(normalizeBloodType(type), equals(type));
      }
      expect(isBloodTypeKnown('unknown'), isFalse);
      expect(isBloodTypeKnown(null), isFalse);
      expect(normalizeBloodType('invalid'), isNull);
    });

    test('O- is universal donor (can donate to all 8 types)', () {
      final donate = getCanDonateTo('O-');
      expect(donate, containsAll(['O-', 'O+', 'A-', 'A+', 'B-', 'B+', 'AB-', 'AB+']));
      expect(donate.length, equals(8));
    });

    test('O- can only receive from O-', () {
      final receive = getCanReceiveFrom('O-');
      expect(receive, equals(['O-']));
    });

    test('AB+ is universal recipient (can receive from all 8 types)', () {
      final receive = getCanReceiveFrom('AB+');
      expect(receive, containsAll(['O-', 'O+', 'A-', 'A+', 'B-', 'B+', 'AB-', 'AB+']));
      expect(receive.length, equals(8));
    });

    test('AB+ can only donate to AB+', () {
      final donate = getCanDonateTo('AB+');
      expect(donate, equals(['AB+']));
    });

    test('A+ compatibility directions are correct', () {
      expect(getCanDonateTo('A+'), equals(['A+', 'AB+']));
      expect(getCanReceiveFrom('A+'), equals(['A+', 'A-', 'O+', 'O-']));
    });

    test('B- compatibility directions are correct', () {
      expect(getCanDonateTo('B-'), equals(['B-', 'B+', 'AB-', 'AB+']));
      expect(getCanReceiveFrom('B-'), equals(['B-', 'O-']));
    });

    test('Unknown or null blood type returns empty lists safely', () {
      expect(getCanDonateTo(null), isEmpty);
      expect(getCanReceiveFrom('unknown'), isEmpty);
    });
  });

  group('Wellness Content Utility Tests', () {
    test('Returns dedicated profile for each of 8 types', () {
      for (final type in ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']) {
        final profile = getWellnessForBloodType(type);
        expect(profile.bloodType, equals(type));
        expect(profile.foods, isNotEmpty);
        expect(profile.activities, isNotEmpty);
        expect(profile.mindfulNotes, isNotEmpty);
        expect(profile.engagementNote, isNotEmpty);
      }
    });

    test('Fallback profile returned for null or unknown blood type', () {
      final profile = getWellnessForBloodType('unknown');
      expect(profile.bloodType, equals('Unknown'));
      expect(profile.foods, isNotEmpty);
      expect(profile.activities, isNotEmpty);
      expect(profile.mindfulNotes, isNotEmpty);
    });
  });

  group('BloodCompatibilityCard Widget Tests', () {
    testWidgets('Renders compatibility for known donor blood type (O+)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: BloodCompatibilityCard(bloodType: 'O+'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Blood Compatibility'), findsOneWidget);
      expect(find.text('YOUR BLOOD TYPE'), findsOneWidget);
      expect(find.text('O+'), findsWidgets);
      expect(find.text('You can donate to'), findsOneWidget);
      expect(find.text('You can receive from'), findsOneWidget);
    });

    testWidgets('Renders unknown blood type guidance without guessing', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: BloodCompatibilityCard(bloodType: 'unknown'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Blood Compatibility'), findsOneWidget);
      expect(find.textContaining('You can find your blood type at your nearest hospital'), findsOneWidget);
      expect(find.text('YOUR BLOOD TYPE'), findsNothing);
    });
  });

  group('HealthScreen Widget Tests', () {
    testWidgets('Displays persistent disclaimer and known blood type wellness', (tester) async {
      final auth = AuthProvider();
      auth.updateDonor(
        DonorInfo(
          id: 'test-donor-1',
          name: 'Abebe Bikila',
          phone: '+251911223344',
          bloodType: 'O+',
        ),
      );

      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>.value(
          value: auth,
          child: const MaterialApp(
            home: HealthScreen(),
          ),
        ),
      );
      // Alert appears when page is opened
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('CAUTION'), findsOneWidget);
      expect(
        find.text('Note: These are only wellness tips and are not a substitute for real medical tests.'),
        findsOneWidget,
      );

      // Auto-disappears after timeout
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      expect(find.text('CAUTION'), findsNothing);

      // Known blood type header
      expect(find.text('Wellness tips for O+ donors'), findsOneWidget);

      // Tabs
      expect(find.text('Foods for Donors'), findsOneWidget);
      expect(find.text('Activity & Rest'), findsOneWidget);
      expect(find.text('Mindful Care'), findsOneWidget);
      expect(find.text('Daily Habits'), findsOneWidget);
    });

    testWidgets('Displays unknown blood type guidance when blood type is unselected', (tester) async {
      final auth = AuthProvider();
      auth.updateDonor(
        DonorInfo(
          id: 'test-donor-2',
          name: 'Anonymous Donor',
          phone: '+251922334455',
          bloodType: 'unknown',
        ),
      );

      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>.value(
          value: auth,
          child: const MaterialApp(
            home: HealthScreen(),
          ),
        ),
      );
      // Alert appears when page is opened
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('CAUTION'), findsOneWidget);
      expect(find.text('General Donor Wellness'), findsOneWidget);
      expect(find.textContaining('You can find your blood type at your nearest hospital'), findsOneWidget);

      // Auto-disappears after timeout
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      expect(find.text('CAUTION'), findsNothing);
    });
  });

  group('DonorFaqScreen Widget Tests', () {
    testWidgets('Renders FAQ topics and search bar', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DonorFaqScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Help & FAQ'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      expect(find.textContaining('How do I register as a donor'), findsOneWidget);

      // Search for cooldown to test interactive filtering
      await tester.enterText(find.byType(TextField), 'cooldown');
      await tester.pumpAndSettle();

      expect(find.textContaining('90-day donation cooldown'), findsOneWidget);
      expect(find.textContaining('admin@legash.com'), findsWidgets);
    });
  });
}
