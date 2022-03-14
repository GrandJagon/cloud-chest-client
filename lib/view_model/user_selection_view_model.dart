import 'package:cloud_chest/data/api_response.dart';
import 'package:cloud_chest/models/user.dart';
import 'package:flutter/material.dart';

import '../repositories/user_repository.dart';

class UserSelectionViewModel extends ChangeNotifier {
  User? _user;
  List<User> _searchUserResult = [];
  UserRepository _userRepo = UserRepository();
  ApiResponse _response = ApiResponse.done();
  String _accessToken = '';

  User get user => _user!;

  bool get hasSelection => _user != null;

  ApiResponse get response => _response;

  List<User>? get searchUserResult => [..._searchUserResult];

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

  set user(User user) {
    if (user == _user)
      _user = null;
    else
      _user = user;

    notifyListeners();
  }

  void clear() {
    _searchUserResult.clear();
    _user = null;
    resetResponse();
  }

  // Fetches a user from email or username if exist
  Future<void> findUser(String? data) async {
    _searchUserResult.clear();

    _setResponse(ApiResponse.loading());
    await _userRepo.getUser(data, _accessToken).then(
      (json) {
        if (json == null) {
          _setResponse(ApiResponse.noResult('No result'));
          return;
        }
        print(json);
        _searchUserResult.addAll(User.fromArray(json).toList());
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
