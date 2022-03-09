import 'package:cloud_chest/data/api_response.dart';
import 'package:cloud_chest/models/user.dart';
import 'package:cloud_chest/repositories/user_repository.dart';
import 'package:flutter/material.dart';

import '../models/album_settings.dart';

// Holds album settings state until it is validated and passed to the current album view model and the API
// Notifies listener when needed
// Thumbnail has 2 values thumbnailSelection and thumbnailTempSelection in order to change display of chosen one in selection dialog
class AlbumSettingsViewModel extends ChangeNotifier {
  UserRepository _userRepo = UserRepository();
  ApiResponse _response = ApiResponse.done();
  String _accessToken = '';
  String? _id;
  String? title;
  List<User>? _users;
  List<dynamic>? _searchUserResult;
  String? _thumbnail;
  String? _thumbnailTemp;

  ApiResponse get response => _response;

  String? get id => _id;

  List<User>? get users => [..._users!];

  List<User>? get searchUserResult => [..._searchUserResult!];

  String? get thumbnail => _thumbnail;

  String? get thumbnailTemp => _thumbnailTemp;

  bool get isThumbnail => (_thumbnail != '' && _thumbnail != null);

  bool get isThumbnailTemp => (_thumbnailTemp != '' && _thumbnailTemp != null);

  void setToken(String token) {
    _accessToken = token;
  }

  void _setResponse(ApiResponse response) {
    _response = response;
    notifyListeners();
  }

  // Reset the response
  // usually used on exit to create a clean state if come back to view
  void resetResponse() {
    _response = ApiResponse.done();
  }

  // Takes an AlbumDetail object to init its values
  void initState(AlbumSettings albumSettings) {
    _id = albumSettings.albumId;
    title = albumSettings.title;
    _thumbnail = albumSettings.thumbnail;
    _users = List.from(albumSettings.users);
    _searchUserResult = [];
  }

  // Clears all the state
  // Called on exit
  void clear() {
    _thumbnailTemp = null;
    _thumbnail = null;
    _id = null;
    title = null;
    _users = null;
    _searchUserResult = null;
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

  // Called to update one particular user right
  // Makes a deep copy of original user in order for the change to be discarded if exit without saving
  void updateUserRights(int userIndex, List<String> newRights) {
    final User user = _users![userIndex];
    final User uptodateUser = User.clone(user);

    uptodateUser.updateRights(newRights);
    _users![userIndex] = uptodateUser;

    notifyListeners();
  }

  // Fetches a user from email or username if exist
  Future<void> findUser(String? data) async {
    _searchUserResult!.clear();

    _setResponse(ApiResponse.loading());
    await _userRepo.getUser(data, _accessToken).then(
      (json) {
        if (json == null) {
          _setResponse(ApiResponse.noResult('User does not exist'));
          return;
        }
        _searchUserResult!.add(User.fromJson(json));
        _setResponse(ApiResponse.done());
      },
    ).onError(
      (error, stackTrace) {
        _setResponse(ApiResponse.error(error.toString()));
        print('ERROR WHILE FINDING USER');
        print(stackTrace);
      },
    );
  }
}
