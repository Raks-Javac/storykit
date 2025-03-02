import 'dart:async';

import 'package:flutter/material.dart';

class LinePositon {
  final double top;
  final double left;
  final double right;
  final double? bottom;

  LinePositon({this.top = 10, this.left = 10, this.right = 10, this.bottom});
}

class StoryKit extends StatefulWidget {
  final List<Widget> stories;
  final int initialIndex;
  final ValueChanged<int>? onIndexChange;
  final Duration Function(int index)? durationPerStory;
  final Color progressColor;
  final Color progressBackgroundColor;
  final Widget? backgroundImage;
  final Color? wholeBackgroundColor;
  final int? currentIndex; // Allow passing currentIndex externally
  final LinePositon? linePositon;

  const StoryKit({
    super.key,
    required this.stories,
    this.initialIndex = 0,
    this.onIndexChange,
    this.durationPerStory,
    this.progressColor = Colors.blue,
    this.progressBackgroundColor = Colors.grey,
    this.backgroundImage,
    this.wholeBackgroundColor,
    this.currentIndex, // Optional external currentIndex
    this.linePositon,
  });

  @override
  StoryKitState createState() => StoryKitState();
}

class StoryKitState extends State<StoryKit> {
  late int _currentIndex;
  late Timer _timer;
  late Duration _storyDuration;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex ?? widget.initialIndex;
    _startStory();
    WidgetsBinding.instance.addPostFrameCallback((val) {
      // Start story after the first frame is rendered
    });
  }

  @override
  void didUpdateWidget(covariant StoryKit oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Synchronize _currentIndex with external currentIndex if provided
    if (widget.currentIndex != null && widget.currentIndex != _currentIndex) {
      _changeIndex(widget.currentIndex!);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startStory() {
    _storyDuration = widget.durationPerStory?.call(_currentIndex) ??
        const Duration(seconds: 5);

    _timer = Timer.periodic(
        // kDebugMode
        //     ? const Duration(milliseconds: 5000000)
        // :
        const Duration(milliseconds: 50), (timer) {
      setState(() {
        _progress += 50 / _storyDuration.inMilliseconds;
        if (_progress >= 1.0) {
          _progress = 0.0;
          _goToNext();
        }
      });
    });
  }

  void _pauseStory() {
    _timer.cancel();
  }

  void _resumeStory() {
    _startStory();
  }

  void _stopStory() {
    _timer.cancel();
  }

  void _goToNext() {
    if (_currentIndex < widget.stories.length - 1) {
      _changeIndex(_currentIndex + 1);
    } else {
      _stopStory();
    }
  }

  void _goToPrevious() {
    if (_currentIndex > 0) {
      _changeIndex(_currentIndex - 1);
    }
  }

  void _changeIndex(int newIndex) {
    _stopStory();
    setState(() {
      _currentIndex = newIndex;
      _progress = 0.0;
    });
    widget.onIndexChange?.call(newIndex);
    _startStory();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        final screenWidth = MediaQuery.of(context).size.width;
        final tapPosition = details.globalPosition.dx;
        if (tapPosition < screenWidth / 1.4) {
          _goToPrevious();
        } else {
          _goToNext();
        }
      },
      onLongPress: _pauseStory,
      onLongPressUp: _resumeStory,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Stack(
              children: [
                Container(
                  color: widget.wholeBackgroundColor,
                ),
                Positioned.fill(
                  child: widget.backgroundImage ?? const SizedBox.shrink(),
                ),

                // Story content
                Positioned.fill(
                    top: _currentIndex == 3 ||
                            _currentIndex == 4 ||
                            _currentIndex == 5
                        ? 110
                        : 20,
                    child: widget.stories[_currentIndex]),
              ],
            ),

            // Progress indicator

            Positioned(
              top: widget.linePositon?.top ?? 10,
              left: widget.linePositon?.left ?? 10,
              right: widget.linePositon?.right ?? 10,
              bottom: widget.linePositon?.bottom,
              child: Row(
                children: List.generate(widget.stories.length, (index) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: index == _currentIndex
                              ? _progress
                              : (index < _currentIndex ? 1.0 : 0.0),
                          backgroundColor: widget.progressBackgroundColor,
                          color: widget.progressColor,
                          minHeight: 3,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
