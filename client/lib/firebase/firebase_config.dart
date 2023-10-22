// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_dev/firebase/firebase_instances.dart';
import 'package:fire_dev/firebase/firebase_options.dart';
import 'package:fire_dev/ide/utils/encryption.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig {
  static Future<void> initForFirstParty() async {
    final firebase = await Firebase.initializeApp(
      options: firebaseOptions,
      name: "first",
    );
    firestore = FirebaseFirestore.instanceFor(app: firebase);
  }

  static Future<void> initForThirdParty() async {
    late bool usingFirebase3P;
    final String? firebase3PState = html.window.localStorage['3p'];
    switch (firebase3PState) {
      case 'true':
        usingFirebase3P = true;
        break;
      case 'false':
        usingFirebase3P = false;
        break;
      default:
        usingFirebase3P = false;
    }

    if (!usingFirebase3P) {
      usersFirestore = firestore;
      return;
    }

    final Map<String, String?> keys = {
      'ak': null,
      'ai': null,
      'mi': null,
      'pi': null,
    };

    for (MapEntry entry in keys.entries) {
      final secret = html.window.localStorage[entry.key];

      if (secret == null || secret.isEmpty) {
        return;
      }
      keys[entry.key] = Encryption.decrypt(secret);
    }

    try {
      firebaseInstanceNumber += 1;
      final firebase3P = await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: keys['ak']!,
          appId: keys['ai']!,
          messagingSenderId: keys['mi']!,
          projectId: keys['pi']!,
        ),
        name: '$firebaseInstanceNumber',
      );
      firestore3P = FirebaseFirestore.instanceFor(app: firebase3P);
      usersFirestore = firestore3P;
      hasActiveFirebase3P = true;
    } catch (e) {
      print(e);
    }
  }

  static Future<void> initAll() async {
    await initForFirstParty();
    await initForThirdParty();
  }
}
