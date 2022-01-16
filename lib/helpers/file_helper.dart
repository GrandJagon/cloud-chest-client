// Provides method to store files in the library and convert them
import 'dart:typed_data';

import 'package:flutter/services.dart';

class FileHelper {
  static FileHelper _singleton = new FileHelper._internal();

  factory FileHelper() {
    return _singleton;
  }

  FileHelper._internal();
}
