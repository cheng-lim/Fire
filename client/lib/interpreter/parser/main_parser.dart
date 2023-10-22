import 'package:fire_dev/interpreter/model/response.dart';
import 'package:fire_dev/interpreter/parser/predefined_method/rename_parser.dart';
import 'get/get_parser.dart';

class MainParser {
  Future<Response> parse(String query) async {
    Response res = Response(isParsed: false);
    List<Future<Response> Function(String)> parsers = [
      GetParser.parse,
      RenameParser.parse,
    ];

    for (var parser in parsers) {
      res = await parser(query);
      if (res.isParsed!) return res;
    }

    // No matched parsers
    res
      ..code = 'R01'
      ..message = 'Syntax is incorrect and no matched parsers.';

    return res;
  }
}
