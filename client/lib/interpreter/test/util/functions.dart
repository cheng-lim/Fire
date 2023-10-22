// ignore_for_file: avoid_print
import 'package:collection/collection.dart';
import 'package:fire_dev/interpreter/model/response.dart';
import 'package:fire_dev/interpreter/parser/main_parser.dart';

const String _reset = '\x1B[0m';
const String _red = '\x1B[31m❌ ';
const String _green = '\x1B[32m✅ ';
const String _blue = '\x1B[34m🌀 ';

Future<void> expect({
  required final String testTitle,
  required final Response expectedResponse,
  required final String query,
}) async {
  print('🐁 [Test starts] $testTitle');
  final timer = Stopwatch()..start();

  final actualResponse = await _run(query: query);
  if (actualResponse.code != null && !actualResponse.code!.contains('Z')) {
    print(
      '$_red[Runtime error] message: ${actualResponse.message}',
    );
    return print(_reset);
  }

  print('$_blue[Test duration] ${timer.elapsedMilliseconds} ms.');

  if (expectedResponse.code != actualResponse.code) {
    print(
      '$_red[Response code] error: expected ${expectedResponse.code}, but got ${actualResponse.code}',
    );
    return print(_reset);
  }
  print('$_green[Response code] ok');
  if (expectedResponse.values == null && actualResponse.values != null) {
    print(
      '$_red[Response nullity] error: expected to be null, but it was not null',
    );
    return print(_reset);
  }
  if (expectedResponse.values != null && actualResponse.values == null) {
    print(
      '$_red[Response nullity] error: expected not to be null, but it was null',
    );
    return print(_reset);
  }
  if (expectedResponse.values == null && actualResponse.values == null) {
    print('$_green[Response nullity] ok');
    return print(_reset);
  }
  if (expectedResponse.values!.length != actualResponse.values!.length) {
    print(
      '$_red[Response size] error: expected ${expectedResponse.values!.length} , but got ${actualResponse.values!.length}',
    );
    return print(_reset);
  }
  if (expectedResponse.values!.isEmpty && actualResponse.values!.isEmpty) {
    print('$_green[Response size] zero ok');
    return print(_reset);
  }

  if (expectedResponse.values!.length != actualResponse.values!.length) {
    print(
      '$_red[Response size] error: expected size is ${expectedResponse.values!.length}, but got ${actualResponse.values!.length}',
    );
    return print(_reset);
  }

  final expectedValues = _sortByMapId(expectedResponse.values!);
  final actualValues = _sortByMapId(actualResponse.values!);

  if (!_isEqual(expectedValues, actualValues)) {
    print(
      '$_red[Response value] error: expected value is $expectedValues, but got $actualValues',
    );
    return print(_reset);
  }
  print('$_green[Response value] ok');
  print(_reset);
}

Future<Response> _run({required String query}) async {
  MainParser parser = MainParser();
  final response = await parser.parse(query);
  return response;
}

bool _isEqual(data1, data2) {
  return const DeepCollectionEquality().equals(data1, data2);
}

List<Map<String, dynamic>> _sortByMapId(List<Map<String, dynamic>> inputList) {
  inputList.sort((a, b) => (a['id'] as String).compareTo(b['id'] as String));
  return inputList;
}
