import 'package:flutter/material.dart';

typedef SwipeCallback = void Function();

class SwipeableCard extends StatefulWidget {
  final Widget child;
  final SwipeCallback? onSwipeLeft;
  final SwipeCallback? onSwipeRight;
  final SwipeCallback? onSwipeUp;
  final SwipeCallback? onSwipeDown;

  const SwipeableCard({
    Key? key,
    required this.child,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.onSwipeUp,
    this.onSwipeDown,
  }) : super(key: key);

  @override
  _SwipeableCardState createState() => _SwipeableCardState();
}

class _SwipeableCardState extends State<SwipeableCard> {
  double _dragStartXPosition = 0.0;
  double _dragStartYPosition = 0.0;
  double _currentXPosition = 0.0;
  double _currentYPosition = 0.0;

  void _onDragStart(DragStartDetails details) {
    _dragStartXPosition = details.localPosition.dx;
    _dragStartYPosition = details.localPosition.dy;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _currentXPosition = details.localPosition.dx - _dragStartXPosition;
      _currentYPosition = details.localPosition.dy - _dragStartYPosition;
    });
  }

  void _onDragEnd(DragEndDetails details) {
    // Check swipe direction and distance
    if (_currentXPosition > 50) {
      widget.onSwipeRight?.call();
    } else if (_currentXPosition < -50) {
      widget.onSwipeLeft?.call();
    } else if (_currentYPosition > 50) {
      widget.onSwipeDown?.call();
    } else if (_currentYPosition < -50) {
      widget.onSwipeUp?.call();
    }
    // Reset position
    setState(() {
      _currentXPosition = 0;
      _currentYPosition = 0;
    });
  }

  Widget _buildIcon() {
    if (_currentXPosition.abs() > _currentYPosition.abs()) {
      // Horizontal swipe
      if (_currentXPosition > 100) {
        // Right swipe
        return const Icon(Icons.check, color: Colors.green, size: 100);
      } else if (_currentXPosition < -100) {
        // Left swipe
        return const Icon(Icons.close, color: Colors.red, size: 100);
      }
    } else {
      // Vertical swipe
      if (_currentYPosition > 100) {
        // Down swipe
        return const Icon(Icons.circle, color: Colors.white, size: 100);
      } else if (_currentYPosition < -100) {
        // Up swipe
        return const Icon(Icons.question_mark, color: Colors.grey, size: 100);
      }
    }
    return const SizedBox.shrink(); // No significant swipe, don't show any icon
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      onVerticalDragStart: _onDragStart,
      onVerticalDragUpdate: _onDragUpdate,
      onVerticalDragEnd: _onDragEnd,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.translate(
            offset: Offset(_currentXPosition, _currentYPosition),
            child: widget.child,
          ),
          _buildIcon(),
        ],
      ),
    );
  }
}
