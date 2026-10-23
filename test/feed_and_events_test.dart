import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:egash_mobile/models/event_model.dart';
import 'package:egash_mobile/models/post_model.dart';
import 'package:egash_mobile/providers/auth_provider.dart';
import 'package:egash_mobile/screens/donor_home_shell.dart';
import 'package:egash_mobile/screens/feed_screen.dart';
import 'package:egash_mobile/widgets/bottom_nav_bar.dart';
import 'package:egash_mobile/widgets/event_card.dart';
import 'package:provider/provider.dart';

void main() {
  group('Part 5: PostModel & Feed Parsing', () {
    test('PostModel parses image and video posts correctly', () {
      final post1 = PostModel.fromJson({
        'id': 'p1',
        'content': 'Emergency blood drive completed!',
        'mediaUrl': 'https://example.com/photo.jpg',
        'mediaType': 'image',
        'authorName': 'Red Cross',
        'createdAt': '2026-10-23T10:00:00Z',
      });

      expect(post1.id, 'p1');
      expect(post1.content, 'Emergency blood drive completed!');
      expect(post1.hasMedia, true);
      expect(post1.isImage, true);
      expect(post1.isVideo, false);
      expect(post1.authorName, 'Red Cross');

      final post2 = PostModel.fromJson({
        'id': 'p2',
        'content': 'Check out this video recap!',
        'mediaUrl': 'https://example.com/video.mp4',
        'mediaType': 'video',
        'authorName': 'Tikur Anbessa Hospital',
      });

      expect(post2.hasMedia, true);
      expect(post2.isVideo, true);
      expect(post2.isImage, false);

      final post3 = PostModel.fromJson({
        'id': 'p3',
        'content': 'Text-only announcement.',
      });

      expect(post3.hasMedia, false);
      expect(post3.authorName, 'Legash Admin');
    });
  });

  group('Part 5: Event Attribution', () {
    test('EventModel parses postedBy attribution correctly', () {
      final eventWithAttribution = EventModel.fromJson({
        'id': 'e1',
        'title': 'Community Drive',
        'description': 'Description',
        'postedBy': 'Dr. Sara',
      });
      expect(eventWithAttribution.postedBy, 'Dr. Sara');

      final eventSuperAdmin = EventModel.fromJson({
        'id': 'e2',
        'title': 'National Drive',
        'description': 'Description',
      });
      expect(eventSuperAdmin.postedBy, isNull);
    });

    testWidgets('EventCard displays postedBy byline only when present', (WidgetTester tester) async {
      final event1 = EventModel(
        id: '1',
        title: 'Community Drive',
        description: 'Join us today',
        closesAt: DateTime.now().add(const Duration(days: 3)),
        status: 'open',
        postedBy: 'Red Cross Admin',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: EventCard(event: event1),
            ),
          ),
        ),
      );

      expect(find.text('Posted by Red Cross Admin'), findsOneWidget);

      final event2 = EventModel(
        id: '2',
        title: 'Super Admin Drive',
        description: 'Nationwide effort',
        closesAt: DateTime.now().add(const Duration(days: 3)),
        status: 'open',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: EventCard(event: event2),
            ),
          ),
        ),
      );

      expect(find.textContaining('Posted by'), findsNothing);
    });
  });

  group('Part 5: Navigation & Feed Screen', () {
    testWidgets('DonorHomeShell renders 5 navigation tabs', (WidgetTester tester) async {
      final authProvider = AuthProvider();

      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>.value(
          value: authProvider,
          child: const MaterialApp(
            home: DonorHomeShell(),
          ),
        ),
      );

      // Verify bottom nav items
      expect(find.byType(BottomNavBar), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Requests'), findsOneWidget);
      expect(find.text('Feed'), findsOneWidget);
      expect(find.text('Events'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);

      // Tap on Feed tab
      await tester.tap(find.text('Feed'));
      await tester.pumpAndSettle();
      expect(find.text('COMMUNITY FEED'), findsOneWidget);

      // Tap on Events tab
      await tester.tap(find.text('Events'));
      await tester.pumpAndSettle();
      expect(find.text('Events'), findsWidgets);
    });

    testWidgets('FeedScreen shows empty state cleanly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FeedScreen(initialPosts: []),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('COMMUNITY FEED'), findsOneWidget);
      expect(find.text('No feed posts yet.'), findsOneWidget);
      expect(find.text('Check back soon for community updates.'), findsOneWidget);
    });

    testWidgets('FeedScreen renders posts with text, image, and video', (WidgetTester tester) async {
      final posts = [
        PostModel(
          id: '1',
          content: 'First post with text',
          authorName: 'Admin',
          createdAt: DateTime.now(),
        ),
        PostModel(
          id: '2',
          content: 'Second post with image',
          mediaUrl: 'https://example.com/pic.jpg',
          mediaType: 'image',
          authorName: 'Red Cross',
          createdAt: DateTime.now(),
        ),
        PostModel(
          id: '3',
          content: 'Third post with video',
          mediaUrl: 'https://example.com/video.mp4',
          mediaType: 'video',
          authorName: 'Hospital',
          createdAt: DateTime.now(),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: FeedScreen(initialPosts: posts),
        ),
      );

      await tester.pump();

      expect(find.text('First post with text'), findsOneWidget);
      expect(find.text('Second post with image'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Third post with video'),
        100,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('Third post with video'), findsOneWidget);
    });
  });
}
