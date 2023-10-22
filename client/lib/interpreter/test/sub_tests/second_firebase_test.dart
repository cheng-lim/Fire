import 'package:cloud_firestore/cloud_firestore.dart';

class SecondFirebaseTest {
  static run(FirebaseFirestore fs) async {
    final fruits = await fs.collection('fruits').get();
    for (final fruit in fruits.docs) {
      print(fruit.data());
    }
  }
}
