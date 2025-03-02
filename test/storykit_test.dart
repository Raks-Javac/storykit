import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storykit/storykit.dart';

void main() {
  group('StoryKit Widget Tests', () {
    testWidgets('renders StoryKit with stories', (WidgetTester tester) async {
      // Arrange
      final stories = [
        Container(key: const Key('story1'), color: Colors.red),
        Container(key: const Key('story2'), color: Colors.green),
        Container(key: const Key('story3'), color: Colors.blue),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: StoryKit(
            stories: stories,
            initialIndex: 0,
            progressColor: Colors.white,
            progressBackgroundColor: Colors.grey.withOpacity(0.5),
          ),
        ),
      );

      // Act
      await tester.pumpAndSettle(); // Ensure all frames are rendered

      // Assert
      expect(find.byType(StoryKit), findsOneWidget);
      expect(find.byKey(const Key('story1')),
          findsOneWidget); // First story is visible

      // Simulate navigating to the next story
      await tester.tap(find.byType(StoryKit)); // Tap to navigate
      await tester
          .pumpAndSettle(const Duration(seconds: 5)); // Wait for animation

      // Assert
      expect(find.byKey(const Key('story1')),
          findsNothing); // First story is no longer visible
      expect(find.byKey(const Key('story2')),
          findsOneWidget); // Second story is visible
    });

    testWidgets('calls onIndexChange callback', (WidgetTester tester) async {
      // Arrange
      int currentIndex = 0;
      final stories = [
        Container(key: const Key('story1'), color: Colors.red),
        Container(key: const Key('story2'), color: Colors.green),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: StoryKit(
            stories: stories,
            initialIndex: 0,
            onIndexChange: (index) {
              currentIndex = index;
            },
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(StoryKit));
      await tester.pumpAndSettle(
          const Duration(seconds: 5)); // Wait for the story to switch index

      // Assert
      expect(currentIndex, 1);
    });

    testWidgets('applies custom duration per story',
        (WidgetTester tester) async {
      // Arrange
      final stories = [
        Container(key: const Key('story1'), color: Colors.red),
        Container(key: const Key('story2'), color: Colors.green),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: StoryKit(
            stories: stories,
            durationPerStory: (index) {
              if (index == 0) {
                return const Duration(seconds: 3); // 3 seconds for story1
              }

              return const Duration(seconds: 5); // 5 seconds for story2
            },
          ),
        ),
      );

      // Act & Assert
      // Initial state: story1 should be visible
      await tester.pump(); // Render the initial frame
      expect(find.byKey(const Key('story1')), findsOneWidget);
      expect(find.byKey(const Key('story2')), findsNothing);

      // Wait for the duration of story1 (3 seconds)
      await tester.pump(const Duration(seconds: 4));
      await tester.pump(); // Trigger a new frame

      // After 3 seconds, story1 should transition to story2
      expect(find.byKey(const Key('story1')), findsNothing);
      expect(find.byKey(const Key('story2')), findsOneWidget);

      // Wait for the duration of story2 (5 seconds)
      await tester.pump(const Duration(seconds: 5));
      await tester.pump(); // Trigger a new frame

      // After 5 seconds, story2 should still be visible (no more stories)
      expect(find.byKey(const Key('story1')), findsNothing);
      expect(find.byKey(const Key('story2')), findsOneWidget);
    });

    testWidgets('renders custom progress bar color',
        (WidgetTester tester) async {
      // Arrange
      final stories = [
        Container(key: const Key('story1'), color: Colors.red),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: StoryKit(
            stories: stories,
            progressColor: Colors.yellow,
          ),
        ),
      );

      // Act
      await tester.pump();

      // Assert
      expect(find.byType(StoryKit), findsOneWidget);
    });
  });
}
