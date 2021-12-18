import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class FileManager {
  String fileName = "";

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  Future<String> readFile(String fName) async {
    try {
      fileName = fName;
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return 'Null';
    }
  }

  Future<File> writeFile(String counter, String fName) async {
    fileName = fName;
    final file = await _localFile;

    // Write the

    return file.writeAsString(counter);
  }

  Future<bool> deleteFile(fName) async {
    fileName = fName;
    try {
      final file = await _localFile;

      await file.delete();
    } catch (e) {
      return false;
    }
    return false;
  }
}
