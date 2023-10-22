import 'package:flutter/material.dart';

class Snack extends StatelessWidget {
  final String message;
  const Snack({
    super.key,
    required this.message,
  });

  @override
  SnackBar build(BuildContext context) {
    return SnackBar(
      content: Text(message),
      action: SnackBarAction(
        textColor: Colors.white,
        label: 'Close',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
  }
}
