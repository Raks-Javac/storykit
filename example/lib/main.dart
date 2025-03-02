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
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  'https://images.pexels.com/photos/30847375/pexels-photo-30847375/free-photo-of-stylish-man-walking-along-brick-wall-at-sunset.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'))),
    ),
    Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  'https://images.pexels.com/photos/30913847/pexels-photo-30913847/free-photo-of-indoor-artistic-scene-with-calligraphy-and-cat.jpeg?auto=compress&cs=tinysrgb&w=800&lazy=load'))),
    ),
    Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  'https://images.pexels.com/photos/30704111/pexels-photo-30704111/free-photo-of-crowds-enjoy-festival-at-vienna-city-hall.jpeg?auto=compress&cs=tinysrgb&w=800&lazy=load'))),
    ),
  ];

  StoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: StoryKit(
          linePositon: LinePositon(
            top: 30,
          ),
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

          progressBackgroundColor: Colors.black.withOpacity(0.9),
          wholeBackgroundColor: Colors.black,
          currentIndex: 0, // Start from the first story
        ),
      ),
    );
  }
}
