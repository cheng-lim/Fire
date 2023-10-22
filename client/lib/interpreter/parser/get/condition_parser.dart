import 'package:fire_dev/firebase/firebase_instances.dart';
import 'package:fire_dev/interpreter/constants/response/success.dart';
import 'package:fire_dev/interpreter/model/response.dart';
import 'package:fire_dev/interpreter/constants/function/type.dart';
import 'package:fire_dev/interpreter/constants/response/error.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final List<String> _operators = [
  '==',
  '!=',
  '>=',
  '<=',
  '>',
  '<',
  ' in ',
  ' out '
];

final RegExp _singleRegex = RegExp(
    r"(\[[^\]]*\]|'[^']*'|true|false|-?\d*\.?\d+|\w+)\s*(==|!=|>=|<=|>|<|in|out)\s*(\[[^\]]*\]|'[^']*'|true|false|-?\d*\.?\d+|\w+)");

class ConditionParser {
  static Future<Response> parse(String collectId, String condition) async {
    // Check condition operator syntax
    final String condWithoutQuotedOperators =
        condition.replaceAll(RegExp(r"'(==|!=|>=|<=|>|<|in|out)'"), '');

    final hasOperator = _operators.any(
      (operator) => condWithoutQuotedOperators.contains(operator),
    );

    if (!hasOperator) return Error.invalidConditionOperatorError;

    // Single condition
    if (!_hasComma(condWithoutQuotedOperators)) {
      final match = _singleRegex.firstMatch(condition);

      if (match == null) {
        return Error.unsupportedConditionFormatError;
      }

      String? field = match.group(1);
      final String? op = match.group(2);
      String? value = match.group(3);

      if (field == null || op == null || value == null) {
        return Error.imcompleteConditionError;
      }

      if (value == 'null') {
        return Error.valueNullError;
      }

      final collectRef = usersFirestore.collection(collectId);
      final isFieldDBObj = Type.isDatabaseObject(field);
      final isValueDBObj = Type.isDatabaseObject(value);
      final isFieldArray = Type.isArray(field);
      final isValueArray = Type.isArray(value);

      final fld = Type.castPrimitiveType(field);
      final val = Type.castPrimitiveType(value);

      final isValueInequalible = (val is String || val is int || val is double);

      if (isFieldArray && Type.containsNull(fld)) {
        return Error.nullInFieldArrayError;
      }
      if (isValueArray && Type.containsNull(val)) {
        return Error.nullInValueArrayError;
      }

      Query<Map<String, dynamic>>? determineOperation() {
        if (op == '==' && isFieldDBObj && !isValueDBObj) {
          return collectRef.where(fld, isEqualTo: val);
        }
        if (op == '>=' && isFieldDBObj && !isValueDBObj && isValueInequalible) {
          return collectRef.where(fld, isGreaterThanOrEqualTo: val);
        }
        if (op == '<=' && isFieldDBObj && !isValueDBObj && isValueInequalible) {
          return collectRef.where(fld, isLessThanOrEqualTo: val);
        }
        if (op == '>' && isFieldDBObj && !isValueDBObj && isValueInequalible) {
          return collectRef.where(fld, isGreaterThan: val);
        }
        if (op == '<' && isFieldDBObj && !isValueDBObj && isValueInequalible) {
          return collectRef.where(fld, isLessThan: val);
        }
        if (op == '!=' && isFieldDBObj && !isValueDBObj) {
          return collectRef.where(fld, isNotEqualTo: val);
        }
        if (op == 'in') {
          if (isFieldDBObj && isValueArray) {
            return collectRef.where(fld, whereIn: val);
          }
          if (!isFieldDBObj && !isFieldArray && isValueDBObj) {
            return collectRef.where(val, arrayContains: fld);
          }
          if (!isFieldDBObj && isFieldArray && isValueDBObj) {
            return collectRef.where(val, arrayContainsAny: fld);
          }
        }
        if (op == 'out') {
          if (isFieldDBObj && !isValueDBObj && isValueArray) {
            return collectRef.where(field, whereNotIn: val);
          }
        }

        // arrayDoesNotContain (not firestore-feature) is not supported yet

        return null;
      }

      final Query<Map<String, dynamic>>? query = determineOperation();

      if (query == null) return Error.invalidConditionOperatorError;

      var snaps = await query.get();
      if (snaps.size == 0) return Success.withoutValues;

      List<Map<String, dynamic>> values = [];
      for (final snap in snaps.docs) {
        values.add({'id': snap.id, 'data': snap.data()});
      }
      return Success.withValues(values);
    }

    return Error.unsupportedConditionFormatError;

    // this code is pending for complex query
    //   List<Map<int, String>> priorities = [];

    //   List<String> parts = _breakUpConditions(conditions);
    //   int max_priority = 0;
    //   int priority = 0;
    //   for (final part in parts) {
    //     if (part.contains('[') || part.contains('(')) {
    //       max_priority = priority + 1;
    //       priorities.add({max_priority: part});
    //       continue;
    //     }
    //     priorities.add({priority: part});
    //   }
    //   print(priorities);
    // }

    // static List<String> _breakUpConditions(String conditions) {
    //   List<String> elements = [];
    //   List<String> stack = [];
    //   StringBuffer buffer = StringBuffer();

    //   for (int i = 0; i < conditions.length; i++) {
    //     if (conditions[i] == '[' || conditions[i] == '(') {
    //       stack.add(conditions[i]);
    //       buffer.write(conditions[i]);
    //     } else if (conditions[i] == ']' || conditions[i] == ')') {
    //       stack.removeLast();
    //       buffer.write(conditions[i]);
    //     } else if (conditions[i] == ',' && stack.isEmpty) {
    //       elements.add(buffer.toString().trim());
    //       buffer.clear();
    //     } else {
    //       buffer.write(conditions[i]);
    //     }

    //     if (i == conditions.length - 1) {
    //       elements.add(buffer.toString().trim());
    //     }
    //   }
    //   return elements;
    //
  }

  static bool _hasComma(String s) {
    int bracketCount = 0;
    int parenthesisCount = 0;

    for (int i = 0; i < s.length; i++) {
      switch (s[i]) {
        case '[':
          bracketCount++;
          break;
        case ']':
          bracketCount--;
          break;
        case '(':
          parenthesisCount++;
          break;
        case ')':
          parenthesisCount--;
          break;
        case ',':
          if (bracketCount == 0 && parenthesisCount == 0) {
            return true;
          }
          break;
        default:
          break;
      }
    }

    return false;
  }
}
