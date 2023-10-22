import 'package:fire_dev/ide/constants/color.dart';
import 'package:flutter/material.dart';

class TooltipElevatedButton extends StatelessWidget {
  final String message;
  final Function() function;
  final String text;

  const TooltipElevatedButton({
    super.key,
    required this.message,
    required this.function,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      child: Container(
        margin: const EdgeInsets.fromLTRB(10.0, 10.0, 15.0, 10.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onPressed: function,
          child:
              Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
