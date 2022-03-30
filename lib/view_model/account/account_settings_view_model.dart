import 'package:cloud_chest/data/api_response.dart';
import 'package:cloud_chest/models/user.dart';
import 'package:flutter/material.dart';

import '../../repositories/user_repository.dart';

class AccountSettingsViewModel extends ChangeNotifier {
  Map<String, String> _userDetails = {'id': '', 'email': '', 'username': ''};
  String? _newPassword;
  UserRepository _userRepo = UserRepository();
  ApiResponse _response = ApiResponse.loadingFull();
  String _accessToken = '';

  Map<String, String> get userDetails => _userDetails;

  ApiResponse get response => _response;

  String? get newPassord => _newPassword;

  bool hasDetails() => !(_userDetails['email'] == '');

  void setToken(String token) {
    _accessToken = token;
  }

  void _setResponse(ApiResponse response) {
    _response = response;
    notifyListeners();
  }

  void setUserDetail(String key, String value) {
    _userDetails[key] = value;
  }

  Future<void> fetchUserDetails() async {
    _setResponse(ApiResponse.loadingFull());

    await _userRepo.findUserById(_accessToken, _userDetails['id']!).then(
      (response) {
        _userDetails['email'] = response['email'];
        _userDetails['username'] = response['username'];
        _setResponse(ApiResponse.done());
      },
    ).catchError(
      (err) {
        _setResponse(
          ApiResponse.error(err.toString()),
        );
      },
    );
  }

  Future<void> updateUserDetails(Map<String, String> newDetails) async {
    _setResponse(ApiResponse.loadingPartial());
    await _userRepo
        .updateUser(_accessToken, _userDetails['id']!, newDetails)
        .then(
      (value) {
        _userDetails['email'] = newDetails['email']!;
        _userDetails['username'] = newDetails['username']!;
      },
    ).whenComplete(
      () => _setResponse(
        ApiResponse.done(),
      ),
    );
  }
}
