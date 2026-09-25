import 'package:flutter/material.dart';

class TouchableOpacity extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Duration duration;
  final double opacity;

  const TouchableOpacity({
    super.key,
    required this.child,
    this.onTap,
    this.duration = const Duration(milliseconds: 150),
    this.opacity = 0.5,
  });

  @override
  State<TouchableOpacity> createState() => _TouchableOpacityState();
}

class _TouchableOpacityState extends State<TouchableOpacity> {
  bool isDown = false;
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => isDown = true),
        onTapUp: (_) => setState(() => isDown = false),
        onTapCancel: () => setState(() => isDown = false),
        onTap: widget.onTap,
        child: AnimatedOpacity(
          duration: widget.duration,
          opacity: isDown
              ? widget.opacity
              : (isHovered ? (widget.opacity + 1) / 2 : 1),
          child: widget.child,
        ),
      ),
    );
  }
}