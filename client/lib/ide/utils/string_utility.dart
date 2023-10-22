import 'package:fire_dev/interpreter/model/response.dart';

class StringUtility {
  /// Reformat the response from the interpreter into JSON-like output.
  static String restyleOutput(Response res) {
    String restyledValues = "";

    // Loop through the list of value maps in the response, displaying one map per line.
    if (res.values != null) {
      for (Map<String, dynamic> map in res.values!) {
        // 1. Extract and display id for this map
        String id = map['id'];
        String restyledMap = "$id -> [\n";

        // 2. Extract and display data for this map
        Map<String, dynamic> data = map['data'];
        data.forEach((key, value) {
          value = _addSingleQuotesForString(value);
          restyledMap += "  $key -> $value,\n";
        });
        // Remove the comma in the last line. Use '-2' because the last character is a line break.
        restyledMap = restyledMap.substring(0, restyledMap.length - 2);

        // Closing square bracket for this map
        restyledMap += "\n],";

        restyledValues += "$restyledMap\n";
      }

      // Remove the comma in the last line overall. Use '-2' because the last character is a line break.
      restyledValues = restyledValues.substring(0, restyledValues.length - 2);
    }
    String restyledOutput =
        "${res.message != null ? "${res.message}\n" : ""}${restyledValues != "" ? "$restyledValues\n\n" : ""}";
    return restyledOutput;
  }

  /// Add single quotes for string.
  static dynamic _addSingleQuotesForString(dynamic value) {
    // String
    if (value is String) {
      value = "'$value'";
    }

    // List
    if (value is List) {
      for (int i = 0; i < value.length; i++) {
        if (value[i] is String) {
          value[i] = "'${value[i]}'";
        }
      }
    }

    // Map
    if (value is Map<String, dynamic>) {
      Map<String, dynamic> updatedMap = {};

      value.forEach((key, value) {
        if (value is String) {
          updatedMap["'$key'"] = "'$value'";
        } else {
          updatedMap["'$key'"] = value;
        }
      });
      value = updatedMap;
    }

    return value;
  }
}
