import 'package:cloud_chest/data/api_response.dart';
import 'package:flutter/material.dart';
import '../../repositories/user_repository.dart';

class AccountSettingsViewModel extends ChangeNotifier {
  static final AccountSettingsViewModel _instance =
      AccountSettingsViewModel._internal();

  factory AccountSettingsViewModel() {
    return _instance;
  }

  AccountSettingsViewModel._internal();

  Map<String, String> _userDetails = {'id': '', 'email': '', 'username': ''};
  String? newPassword;
  bool isNewPassword = false;
  UserRepository _userRepo = UserRepository();
  ApiResponse _response = ApiResponse.loadingFull();
  String _accessToken = '';
  bool _fetched = false;

  Map<String, String> get userDetails => _userDetails;

  ApiResponse get response => _response;

  bool get fetched => _fetched;

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

  void setNewPassword(String newValue) {
    newPassword = newValue;
    isNewPassword = true;
    notifyListeners();
  }

  Future<void> fetchUserDetails() async {
    clear();
    _setResponse(ApiResponse.loadingFull());

    await _userRepo.findUserById(_accessToken, _userDetails['id']!).then(
      (response) {
        _userDetails['email'] = response['email'];
        _userDetails['username'] = response['username'] ?? '';
        _fetched = true;
        _setResponse(ApiResponse.done());
      },
    ).catchError(
      (err, stack) {
        print(stack);
        print(err);
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
        clear();
      },
    ).whenComplete(
      () => _setResponse(
        ApiResponse.done(),
      ),
    );
  }

  Future<void> resetPassword(String email) async {
    _setResponse(ApiResponse.loadingPartial());
    await _userRepo.resetPassword(
      _accessToken,
      {'email': email},
    ).whenComplete(
      () => _setResponse(
        ApiResponse.done(),
      ),
    );
  }

  Future<void> deleteAccount() async {
    _setResponse(ApiResponse.loadingFull());
    await _userRepo
        .deleteAccount(
          _accessToken,
          _userDetails['id']!,
        )
        .whenComplete(
          () => _setResponse(
            ApiResponse.done(),
          ),
        );
  }

  // Clear temp data when leaving screen
  void clear() {
    newPassword = null;
    isNewPassword = false;
  }

  // Wipes all data
  void reset() {
    clear();
    _accessToken = '';
    _userDetails = {'id': '', 'email': '', 'username': ''};
  }
}
