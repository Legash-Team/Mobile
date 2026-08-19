import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:egash_mobile/main.dart';

void main() {
  testWidgets('App shows onboarding for first-time users', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const LegashApp());
    await tester.pumpAndSettle();

    expect(find.text("Blood, matched to where it's needed"), findsOneWidget);
  });

  testWidgets('App shows login when onboarding completed', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding_completed': true,
    });

    await tester.pumpWidget(const LegashApp());
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back'), findsOneWidget);
  });
}
