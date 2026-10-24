import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:egash_mobile/models/post_model.dart';
import 'package:egash_mobile/widgets/post_card.dart';
import 'package:egash_mobile/widgets/video_player.dart';

void main() {
  testWidgets('PostCard displays image when mediaType is image', (WidgetTester tester) async {
    final post = PostModel(
      id: 'p1',
      content: 'Emergency blood drive completed!',
      mediaUrl: 'https://example.com/photo.jpg',
      mediaType: 'image',
      authorName: 'Red Cross Ethiopia',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: PostCard(post: post),
          ),
        ),
      ),
    );

    expect(find.byType(PostCard), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(VideoPlayer), findsNothing);
    expect(find.text('Emergency blood drive completed!'), findsOneWidget);
    expect(find.text('COMMUNITY UPDATE'), findsOneWidget);
    expect(find.text('Posted by Red Cross Ethiopia'), findsOneWidget);
    expect(find.text('2h ago'), findsOneWidget);
  });

  testWidgets('PostCard displays VideoPlayer when mediaType is video', (WidgetTester tester) async {
    final post = PostModel(
      id: 'p2',
      content: 'Drive highlights recap video',
      mediaUrl: 'https://example.com/video.mp4',
      mediaType: 'video',
      authorName: 'Black Lion Hospital',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: PostCard(post: post),
          ),
        ),
      ),
    );

    expect(find.byType(PostCard), findsOneWidget);
    expect(find.byType(VideoPlayer), findsOneWidget);
    expect(find.byType(Image), findsNothing);
    expect(find.text('Drive highlights recap video'), findsOneWidget);
    expect(find.text('Posted by Black Lion Hospital'), findsOneWidget);
    expect(find.text('1d ago'), findsOneWidget);
  });

  testWidgets('PostCard renders cleanly for text-only post without media banner', (WidgetTester tester) async {
    final post = PostModel(
      id: 'p3',
      content: 'Reminder: Tomorrow is World Blood Donor Day.',
      authorName: 'National Blood Bank',
      createdAt: DateTime.now(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: PostCard(post: post),
          ),
        ),
      ),
    );

    expect(find.byType(PostCard), findsOneWidget);
    expect(find.byType(Image), findsNothing);
    expect(find.byType(VideoPlayer), findsNothing);
    expect(find.text('Reminder: Tomorrow is World Blood Donor Day.'), findsOneWidget);
    expect(find.text('Posted by National Blood Bank'), findsOneWidget);
    expect(find.text('Just now'), findsOneWidget);
  });
}
