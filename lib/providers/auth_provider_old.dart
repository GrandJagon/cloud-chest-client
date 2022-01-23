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
  Timer? _authTimer;

  // Tries to autoconnect to the API
  Future<dynamic> tryAutoConnect() async {
    print('Trying to autoconnect');
    try {
      await fetchAuthData();

      if (!isAuth) return false;

      print('auth data OK');

      if (!isTokenValid) return false;

      _startTimer();

      return true;
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
  bool get isTokenValid {
    if (_expiryDate!.isAfter(DateTime.now())) {
      return true;
    }
    return false;
  }

  // Returns true if token is valid and not expired
  bool get isAuth {
    if (accessToken != null && _refreshToken != null && _expiryDate != null) {
      return true;
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
    } on SocketException catch (err) {
      print(err);
      return Future.error(
          'An error occured while trying to connect to the server. Make sure it it up and running');
    } catch (err) {
      return Future.error('Error while connecting, please try again later.');
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
    print('LOGING OUT');
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
      }

      accessToken = json.decode(response.body)['accessToken'];

      final decodedAccessToken = TokenHelper.decodeToken(accessToken!);

      _expiryDate =
          DateTime.fromMillisecondsSinceEpoch(decodedAccessToken['exp']);

      await storeAuthData();
      _startTimer();
    } on Exception catch (err) {
      print(
          'problem while refreshing token, now logging out ion order to request a new token pair');
      await logout();
    }
  }

  // Timer that will ask for a new access token once the current one is expired
  void _startTimer() {
    final _timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    if (_authTimer != null)
      print('Timer already set with ' +
          _timeToExpiry.toString() +
          ' seconds to go');
    _authTimer = new Timer(Duration(seconds: _timeToExpiry), () {
      refreshToken();
    });
  }
}
