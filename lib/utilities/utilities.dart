import 'dart:io';
import 'package:path/path.dart' as path;

class Utilities {
  static getFileName(File file) {
    String name = path.basename(file.path);
    return name;
  }
}
