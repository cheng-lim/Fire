// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:fire_dev/firebase/firebase_config.dart';
import 'package:fire_dev/firebase/firebase_instances.dart';
import 'package:fire_dev/ide/constants/color.dart';
import 'package:fire_dev/ide/utils/encryption.dart';
import 'package:fire_dev/ide/widgets/drawer_title.dart';
import 'package:fire_dev/ide/widgets/snack.dart';
import 'package:fire_dev/ide/widgets/tooltip_elevated_button.dart';
import 'package:fire_dev/ide/widgets/tooltip_icon.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class DatabaseConfigDrawer extends StatefulWidget {
  const DatabaseConfigDrawer({super.key});

  @override
  State<DatabaseConfigDrawer> createState() => _DatabaseConfigDrawerState();
}

class _DatabaseConfigDrawerState extends State<DatabaseConfigDrawer> {
  final Map<String, Map<String, dynamic>> items = {};
  late bool usingFirebase3P;

  @override
  void initState() {
    final titles = <String, String>{
      'ak': 'API Key',
      'ai': 'App Id',
      'mi': 'Messaging Sender Id',
      'pi': 'Project Id',
    };
    titles.forEach((key, value) {
      items[key] = {'title': value, 'controller': TextEditingController()};
    });
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
    super.initState();
  }

  List<Padding> textFields() {
    List<Padding> fields = [];
    for (final item in items.values) {
      fields.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 40.0),
          child: SizedBox(
            height: 50,
            width: 300,
            child: TextFormField(
              maxLength: 50,
              controller: item['controller'],
              cursorColor: Colors.white,
              decoration: InputDecoration(
                labelText: item['title'],
                labelStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
                counterText: "",
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                filled: true,
                fillColor: inputColor,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    width: 0,
                    color: Colors.white,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    width: 0,
                    color: Colors.white,
                  ),
                ),
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
        ),
      );
    }
    return fields;
  }

  @override
  void dispose() {
    for (final item in items.values) {
      item['controller'].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    items.forEach((key, value) {
      final secret = html.window.localStorage[key];
      if (secret != null) {
        value['controller'].text = Encryption.decrypt(secret);
      }
    });

    return Drawer(
      width: 350,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: drawerColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DrawerTitle(title: 'Firestore Configuration'),
              SizedBox(width: 5),
              TooltipIcon(
                message:
                    "All database secrets are encrypted and stored in your browser's local storage.\nThey are only used to access your database provider's server from the client side and are never sent to our server.",
                iconData: Icons.help_outline_rounded,
                size: 20,
                color: Colors.white,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 45.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Use third party Cloud Firestore',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                SizedBox(
                  height: 25,
                  width: 100,
                  child: FittedBox(
                    child: Switch(
                      value: usingFirebase3P,
                      activeColor: Colors.white,
                      activeTrackColor: buttonColor,
                      inactiveTrackColor: Colors.grey,
                      inactiveThumbColor: Colors.black12,
                      onChanged: (bool value) {
                        setState(() => usingFirebase3P = value);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...textFields(),
          TooltipElevatedButton(
            message: 'Save database configuration',
            function: () async {
              String snackMessage = 'Database configurations have been saved';

              html.window.localStorage['3p'] = '$usingFirebase3P';

              try {
                if (hasActiveFirebase3P) {
                  await Firebase.app('$firebaseInstanceNumber').delete();
                }

                if (usingFirebase3P) {
                  items.forEach((key, value) {
                    html.window.localStorage[key] =
                        Encryption.encrypt(value['controller'].text);
                  });
                  await FirebaseConfig.initForThirdParty();
                  hasActiveFirebase3P = true;
                } else {
                  usersFirestore = firestore;
                  hasActiveFirebase3P = false;
                }
                // ignore: use_build_context_synchronously
                Scaffold.of(context).closeEndDrawer();
              } catch (e) {
                final errorMessage = e.toString();
                if (errorMessage.contains('invalid value')) {
                  snackMessage = 'Invalid value';
                } else {
                  snackMessage = 'FirebaseError: $e';
                }
              } finally {
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(Snack(
                  message: snackMessage,
                ).build(context));
              }
            },
            text: 'Save',
          ),
        ],
      ),
    );
  }
}
