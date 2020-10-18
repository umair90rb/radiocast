import 'package:path_provider/path_provider.dart';

import 'dart:io';

class ReadWriteFile{

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  getPath() async {
    final path = await _localPath;
    return "$path/user.txt";
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/user.txt');
  }

  Future<File> writeData(String data) async {
    final file = await _localFile;

    // Write the file.
    return file.writeAsString(data);
  }

  Future<String> readData() async {
    try {
      final file = await _localFile;

      // Read the file.
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0.
      return null;
    }
  }



}