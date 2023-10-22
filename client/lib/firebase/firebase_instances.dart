import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

int firebaseInstanceNumber = 0;
late FirebaseFirestore firestore;
late FirebaseFirestore firestore3P;
late FirebaseFirestore usersFirestore;
final FieldValue serverTimestamp = FieldValue.serverTimestamp();
final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

bool hasActiveFirebase3P = false;
