import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:egash_mobile/models/event_model.dart';
import 'package:egash_mobile/models/post_model.dart';
import 'package:egash_mobile/screens/event_detail_screen.dart';
import 'package:egash_mobile/screens/post_detail_screen.dart';
import 'package:egash_mobile/widgets/event_card.dart';
import 'package:egash_mobile/widgets/post_card.dart';

void main() {
  group('Detail Screens — Event & Post', () {
    testWidgets('EventDetailScreen renders all campaign information and apply button', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final event = EventModel(
        id: 'event-101',
        title: 'National Blood Donation Day',
        description: 'Join us at Meskel Square to give blood and save lives.',
        applyLink: 'https://legash.org/join',
        closesAt: DateTime.now().add(const Duration(days: 5)),
        status: 'open',
        postedBy: 'Addis Ababa Blood Bank',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: EventDetailScreen(event: event),
        ),
      );

      expect(find.text('Campaign Details'), findsOneWidget);
      expect(find.text('National Blood Donation Day'), findsOneWidget);
      expect(find.text('Addis Ababa Blood Bank'), findsOneWidget);
      expect(find.text('Join us at Meskel Square to give blood and save lives.'), findsOneWidget);
      expect(find.text('ACTIVE CAMPAIGN'), findsOneWidget);
      expect(find.text('Apply / Register to Donate'), findsOneWidget);
    });

    testWidgets('Tapping EventCard navigates to EventDetailScreen', (tester) async {
      final event = EventModel(
        id: 'event-102',
        title: 'Tikur Anbessa Emergency Drive',
        description: 'Urgent need for O- and O+ blood types.',
        closesAt: DateTime.now().add(const Duration(days: 2)),
        status: 'open',
        postedBy: 'Tikur Anbessa Hospital',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EventCard(event: event),
          ),
        ),
      );

      expect(find.byType(EventCard), findsOneWidget);
      await tester.tap(find.text('Posted by Tikur Anbessa Hospital'));
      await tester.pumpAndSettle();

      expect(find.byType(EventDetailScreen), findsOneWidget);
      expect(find.text('Campaign Details'), findsOneWidget);
    });

    testWidgets('PostDetailScreen renders author, content, and category badge', (tester) async {
      final post = PostModel(
        id: 'post-201',
        content: 'We collected over 200 units of blood this weekend! Thank you to all donors.',
        authorName: 'St. Paul Hospital Blood Center',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: PostDetailScreen(post: post),
        ),
      );

      expect(find.text('Community Update'), findsOneWidget);
      expect(find.text('St. Paul Hospital Blood Center'), findsOneWidget);
      expect(find.text('We collected over 200 units of blood this weekend! Thank you to all donors.'), findsOneWidget);
      expect(find.text('UPDATE'), findsOneWidget);
      expect(find.text('Share Update with Friends & Family'), findsOneWidget);
    });

    testWidgets('Tapping PostCard navigates to PostDetailScreen', (tester) async {
      final post = PostModel(
        id: 'post-202',
        content: 'Mobile donation bus is now stationed around Stadium.',
        authorName: 'National Blood Bank',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostCard(post: post),
          ),
        ),
      );

      expect(find.byType(PostCard), findsOneWidget);
      await tester.tap(find.text('Posted by National Blood Bank'));
      await tester.pumpAndSettle();

      expect(find.byType(PostDetailScreen), findsOneWidget);
      expect(find.text('Community Update'), findsOneWidget);
    });
  });
}
