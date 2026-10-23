import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:egash_mobile/screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Part 12: Onboarding Extension', () {
    test('OnboardingScreen isCompleted flag persists with SharedPreferences', () async {
      expect(await OnboardingScreen.isCompleted(), isFalse);
      await OnboardingScreen.markCompleted();
      expect(await OnboardingScreen.isCompleted(), isTrue);
    });

    testWidgets('OnboardingScreen renders initial slide and page dots', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardingScreen(),
        ),
      );

      // Verify first slide content
      expect(find.text("Blood, matched to where it's needed"), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_rounded), findsOneWidget);

      // Verify dots indicator count (7 slides)
      final dotsFinder = find.byType(AnimatedContainer);
      expect(dotsFinder, findsNWidgets(7));
    });

    testWidgets('OnboardingScreen advances through slides on arrow tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardingScreen(),
        ),
      );

      // Advance to slide 2
      await tester.tap(find.byIcon(Icons.arrow_forward_rounded));
      await tester.pumpAndSettle();
      expect(find.text('Community Feed & Events'), findsOneWidget);

      // Advance to slide 3
      await tester.tap(find.byIcon(Icons.arrow_forward_rounded));
      await tester.pumpAndSettle();
      expect(find.text('Share urgent requests'), findsOneWidget);

      // Advance to slide 4
      await tester.tap(find.byIcon(Icons.arrow_forward_rounded));
      await tester.pumpAndSettle();
      expect(find.text('Your Health & Compatibility'), findsOneWidget);

      // Advance to slide 5
      await tester.tap(find.byIcon(Icons.arrow_forward_rounded));
      await tester.pumpAndSettle();
      expect(find.text('24/7 AI Health Assistant'), findsOneWidget);
    });

    testWidgets('OnboardingScreen Skip button navigates directly to final slide', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/register': (_) => const Scaffold(body: Text('Register Route')),
            '/login': (_) => const Scaffold(body: Text('Login Route')),
          },
          home: const OnboardingScreen(),
        ),
      );

      // Tap skip
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      // Verify final slide content
      expect(find.text('Ready to save a life?'), findsOneWidget);
      expect(find.text('Create an account'), findsOneWidget);
      expect(find.text('I already have an account'), findsOneWidget);
      expect(find.text('Skip'), findsNothing);

      // Tap Create Account
      await tester.tap(find.text('Create an account'));
      await tester.pumpAndSettle();

      expect(find.text('Register Route'), findsOneWidget);
      expect(await OnboardingScreen.isCompleted(), isTrue);
    });
  });
}
