import 'package:fire_dev/firebase/firebase_instances.dart';
import 'package:fire_dev/interpreter/model/response.dart';

class Success {
  // This is just a empty placeholder.
  static final Response placeholder = Response(
    code: 'Z000',
    isParsed: true,
  );

  // No message, but it means ‘succeeded with values’.
  static Response withValues(List<Map<String, dynamic>> values) {
    return Response(
      code: 'Z001',
      values: values,
      isParsed: true,
    );
  }

  // No message, but it means ‘succeeded without values’.
  static final Response withoutValues = Response(
    code: 'Z002',
    isParsed: true,
  );

  // Rename document
  static Response documentRenamed(
      String collectId, String docId, String newName) {
    String blockerMessage = hasActiveFirebase3P
        ? ''
        : 'However, the actual rename query is blocked for the sample dataset.';
    return Response(
      code: 'Z003',
      message:
          'Success: Document `$docId` in collection `$collectId` has been successfully renamed to `$newName`.$blockerMessage',
      isParsed: true,
    );
  }

  // Rename field
  static Response fieldRenamed(
      String collectId, String docId, String fieldId, String newName) {
    String blockerMessage = hasActiveFirebase3P
        ? ''
        : 'However, the actual rename query is blocked for the sample dataset.';
    return Response(
      code: 'Z004',
      message:
          'Success: Field `$fieldId` in Document `$docId`, collection `$collectId` has been successfully renamed to `$newName`.$blockerMessage',
      isParsed: true,
    );
  }
}
