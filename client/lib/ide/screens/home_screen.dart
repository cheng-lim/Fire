import 'package:fire_dev/ide/screens/editor_screen/editor_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: EditorScreen(),
    );
  }
}
