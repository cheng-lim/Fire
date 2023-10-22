import 'package:fire_dev/interpreter/model/response.dart';

class Error {
  // Get errors
  static final Response collectionInvalidError = Response(
    code: 'G001',
    message: ' CollectionInvalidError: Collection id is not found or invalid.',
    isParsed: true,
  );

  static final Response documentInvalidError = Response(
    code: 'G002',
    message: 'DocumentInvalidError: Document id is not found or invalid.',
    isParsed: true,
  );

  static final Response invalidConditionOperatorError = Response(
    code: 'G003',
    message:
        'invalidConditionOperatorError: Condition does not contain any of `>=`, `<=`, `>`, `<`, `==`, `in`, `out`.',
    isParsed: true,
  );

  static final Response unsupportedConditionFormatError = Response(
    code: 'G004',
    message:
        'UnsupportedConditionFormatError: Condition contains unsupported formats.',
    isParsed: true,
  );

  static final Response imcompleteConditionError = Response(
    code: 'G005',
    message:
        'ImcompleteConditionError: Either field, operator, or value is missing.',
    isParsed: true,
  );

  static final Response valueNullError = Response(
    code: 'G006',
    message: 'ValueNullError: Value cannot be null.',
    isParsed: true,
  );

  static final Response nullInFieldArrayError = Response(
    code: 'G007',
    message: 'NullInFieldArrayError: Elements in field array cannot be null.',
    isParsed: true,
  );

  static final Response nullInValueArrayError = Response(
    code: 'G008',
    message: 'NullInValueArrayError: Elements in value array cannot be null.',
    isParsed: true,
  );

  static final Response documentNotFoundError = Response(
    code: 'G009',
    message: 'DocumentNotFoundError: The document does not exist.',
    isParsed: true,
  );

  static final Response fieldNotFoundError = Response(
    code: 'G010',
    message: 'FieldNotFoundError: The field does not exist.',
    isParsed: true,
  );

  // Runtime errors
  static final Response invalidInputError = Response(
    code: 'R001',
    message:
        'InvalidInputError: The input does not match any parsers in Fire Interpreter. Please check your syntax whether it is correct.',
    isParsed: true,
  );

  static final Response unknownTypeError = Response(
    code: 'R002',
    message: 'UnknownTypeError: The variable type is unknown.',
    isParsed: true,
  );

  static Response firebaseError(String? errorMessage) {
    const title = 'FirebaseError:';
    return Response(
      code: 'R003',
      message: errorMessage == null
          ? '$title No error messages available'
          : '$title $errorMessage',
      isParsed: true,
    );
  }

  static Response runtimeError(String? errorMessage) {
    const title = 'RuntimeError:';
    return Response(
      code: 'R004',
      message: errorMessage == null
          ? '$title No error messages available'
          : '$title $errorMessage',
      isParsed: true,
    );
  }

  // Predefined method errors
  static final Response renameValueInvalidError = Response(
    code: 'P001',
    message: 'RenameValueInvalidError: Rename value is invalid.',
    isParsed: true,
  );

  static final Response fieldAlreadyExistsError = Response(
    code: 'P002',
    message: 'FieldAlreadyExistsError: The field already exists.',
    isParsed: true,
  );

  static final Response documentAlreadyExistsError = Response(
    code: 'P003',
    message: 'DocumentAlreadyExistsError: The document already exists.',
    isParsed: true,
  );
}
