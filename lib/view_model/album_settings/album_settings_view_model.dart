import 'package:cloud_chest/exceptions/cloud_chest_exceptions.dart';
import 'package:cloud_chest/models/factories/right_factory.dart';
import 'package:cloud_chest/models/user.dart';
import 'package:flutter/material.dart';

import '../../models/album_settings.dart';

// Holds album settings state until it is validated and passed to the current album view model and the API
// Notifies listener when needed
// Thumbnail has 2 values thumbnailSelection and thumbnailTempSelection in order to change display of chosen one in selection dialog
class AlbumSettingsViewModel extends ChangeNotifier {
  String? _id;
  String? title;
  List<User>? _users;
  String? _thumbnail;
  String? _thumbnailTemp;

  String? get id => _id;

  List<User>? get users => [..._users!];

  String? get thumbnail => _thumbnail;

  String? get thumbnailTemp => _thumbnailTemp;

  bool get isThumbnail => (_thumbnail != '' && _thumbnail != null);

  bool get isThumbnailTemp => (_thumbnailTemp != '' && _thumbnailTemp != null);

  // Takes an AlbumDetail object to init its values
  void initState(AlbumSettings albumSettings) {
    _id = albumSettings.albumId;
    title = albumSettings.title;
    _thumbnail = albumSettings.thumbnail;
    _users = List.from(albumSettings.users);
  }

  // Clears all the state
  // Called on exit
  void clear() {
    _thumbnailTemp = null;
    _thumbnail = null;
    _id = null;
    title = '';
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

  // Called whenever a user wants an album thumbnail to be removed
  void clearThumbnail() {
    _thumbnail = null;
  }

  // Called to update one particular user right
  // Makes a deep copy of original user in order for the change to be discarded if exit without saving
  void updateUserRights(int userIndex, List<String> newRights) {
    final User user = _users![userIndex];
    final User uptodateUser = User.clone(user);

    uptodateUser.updateRights(newRights);
    _users![userIndex] = uptodateUser;

    notifyListeners();
  }

  // Adds a user to the authorized user list with the minimum right
  void addNewUser(User user) {
    if (userExists(user))
      throw InvalidException('User has already access to this album');
    user.rights.add(RightFactory.createRight('content:read'));
    _users!.add(user);
    notifyListeners();
  }

  // Removes a user from the authorized user lists
  void removeUser(int userIndex) {
    final user = _users![userIndex];
    if (!userExists(user)) return;
    _users!.removeAt(userIndex);
    notifyListeners();
  }

  bool userExists(User user) {
    for (User u in _users!) {
      if (u.userId == user.userId) {
        return true;
      }
    }
    return false;
  }

  // Create AlbumSettings object with current value
  // To be passed to current album view model in order to update it and pass data to API
  AlbumSettings generateSetting() {
    return AlbumSettings(
        albumId: _id!,
        title: title!,
        users: _users!,
        thumbnail: _thumbnail ?? '');
  }
}
