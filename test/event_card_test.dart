import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:egash_mobile/models/event_model.dart';
import 'package:egash_mobile/widgets/event_card.dart';
import 'package:egash_mobile/widgets/video_player.dart';

void main() {
  testWidgets('EventCard displays image when mediaType is image', (WidgetTester tester) async {
    final event = EventModel(
      id: '1',
      title: 'Blood Drive 2026',
      description: 'Come donate blood',
      mediaUrl: 'https://example.com/poster.jpg',
      mediaType: 'image',
      closesAt: DateTime.now().add(const Duration(days: 3)),
      status: 'open',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: EventCard(event: event),
          ),
        ),
      ),
    );

    expect(find.byType(EventCard), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(VideoPlayer), findsNothing);
  });

  testWidgets('EventCard displays VideoPlayer widget when mediaType is video', (WidgetTester tester) async {
    final event = EventModel(
      id: '2',
      title: 'Drive Highlights',
      description: 'Watch the recap video',
      mediaUrl: 'https://example.com/video.mp4',
      mediaType: 'video',
      closesAt: DateTime.now().add(const Duration(days: 3)),
      status: 'open',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: EventCard(event: event),
          ),
        ),
      ),
    );

    expect(find.byType(EventCard), findsOneWidget);
    expect(find.byType(VideoPlayer), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });
}
