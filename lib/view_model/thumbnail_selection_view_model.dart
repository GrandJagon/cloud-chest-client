import 'package:cloud_chest/models/content.dart';
import 'package:flutter/material.dart';

// Holds thumbnail selection for a given album and notifies listeners when needed
class ThumbnailSelectionViewModel extends ChangeNotifier {
  Content? _thumbnailSelection;

  Content? get selection => _thumbnailSelection;

  bool get isSelection => _thumbnailSelection != null;

  // Set a content as thumbnail selection
  // Replaces another if one already set
  // If the same is already set then removes it
  void setOrRemove(Content content) {
    if (_thumbnailSelection == content)
      _thumbnailSelection = null;
    else
      _thumbnailSelection = content;

    notifyListeners();
  }

  void clear() {
    _thumbnailSelection = null;
  }
}