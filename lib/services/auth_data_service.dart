import 'dart:async';
import 'dart:convert';
import 'package:cloud_chest/data/network_service.dart';
import 'package:cloud_chest/helpers/storage_helper.dart';
import 'package:cloud_chest/helpers/token_helper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Handles all authentication data retrieval and logic
class AuthDataService {
  NetworkService _authService = NetworkService(apiUrl: 'auth');
  final String _accessTokenKey = dotenv.env['REQUEST_ACCESS_TOKEN_KEY']!;
  final String _refreshTokenKey = dotenv.env['REQUEST_REFRESH_TOKEN_KEY']!;
  final String _authDataKey = dotenv.env['SECURE_STORAGE_AUTH_KEY']!;
  String? _accessToken;
  String? _refreshToken;
  DateTime? _expiryDate;
  String? _userId;
  bool _isAuthData = false;

  bool get isAuthData => _isAuthData;

  String? get accessToken => _accessToken;

  String? get userId => _userId;

  DateTime? get expiryDate => _expiryDate;

  // Sends login/register data to the API
  Future<String> authenticate(
      String email, String password, String urlPart) async {
    try {
      final response = await _authService
          .post(data: {'email': email, 'password': password}, urlPart: urlPart);

      if (response is Exception) throw response;

      _accessToken = response['accessToken'];
      _refreshToken = response['refreshToken'];

      _extractTokenData(_accessToken!);
      _storeAuthData();

      return _accessToken!;
    } catch (err, stack) {
      print(stack);
      print(err);
      return Future.error(err);
    }
  }

  // Requests new access token from the API
  Future<String> requestNewToken() async {
    print('DataService requesting new token');
    try {
      final response = await _authService.post(data: {
        _accessTokenKey: _accessToken,
        _refreshTokenKey: _refreshToken
      }, urlPart: 'refreshToken');

      if (response is Exception) throw response;

      final data = response;

      _accessToken = data['accessToken'];

      _extractTokenData(_accessToken!);

      await _storeAuthData();

      return _accessToken!;
    } catch (err, stack) {
      return Future.error(err);
    }
  }

  // Decodes token and assigns its info to values
  void _extractTokenData(String encodedToken) {
    final decodedAccessToken = TokenHelper.decodeToken(accessToken!);

    _expiryDate =
        DateTime.fromMillisecondsSinceEpoch(decodedAccessToken['exp']);

    _userId = decodedAccessToken['sub'];
  }

  // Retrieves auth data stored in memory or null if none
  Future<dynamic> retrieveAuthData() async {
    var authData = await SecureStorage().read(_authDataKey);

    if (authData == null) return;

    _accessToken = await json.decode(authData)['accessToken'];
    _refreshToken = await json.decode(authData)['refreshToken'];
    _expiryDate = DateTime.parse(await json.decode(authData)['expiry']);
    _userId = await json.decode(authData)['userId'];

    _isAuthData = true;
  }

  // Store the auth informations in the secure storage
  Future<void> _storeAuthData() async {
    final authData = json.encode({
      'accessToken': _accessToken,
      'refreshToken': _refreshToken,
      'expiry': _expiryDate!.toString(),
      'userId': _userId
    });

    await SecureStorage().write(_authDataKey, authData);
  }

  Future<void> clearAuthData() async {
    await SecureStorage().clear(_authDataKey);
  }

  // Check the expiry date validity
  bool get isTokenExpired {
    if (_expiryDate!.isAfter(DateTime.now())) {
      return false;
    }
    return true;
  }

  // Checks if the auth data in memory is valid
  bool get isAuthDataValid {
    if (_accessToken != null && _refreshToken != null && _expiryDate != null) {
      return true;
    }
    return false;
  }
}
