import 'package:cloud_chest/models/content.dart';
import 'package:flutter/material.dart';

// Holds thumbnail selection for a given album and notifies listeners when needed
class ThumbnailSelectionViewModel extends ChangeNotifier {
  Content? _thumbnailSelection;

  Content? get selection => _thumbnailSelection;

  bool get isSelection => _thumbnailSelection != null;

  void setOrRemove(Content content) {
    print('setOrRemove called with ' + content.id.toString());

    if (_thumbnailSelection == content)
      _thumbnailSelection = null;
    else
      _thumbnailSelection = content;

    notifyListeners();
  }
}
