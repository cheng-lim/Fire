import 'package:fire_dev/interpreter/constants/response/error.dart';
import 'package:get/utils.dart';

class Type {
  static dynamic castPrimitiveType(String input) {
    if (input.isBool) return bool.parse(input);
    if (input.isNum) return num.parse(input);
    if (input == 'null') return null;
    if (input.contains('[') && input.contains(']')) return _castArray(input);
    if (input.contains("'")) return input.replaceAll("'", '');
    return input;
  }

  static bool containsNull(List<dynamic> array) {
    for (final e in array) {
      if (e == null) return true;
    }
    return false;
  }

  static List<dynamic> _castArray(String input) {
    var arrayContent = input.substring(1, input.length - 1).split(',');
    List<dynamic> array =
        arrayContent.map((e) => castPrimitiveType(e.trim())).toList();
    return array;
  }

  static bool isDatabaseObject(String input) {
    if (input == 'true' || input == 'false' || input == 'null') return false;
    if (RegExp(r"^\d+$").hasMatch(input)) return false;
    if (RegExp(r"^\w+$").hasMatch(input)) return true;
    return false;
  }

  static bool isArray(String input) {
    if (RegExp(r"^\[.*\]$").hasMatch(input)) return true;
    return false;
  }

  static dynamic getType(String input) {
    // determine number type
    if (RegExp(r"^\d+(\.\d+)?$").hasMatch(input)) return "number";

    // determine string type
    if (RegExp(r"^'[^']*'$").hasMatch(input)) return "string";

    // determine boolean type
    if (input == "true" || input == "false") return "boolean";

    // determine database object type: <collection>, <document>, <field>
    if (RegExp(r"^\w+$").hasMatch(input)) return "database object";

    // determine array type and its elements' type
    if (RegExp(r"^\[.*\]$").hasMatch(input)) {
      var arrayContent = input.substring(1, input.length - 1).split(',');
      List<dynamic> arrayTypes =
          arrayContent.map((e) => getType(e.trim())).toList();
      return "array -> ${arrayTypes.join(", ")}";
    }

    return Error.unknownTypeError;
  }
}
