import 'package:flutter/material.dart';
import 'package:storykit/storykit.dart';
// Assume this is the file where your StoryKit is implemented

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: StoryScreen(),
      ),
    );
  }
}

class StoryScreen extends StatelessWidget {
  final List<Widget> _stories = [
    Container(
      color: Colors.red,
      child: const Center(
        child: Text(
          'Story 1',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    ),
    Container(
      color: Colors.green,
      child: const Center(
        child: Text(
          'Story 2',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    ),
    Container(
      color: Colors.blue,
      child: const Center(
        child: Text(
          'Story 3',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    ),
    Container(
      color: Colors.purple,
      child: const Center(
        child: Text(
          'Story 4',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    ),
  ];

  StoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StoryKit(
      
        stories: _stories,
        initialIndex: 0,
        onIndexChange: (index) {},
        durationPerStory: (index) {
          // Custom duration per story if needed
          if (index == 1) {
            return const Duration(seconds: 7); // Story 2 lasts longer
          }
          return const Duration(seconds: 5);
        },
        progressColor: Colors.white,
        progressBackgroundColor: Colors.grey.withOpacity(0.5),
        wholeBackgroundColor: Colors.black,
        currentIndex: 0, // Start from the first story
      ),
    );
  }
}
