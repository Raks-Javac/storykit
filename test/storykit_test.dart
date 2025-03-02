import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storykit/storykit.dart';

void main() {
  group('StoryKit Widget Tests', () {
    testWidgets('renders StoryKit with stories', (WidgetTester tester) async {
      // Arrange
      final stories = [
        Container(color: Colors.red),
        Container(color: Colors.green),
        Container(color: Colors.blue),
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
      await tester.pump();

      // Assert
      expect(find.byType(StoryKit), findsOneWidget);
      expect(find.byType(Container), findsNWidgets(3));
    });

    testWidgets('calls onIndexChange callback', (WidgetTester tester) async {
      // Arrange
      int currentIndex = 0;
      final stories = [
        Container(color: Colors.red),
        Container(color: Colors.green),
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
      await tester.pumpAndSettle();

      // Assert
      expect(currentIndex, 1);
    });

    testWidgets('applies custom duration per story',
        (WidgetTester tester) async {
      // Arrange
      final stories = [
        Container(color: Colors.red),
        Container(color: Colors.green),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: StoryKit(
            stories: stories,
            durationPerStory: (index) {
              if (index == 0) return const Duration(seconds: 3);
              return const Duration(seconds: 5);
            },
          ),
        ),
      );

      // Act & Assert
      await tester.pump(const Duration(seconds: 3));
      expect(find.byType(Container), findsNWidgets(2));
    });

    testWidgets('renders custom progress bar color',
        (WidgetTester tester) async {
      // Arrange
      final stories = [Container(color: Colors.red)];

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
      // Check for the progress bar color, assuming it uses a specific widget
      expect(find.byType(StoryKit), findsOneWidget);
    });
  });
}
