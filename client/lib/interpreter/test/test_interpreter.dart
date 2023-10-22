import 'package:fire_dev/interpreter/test/sub_tests/get_test.dart';
import 'package:fire_dev/interpreter/test/sub_tests/rename_test.dart';

class TestInterpreter {
  static Future<void> test() async {
    await GetTest.run();
    await RenameTest.run();
  }
}
