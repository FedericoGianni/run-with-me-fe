import 'package:flutter_test/flutter_test.dart';
import 'package:runwithme/classes/file_manager.dart';

void main() {
  FileManager fileManager = FileManager();

  group('[FILE MANAGER]', () {
    test('file manager can read/write to memory', () async {
      await fileManager.writeFile("a", "a");
      fileManager.readFile("a");
      expect(fileManager.fileName, "a");
    });
  });
}
