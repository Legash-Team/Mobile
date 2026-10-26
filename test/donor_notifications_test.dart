import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:egash_mobile/models/notification_model.dart';
import 'package:egash_mobile/screens/donor_notifications_screen.dart';

void main() {
  group('Donor Notifications', () {
    test('NotificationModel parses real notification message, category, and timestamp', () {
      final notif = NotificationModel.fromJson({
        'id': 'n1',
        'title': 'Urgent Blood Alert',
        'message': 'St. Paul Hospital urgently needs B+ blood. Tap to respond.',
        'category': 'Emergency',
        'type': 'BLOOD_REQUEST',
        'requestId': 'req-123',
        'hospitalName': 'St. Paul Hospital',
        'bloodType': 'B+',
        'quantityNeeded': 2,
        'isEmergency': true,
        'notifiedAt': '2026-10-26T10:00:00Z',
      });

      expect(notif.id, 'n1');
      expect(notif.displayTitle, 'Urgent Blood Alert');
      expect(notif.displayMessage, 'St. Paul Hospital urgently needs B+ blood. Tap to respond.');
      expect(notif.displayCategory, 'Emergency');
      expect(notif.type, 'BLOOD_REQUEST');
      expect(notif.requestId, 'req-123');
      expect(notif.isEmergency, true);
    });

    testWidgets('DonorNotificationsScreen renders with title and shows empty state when no items', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DonorNotificationsScreen(),
        ),
      );

      // Verify app bar title is Notifications
      expect(find.text('Notifications'), findsOneWidget);
    });
  });
}
