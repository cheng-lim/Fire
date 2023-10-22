// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'package:flutter/material.dart';

enum Destination {
  tab,
  drawer,
  endDrawer,
}

class TooltipIconButton extends StatelessWidget {
  final String message;
  final IconData iconData;
  final Destination destination;
  final String? url;

  const TooltipIconButton({
    super.key,
    required this.message,
    required this.iconData,
    required this.destination,
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      child: IconButton(
        icon: Icon(iconData),
        onPressed: () {
          switch (destination) {
            case Destination.tab:
              if (url != null) {
                html.window.open(url!, 'new tab');
              }
              break;
            case Destination.drawer:
              Scaffold.of(context).openDrawer();
              break;
            case Destination.endDrawer:
              Scaffold.of(context).openEndDrawer();
              break;
          }
        },
        iconSize: 25,
        color: Colors.white,
      ),
    );
  }
}
