import 'package:flutter/material.dart';

class BounceWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const BounceWidget({super.key, required this.child, required this.onTap});

  @override
  State<BounceWidget> createState() => _BounceWidgetState();
}

class _BounceWidgetState extends State<BounceWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.9,
      upperBound: 2.0,
      value: 1.0,
    );
  }

  Future<void> _animateTap() async {
    try {
      await _controller.animateTo(0.9, curve: Curves.easeOut);
      await _controller.animateTo(1.0, curve: Curves.easeIn);
      widget.onTap();
    } catch (_) {
      // prevent errors if disposed early
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _animateTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _controller.value,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}