import 'package:fire_dev/firebase/firebase_instances.dart';
import 'package:fire_dev/interpreter/constants/response/success.dart';
import 'package:fire_dev/interpreter/test/util/functions.dart';

class RenameTest {
  static run() async {
    // reset the field name
    await firestore.collection('phones').doc('iphone').set({'os': 'ios'});
    await expect(
      testTitle: 'Rename a field',
      expectedResponse: Success.fieldRenamed('phones', 'iphone', 'os', 'xxx'),
      query: "phones.iphone.os.rename('xxx');",
    );

    // reset the document name
    await firestore.collection('phones').doc('nexus').delete();
    await firestore.collection('phones').doc('pixel').set({'os': 'android'});
    await expect(
      testTitle: 'Rename a document',
      expectedResponse: Success.documentRenamed('phones', 'pixel', 'nexus'),
      query: "phones.pixel.rename('nexus');",
    );
  }
}
