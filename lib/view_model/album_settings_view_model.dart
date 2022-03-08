import 'package:cloud_chest/models/user.dart';
import 'package:flutter/material.dart';

import '../models/album_settings.dart';

// Holds album settings state until it is validated and passed to the current album view model and the API
// Notifies listener when needed
// Thumbnail has 2 values thumbnailSelection and thumbnailTempSelection in order to change display of chosen one in selection dialog
class AlbumSettingsViewModel extends ChangeNotifier {
  String? _id;
  String? _title;
  List<User>? _users;
  String? _thumbnail;
  String? _thumbnailTemp;

  String? get id => _id;

  String? get title => _title;

  List<User>? get users => [..._users!];

  String? get thumbnail => _thumbnail;

  String? get thumbnailTemp => _thumbnailTemp;

  bool get isThumbnail => (_thumbnail != '' && _thumbnail != null);

  bool get isThumbnailTemp => (_thumbnailTemp != '' && _thumbnailTemp != null);

  // Takes an AlbumDetail object to init its values
  void initState(AlbumSettings albumSettings) {
    _id = albumSettings.albumId;
    _title = albumSettings.title;
    _thumbnail = albumSettings.thumbnail;
    _users = albumSettings.users;
  }

  // Clears all the state
  // Called on exit
  void clear() {
    _thumbnailTemp = null;
    _thumbnail = null;
    _id = null;
    _title = null;
    _users = null;
  }

  // Called when choosing a thumbnail from thumbnail dialog
  // Temporary state in order to display selection state on screen
  void setOrRemoveThumbnail(String contentPath) {
    if (_thumbnailTemp == contentPath)
      _thumbnailTemp = null;
    else
      _thumbnailTemp = contentPath;

    notifyListeners();
  }

  // Called on exit thumbnail selection dialog
  void clearThumbnailTemp() {
    _thumbnailTemp = null;
  }

  // Called when selection is validated and dialog closed
  // Stores the chosen thumbnail in variable and clears the temp one
  void validateThumbnailSelection() {
    _thumbnail = _thumbnailTemp;
    _thumbnailTemp = null;
    notifyListeners();
  }

  // Called to update one particuylar users rights
  void updateUserRights(int userIndex, List<String> newRights) {
    final User user = _users![userIndex];

    user.updateRights(newRights);

    print('RIGHTS UPDATED? NOTIFIYNG');

    notifyListeners();
  }
}
