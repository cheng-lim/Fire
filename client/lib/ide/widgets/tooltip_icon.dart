import 'package:flutter/material.dart';

class TooltipIcon extends StatelessWidget {
  final String message;
  final IconData iconData;
  final double size;
  final Color color;

  const TooltipIcon({
    super.key,
    required this.message,
    required this.iconData,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      child: Icon(
        iconData,
        size: size,
        color: color,
      ),
    );
  }
}
