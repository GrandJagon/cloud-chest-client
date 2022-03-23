import 'dart:async';
import 'package:cloud_chest/exceptions/cloud_chest_exceptions.dart';
import 'package:cloud_chest/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import '../exceptions/auth_exceptions.dart';

// Holds the auth state
// Only keeps most essential variable to provider (access token and user ID)
// All the auth data logic is handled by _authRepo
class Auth extends ChangeNotifier {
  final _authRepo = AuthRepository();
  bool _isConnected = false;
  String? accessToken = '';
  Timer? _authTimer;
  String _userId = '';

  bool get isConnected => _isConnected;

  String get userId => _userId;

  // Tries to fetch auth data and run checks on them$
  // If expired refresh the token and fetch the new ones
  Future<bool> tryAutoConnect() async {
    try {
      _userId = await _authRepo.retrieveAuthData();

      if (!_authRepo.isAuthData) {
        print('no auth data, redirection to auth screen');
        return false;
      }
      if (!_authRepo.isAuthDataValid) {
        print('auth data invalid, redirection to auth screen');
        return false;
      }

      if (_authRepo.isTokenExpired) return _refreshToken();

      // Autoconnect successfull
      accessToken = _authRepo.accessToken;

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
      final response = await _authRepo.authenticate(email, password, urlPart);

      // Authentication successful
      accessToken = response;

      _isConnected = true;
      _startTimer();
    } on FetchException {
      return Future.error(
          AuthConnectionError('There no internet or the server is off.'));
    } catch (err, stack) {
      print(stack);
      print(err);
      return Future.error('There seems to be a problem, please retry later...');
    }
  }

  Future<void> login(String email, String password) async {
    return await _authenticate(email, password, 'login');
  }

  Future<void> register(String email, String password) async {
    return await _authenticate(email, password, 'register');
  }

  Future<void> _logout() async {
    await _authRepo.clearAuthData();
    accessToken = '';
  }

  // Sends a new access token request to the API
  Future<bool> _refreshToken() async {
    try {
      final newToken = await _authRepo.requestNewToken();

      accessToken = newToken;

      _startTimer();
      notifyListeners();

      return _isConnected = true;
    } catch (err) {
      print('Error while requesting new token, _isConnected now set to false');

      print('Now logging out for security reason.');
      _logout();
      return _isConnected = false;
    }
  }

  // Timer that will ask for a new access token once the current one is expired
  void _startTimer() {
    final _timeToExpiry =
        _authRepo.expiryDate!.difference(DateTime.now()).inSeconds;
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
