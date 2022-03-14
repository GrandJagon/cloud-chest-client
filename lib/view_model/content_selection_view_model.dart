import 'package:cloud_chest/models/content.dart';
import 'package:flutter/material.dart';

// Holds user selection and provides methods to interact with it
class ContentSelectionViewModel extends ChangeNotifier {
  List<Content> _userSelection = [];

  List<Content> get userSelection => [..._userSelection];

  int get length => _userSelection.length;

  void addOrRemove(Content content) {
    if (!_userSelection.contains(content))
      _userSelection.add(content);
    else
      _userSelection.remove(content);

    // Rebuilds listeners only if first item is added or last one removed
    if (_userSelection.length == 0 || _userSelection.length == 1)
      notifyListeners();
  }

  void clearSelection() {
    _userSelection.clear();
    notifyListeners();
  }
}
