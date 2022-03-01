import 'package:cloud_chest/models/content.dart';
import 'package:flutter/material.dart';

// Holds thumbnail selection for a given album and notifies listeners when needed
class ThumbnailSelectionViewModel extends ChangeNotifier {
  Content? _thumbnailSelection;
  Content? _tempSelection;

  Content? get selection => _thumbnailSelection;

  Content? get tempSelection => _tempSelection;

  bool get isSelection => _thumbnailSelection != null;

  bool get isTempSelection => _tempSelection != null;

  // Called when choosing a thumbnail from thumbnail dialog
  // Temporary state in order to display selection state on screen
  void setOrRemove(Content content) {
    if (_tempSelection == content)
      _tempSelection = null;
    else
      _tempSelection = content;

    notifyListeners();
  }

  // Called when selection is validated and dialog closed
  // Stores the chosen thumbnail in variable and clears the temp one
  void validateSelection() {
    _thumbnailSelection = _tempSelection;
    _tempSelection = null;
    print('Selection validated with ' + _thumbnailSelection.toString());
    notifyListeners();
  }

  // Called when exiting without validating selection
  void clearTemp() {
    _tempSelection = null;
    notifyListeners();
  }

  // Clears all the state
  void clear() {
    _tempSelection = null;
    _thumbnailSelection = null;
  }
}
