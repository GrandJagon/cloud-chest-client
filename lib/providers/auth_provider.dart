import 'dart:async';
import 'package:cloud_chest/data/cloud_chest_exceptions.dart';
import 'package:cloud_chest/services/auth_data_service.dart';
import 'package:flutter/material.dart';
import 'auth_errors.dart';

// Holds the auth state
// Only keeps most essential variable to provider (access token and user ID)
// All the auth data logic is handled by _authDataService
class Auth extends ChangeNotifier {
  final _authDataService = AuthDataService();
  bool _isConnected = false;
  String? accessToken = '';
  String? userId = '';
  Timer? _authTimer;

  bool get isConnected => _isConnected;

  Auth() {
    print('creating auth');
  }

  // Tries to fetch auth data and run checks on them$
  // If expired refresh the token and fetch the new ones
  Future<bool> tryAutoConnect() async {
    try {
      await _authDataService.retrieveAuthData();

      if (!_authDataService.isAuthData)
        return Future.error(
          NoAuthDataError('There is no auth data in local memory'),
        );

      if (!_authDataService.isAuthDataValid)
        return Future.error(
          AuthDataNonValidError('The auth data is invalid, please login.'),
        );

      if (_authDataService.isTokenExpired)
        await _authDataService.requestNewToken();

      // Autoconnect successfull
      accessToken = _authDataService.accessToken;
      userId = _authDataService.userId;
      _startTimer();
      return _isConnected = true;
    } on TimeoutException {
      return Future.error('No internet connection or server offline');
    } catch (err, stack) {
      print(stack);
      return Future.error(err);
    }
  }

  // Sends an authentication request to the API
  Future<void> _authenticate(
      String email, String password, String urlPart) async {
    try {
      final response =
          await _authDataService.authenticate(email, password, urlPart);

      // Authentication successful
      accessToken = response['accessToken'];
      userId = response['userId'];
      _isConnected = true;
      _startTimer();
    } on FetchException catch (err) {
      return Future.error(
          AuthConnectionError('There no internet or the server is off.'));
    } catch (err) {
      return Future.error('There seems to be a problem, please retry later...');
    }
  }

  Future<void> login(String email, String password) async {
    return await _authenticate(email, password, 'login');
  }

  Future<void> register(String email, String password) async {
    return await _authenticate(email, password, 'register');
  }

  // Sends a new access token request to the API
  Future<void> _refreshToken() async {
    try {
      final newToken = await _authDataService.requestNewToken();

      accessToken = newToken;
      _isConnected = true;
      _startTimer();
      notifyListeners();
    } catch (err) {
      print('Error while requesting new token, _isConnected now set to false');
      _isConnected = false;
    }
  }

  // Timer that will ask for a new access token once the current one is expired
  void _startTimer() {
    final _timeToExpiry =
        _authDataService.expiryDate!.difference(DateTime.now()).inSeconds;
    if (_authTimer != null)
      print('Timer already set with ' +
          _timeToExpiry.toString() +
          ' seconds to go');
    _authTimer = new Timer(
      Duration(seconds: _timeToExpiry),
      () {
        _refreshToken();
      },
    );
  }
}
