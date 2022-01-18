import 'dart:async';
import 'dart:io';
import 'package:cloud_chest/helpers/storage_helper.dart';
import 'package:cloud_chest/utils/network.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cloud_chest/helpers/token_helper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthData = false;
  String? accessToken;
  String? _refreshToken;
  DateTime? _expiryDate;
  String? userId;

  // Tries to autoconnect to the API
  Future<void> tryAutoConnect() async {
    try {
      await fetchAuthData();

      if (!isAuth()) await refreshToken();

      return;
    } on Exception catch (err) {
      return Future.error(err);
    } catch (err) {
      // In this case there is no credentials in memory so it is likely the first use so no need for catching error
      print(err);
    }
  }

  // Fetch the auth data in the memory
  Future<void> fetchAuthData() async {
    try {
      var authData = await SecureStorage().read('cloudchest_auth');

      if (authData == null)
        return Future.error('There seems to be no auth data in memory');

      accessToken = await json.decode(authData)['accessToken'];
      _refreshToken = await json.decode(authData)['refreshToken'];
      _expiryDate = DateTime.parse(await json.decode(authData)['expiry']);
      userId = await json.decode(authData)['userId'];
      _isAuthData = true;
    } on Exception catch (err, stack) {
      return Future.error('Error while fetching auht data');
    }
  }

  // Variable to track is there is auth data in memory in order to display the proper screen
  bool get isAuthData => _isAuthData;

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
    print('authenticating');
    Uri url = NetworkUtils.createEndpoint('auth', urlPart);

    try {
      final response = await http.post(url, body: {
        'email': email,
        'password': password
      }).timeout(Duration(seconds: int.parse(dotenv.env['REQUEST_TIMEOUT']!)));

      print(response.body);

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
      return Future.error(HttpException(err.toString()));
    } catch (e, stack) {
      print('AUTH ERROR CAUGHT');
      print(stack);
      print(e);
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
      'expiry': _expiryDate!.toString(),
      'userId': userId
    });

    await SecureStorage().write('cloudchest_auth', authData);
  }

  // Clears all connection data in order to logout
  Future<void> logout() async {
    try {
      await SecureStorage().clear('cloudchest_auth');
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
        print(response.body);
      }

      accessToken = json.decode(response.body)['accessToken'];

      final decodedAccessToken = TokenHelper.decodeToken(accessToken!);

      _expiryDate =
          DateTime.fromMillisecondsSinceEpoch(decodedAccessToken['exp']);

      await storeAuthData();
      _startTimer();
    } on Exception catch (err) {
      await logout();
      throw Exception('Cannot refresh access token');
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
