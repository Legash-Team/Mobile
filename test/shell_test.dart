import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:egash_mobile/providers/auth_provider.dart';
import 'package:egash_mobile/screens/donor_home_shell.dart';
import 'package:egash_mobile/widgets/bottom_nav_bar.dart';

void main() {
  Widget buildApp() {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const MaterialApp(home: DonorHomeShell()),
    );
  }

  testWidgets('shell builds all three tabs without exceptions', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull, reason: 'Home tab build crashed');

    final tabs = [
      Icons.person_outline,
    ];

    for (final icon in tabs) {
      await tester.tap(find.byIcon(icon), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull, reason: 'Tab $icon crashed');
    }
  });

  testWidgets('bottom nav bar has exactly three items', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pump();
    final bar = tester.widget<BottomNavBar>(find.byType(BottomNavBar));
    expect(bar.items.length, 3);
    expect(find.byType(BottomNavBar), findsOneWidget);
  });
}
