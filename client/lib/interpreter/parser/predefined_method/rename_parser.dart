import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_dev/firebase/firebase_instances.dart';
import 'package:fire_dev/interpreter/constants/response/success.dart';
import 'package:fire_dev/interpreter/model/response.dart';
import 'package:fire_dev/interpreter/parser/parser.dart';
import 'package:fire_dev/interpreter/constants/response/error.dart';

class RenameParser with Parser {
  static Future<Response> parse(String query) async {
    final regExp = RegExp(r"^(\w+)\.(\w+)(?:\.(\w+))?\.rename\('(\w+)'\);");

    final match = regExp.firstMatch(query);
    if (match == null) return Response(isParsed: false);

    final collectId = match.group(1);
    if (collectId == null) return Error.collectionInvalidError;
    final docId = match.group(2);
    if (docId == null) return Error.documentInvalidError;
    final fieldId = match.group(3);
    final newName = match.group(4);
    if (newName == null) return Error.renameValueInvalidError;

    // Block renaming for sample datasets
    if (!hasActiveFirebase3P) {
      if (fieldId == null) {
        return Success.documentRenamed(collectId, docId, newName);
      }
      return Success.fieldRenamed(collectId, docId, fieldId, newName);
    }

    final docRef = usersFirestore.collection(collectId).doc(docId);
    final doc = await docRef.get();
    if (!doc.exists) return Error.documentNotFoundError;
    final data = doc.data()!;

    // update field name
    if (fieldId != null) {
      return _renameField(collectId, docId, docRef, data, fieldId, newName);
    }

    // update document name
    return _renameDocument(collectId, docId, docRef, data, newName);
  }

  static Future<Response> _renameField(
      String collectId,
      String docId,
      DocumentReference<Map<String, dynamic>> docRef,
      Map<String, dynamic> data,
      String fieldId,
      String newName) async {
    if (!data.containsKey(fieldId)) return Error.fieldNotFoundError;
    if (data.containsKey(newName)) return Error.fieldAlreadyExistsError;
    final value = data[fieldId];
    try {
      await docRef.update({
        fieldId: FieldValue.delete(),
        newName: value,
      });
    } on FirebaseException catch (e) {
      return Error.firebaseError(e.message);
    } catch (e) {
      return Error.runtimeError(e.toString());
    }

    return Success.fieldRenamed(collectId, docId, fieldId, newName);
  }

  static Future<Response> _renameDocument(
      String collectId,
      String docId,
      DocumentReference<Map<String, dynamic>> docRef,
      Map<String, dynamic> data,
      String newName) async {
    final newDocRef = usersFirestore.collection(collectId).doc(newName);
    final newDoc = await newDocRef.get();
    if (newDoc.exists) return Error.documentAlreadyExistsError;
    try {
      await newDocRef.set(data);
      await docRef.delete();
    } catch (e) {
      return Error.runtimeError(e.toString());
    }

    return Success.documentRenamed(collectId, docId, newName);
  }
}
