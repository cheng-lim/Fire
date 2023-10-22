import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_dev/firebase/firebase_instances.dart';
import 'package:fire_dev/interpreter/constants/response/error.dart';
import 'package:fire_dev/interpreter/constants/response/success.dart';
import 'package:fire_dev/interpreter/model/response.dart';
import 'package:fire_dev/interpreter/parser/get/condition_parser.dart';
import 'package:fire_dev/interpreter/parser/parser.dart';

class GetParser with Parser {
  static Future<Response> parse(String query) async {
    final regex = RegExp(
        r'^(\w+)(?:\.where\((.+)\))?(?:\.(\w+))?(\.\[(.+)\])?\.get\(\);$');
    final match = regex.firstMatch(query);

    if (match == null) return Response(isParsed: false);

    String? collectId = match.group(1);
    if (collectId == null) return Error.collectionInvalidError;

    String? condition = match.group(2);

    // <collection>.<condition>.get();
    if (condition != null) {
      return await ConditionParser.parse(collectId, condition);
    }

    // <collection>.<document>.get();
    // Get a single document
    if (match.group(3) != null) {
      String? docId = match.group(3);
      if (docId == null) return Error.documentInvalidError;

      DocumentSnapshot<Map<String, dynamic>> snap =
          await usersFirestore.collection(collectId).doc(docId).get();
      if (!snap.exists) return Success.withoutValues;

      return Success.withValues([
        {'id': snap.id, 'data': snap.data()}
      ]);
    }

    // <collection>.[<document>, <document>].get();
    // Get multiple documents
    if (match.group(4) != null) {
      final docIds = match.group(5)!.split(',').map((e) => e.trim()).toList();
      if (docIds.isEmpty) return Error.documentInvalidError;

      List<Map<String, dynamic>> values = [];
      for (final docId in docIds) {
        DocumentSnapshot<Map<String, dynamic>> snap =
            await usersFirestore.collection(collectId).doc(docId).get();
        if (!snap.exists) return Error.documentInvalidError;
        values.add({'id': snap.id, 'data': snap.data()});
      }

      return Success.withValues(values);
    }

    // <collection>.get();
    // Get all documents
    if (match.group(3) == null && match.group(4) == null) {
      QuerySnapshot<Map<String, dynamic>> snaps =
          await usersFirestore.collection(collectId).get();
      if (snaps.size == 0) return Success.withoutValues;

      List<Map<String, dynamic>> values = [];
      for (final snap in snaps.docs) {
        values.add({'id': snap.id, 'data': snap.data()});
      }

      return Success.withValues(values);
    }

    return Response(isParsed: false);
  }
}
