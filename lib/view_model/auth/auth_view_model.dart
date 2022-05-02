import 'dart:async';
import 'package:cloud_chest/exceptions/cloud_chest_exceptions.dart';
import 'package:cloud_chest/repositories/auth_repository.dart';
import 'package:cloud_chest/view_model/vm_controller.dart';
import 'package:flutter/material.dart';
import '../../exceptions/auth_exceptions.dart';

// Holds the auth state
// Only keeps most essential variable to provider (access token and user ID)
// All the auth data logic is handled by _authRepo
class Auth extends ChangeNotifier {
  static final Auth _instance = Auth._internal();

  factory Auth() {
    return _instance;
  }

  Auth._internal();

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
      await _authRepo.retrieveAuthData();

      if (!_authRepo.isAuthData) {
        return false;
      }

      _userId = _authRepo.userId!;

      if (!_authRepo.isAuthDataValid) {
        return false;
      }

      if (_authRepo.isTokenExpired) return _refreshToken();

      // Autoconnect successfull
      accessToken = _authRepo.accessToken;

      VmController.init(accessToken!, userId);

      _startTimer();
      return _isConnected = true;
    } on TimeoutException catch (e) {
      return Future.error('No internet connection or server offline');
    } catch (err, stack) {
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

      print('Authentication successfull with ' + accessToken!);

      _userId = _authRepo.userId!;

      VmController.init(accessToken!, userId);

      _isConnected = true;
      _startTimer();
    } on FetchException {
      return Future.error(
        AuthConnectionError('Server not responding'),
      );
    } catch (err, stack) {
      return Future.error(err);
    }
  }

  Future<void> login(String email, String password) async {
    return await _authenticate(email, password, 'login');
  }

  Future<void> register(String email, String password) async {
    return await _authenticate(email, password, 'register');
  }

  Future<void> logout() async {
    await _authRepo.clearAuthData();
    accessToken = '';
    VmController.reset();
  }

  // Sends a new access token request to the API
  Future<bool> _refreshToken() async {
    try {
      final newToken = await _authRepo.requestNewToken();

      accessToken = newToken;

      VmController.refreshToken(accessToken!);

      _startTimer();
      notifyListeners();

      return _isConnected = true;
    } catch (err) {
      print('Error while requesting new token, _isConnected now set to false');

      print('Now logging out for security reason.');
      logout();
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
