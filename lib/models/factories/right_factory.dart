import 'package:cloud_chest/widgets/album_settings/users/right_icon.dart';
import 'package:flutter/material.dart';

import '../right.dart';

class RightFactory {
  // Creates right object from string value
  // Used for parsing JSON from API
  static Right createRight(String value) {
    switch (value) {
      case ('admin'):
        return AdminRight(value);
      case ('content:read'):
        return ViewRight(value);
      case ('content:add'):
        return PostRight(value);
      case ('content:delete'):
        return DeleteRight(value);
      default:
        throw Exception('Right string value not valid => ' + value);
    }
  }

  // Takes array of strings and returns array of Right objects
  static List<Right> fromArray(List<dynamic> stringList) {
    List<Right> rightList = [];

    stringList.forEach((value) => rightList.add(createRight(value)));

    return rightList;
  }

  // Takes a right and returns the proper icon to display in album settings
  static RightIcon createIcon(String value) {
    switch (value) {
      case 'admin':
        return RightIcon(Colors.green, 'A');
      case 'content:read':
        return RightIcon(Colors.blue, 'V');
      case 'content:add':
        return RightIcon(Colors.orange, 'P');
      case 'content:delete':
        return RightIcon(Colors.red, 'D');
      default:
        throw Exception('Right string value not valid => ' + value);
    }
  }
}
