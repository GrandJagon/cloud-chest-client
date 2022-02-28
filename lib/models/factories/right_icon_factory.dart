import 'package:flutter/material.dart';

import '../../widgets/album_settings/users/right_icon.dart';

class RightIconFactory {
  static createIcon(String right) {
    switch (right) {
      case 'admin':
        return RightIcon(Colors.green, 'A');
      case 'content:read':
        return RightIcon(Colors.blue, 'V');
      case 'content:add':
        return RightIcon(Colors.orange, '+');
      case 'content:delete':
        return RightIcon(Colors.red, '-');
    }
  }
}
