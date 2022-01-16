import 'dart:async';
import 'dart:io';
import 'package:cloud_chest/helpers/storage_helper.dart';
import 'package:cloud_chest/utils/network.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cloud_chest/helpers/config_helper.dart';
import 'package:cloud_chest/helpers/token_helper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthProvider with ChangeNotifier {
  String? accessToken;
  String? _refreshToken;
  DateTime? _expiryDate;
  String? userId;

  // Fetch the auth data in the memory
  Future<void> fetchAuthData() async {
    try {
      print('fetching auth data');
      var authData = await SecureStorage().read('cloudchest_auth');

      accessToken = json.decode(authData!)['accessToken'];
      _refreshToken = json.decode(authData)['refreshToken'];
      _expiryDate = DateTime.parse(json.decode(authData)['expiry']);
      userId = json.decode(authData)['userId'];
    } catch (err, stack) {
      print('Problem fetching auth data');
      print(stack);
      print(err);
    }
  }

  // Check the expiry date validity
  bool isTokenValid() {
    if (_expiryDate!.isAfter(DateTime.now())) {
      _startTimer();
      return true;
    }
    return false;
  }

  // Returns true if token is valid and not expired
  bool isAuth() {
    if (accessToken != null && _refreshToken != null && _expiryDate != null) {
      return isTokenValid();
    }
    return false;
  }

  // Authenticates to the API, either by logging in or signing up
  Future<void> _authenticate(
      String email, String password, String urlPart) async {
    Uri url = NetworkUtils.createEndpoint('auth', urlPart);

    try {
      final response = await http.post(url, body: {
        'email': email,
        'password': password
      }).timeout(Duration(seconds: int.parse(dotenv.env['REQUEST_TIMEOUT']!)));

      if (response.statusCode != 200) {
        throw HttpException(response.body);
      }

      accessToken = json.decode(response.body)['accessToken'];
      _refreshToken = json.decode(response.body)['refreshToken'];

      final decodedAccessToken = TokenHelper.decodeToken(accessToken!);

      _expiryDate =
          DateTime.fromMillisecondsSinceEpoch(decodedAccessToken['exp']);
      userId = decodedAccessToken['sub'];

      await storeAuthData();
    } on TimeoutException catch (err) {
      print(err);
      return Future.error(HttpException(
          'An error occured while trying to connect to the server. Make sure it it up and running'));
    } on Exception catch (err) {
      print(err);
      return Future.error(HttpException(
          'An error occured while trying to authenticate to the server.'));
    }
  }

  Future<void> signup(String email, String password) async {
    return await _authenticate(email, password, 'register');
  }

  Future<void> login(String email, String password) async {
    return await _authenticate(email, password, 'login');
  }

  // Store the auth informations in the secure storage
  Future<void> storeAuthData() async {
    final authData = json.encode({
      'accessToken': accessToken,
      'refreshToken': _refreshToken,
      'expiry': _expiryDate!.toIso8601String(),
      'userId': userId
    });

    await SecureStorage().write('cloudchest_auth', authData);
  }

  // Clears all connection data in order to logout
  Future<void> logout() async {
    try {
      await SecureStorage().clear();
    } catch (err) {
      print('Logout error');
    }
  }

  // Request a new access token using the refresh token
  Future<void> refreshToken() async {
    print('Requesting new access token');
    Uri url = NetworkUtils.createEndpoint('auth', 'refreshToken');

    try {
      final response = await http.post(url, body: {
        'accessToken': accessToken,
        'refreshToken': _refreshToken,
      }).timeout(Duration(seconds: int.parse(dotenv.env['REQUEST_TIMEOUT']!)));

      if (response.statusCode != 200) {
        if (response.statusCode == 400) {
          await logout();
          notifyListeners();
        }
        return Future.error(HttpException(response.body));
      }

      accessToken = json.decode(response.body)['accessToken'];

      final decodedAccessToken = TokenHelper.decodeToken(accessToken!);

      _expiryDate =
          DateTime.fromMillisecondsSinceEpoch(decodedAccessToken['exp']);

      await storeAuthData();
      _startTimer();
    } on TimeoutException catch (err) {
      print(err);
      return Future.error(HttpException(
          'An error occured while trying to connect to the server. Make sure it it up and running'));
    } on Exception catch (err) {
      print(err);
      return Future.error(
          HttpException('An error occured while trying to authenticate.'));
    }
  }

  // Timer that will ask for a new access token once the current one is expired
  void _startTimer() {
    final _timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    final Timer _refreshTimer =
        new Timer(Duration(seconds: _timeToExpiry), refreshToken);
    print(
        'Starting timer with time to expiration ->' + _timeToExpiry.toString());
  }
}
