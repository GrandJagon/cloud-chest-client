import 'package:cloud_chest/models/content.dart';
import 'package:flutter/material.dart';

// Holds the content viewer state
class ContentViewerProvider extends ChangeNotifier {
  List<Content> _content = [];
  int _currentItemIndex = 0;
  Content? _currentItem;

  int get currentItemIndex => _currentItemIndex;

  Content get currentItem => _currentItem!;

  // Sets the data that will be displayed
  void setAlbumToView(List<Content> albumToView) {
    _content = albumToView;
  }

  //Sets the starting index and thus item
  void setStartingPoint(int startIndex) {
    _currentItemIndex = startIndex;
    _currentItem = _content[_currentItemIndex];
    notifyListeners();
  }

  // Sets the next item in the content list, goes back to 0 if current is last
  void nextItem() {
    if (_currentItemIndex >= _content.length - 1)
      _currentItemIndex = 0;
    else
      _currentItemIndex = _currentItemIndex + 1;

    _currentItem = _content[_currentItemIndex];
    notifyListeners();
  }

  // Sets the previous item in the content list, goes to last one if current is first
  void previousItem() {
    if (_currentItemIndex <= 0)
      _currentItemIndex = _content.length - 1;
    else
      _currentItemIndex = _currentItemIndex - 1;

    _currentItem = _content[_currentItemIndex];
    notifyListeners();
  }

  // Clears the data
  void clearContentViewer() {
    _content = [];
    _currentItemIndex = 0;
    _currentItem = null;
  }
}
