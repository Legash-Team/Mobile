import 'package:flutter_test/flutter_test.dart';

import 'package:egash_mobile/main.dart';

void main() {
  testWidgets('App launches and shows register screen', (WidgetTester tester) async {
    await tester.pumpWidget(const LegashApp());

    expect(find.text('Join Legash'), findsOneWidget);
  });
}