import 'package:cloud_chest/models/content.dart';
import 'package:flutter/material.dart';

// Holds user selection and provides methods to interact with it
class UserSelection extends ChangeNotifier {
  List<Content> _userSelection = [];

  List<Content> get userSelection => [..._userSelection];

  int get length => _userSelection.length;

  void addOrRemove(Content content) {
    if (!_userSelection.contains(content))
      _userSelection.add(content);
    else
      _userSelection.remove(content);
    print(_userSelection.length);
    notifyListeners();
  }

  void clearSelection() {
    _userSelection.clear();
    notifyListeners();
  }
}
