import 'package:fire_dev/firebase/firebase_config.dart';
import 'package:fire_dev/ide/constants/testing.dart';
import 'package:fire_dev/ide/screens/home_screen.dart';
import 'package:fire_dev/interpreter/test/test_interpreter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  isTesting = bool.parse(
      const String.fromEnvironment('testing', defaultValue: 'false'));

  setUrlStrategy(
      // ignore: prefer_const_constructors
      PathUrlStrategy()); // ignore prefer_const_constructors since PathUrlStrategy do not provide a const constructor.

  // Initialize all Firebase projects
  await FirebaseConfig.initAll();

  if (isTesting) TestInterpreter.test();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fire Thrower',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
