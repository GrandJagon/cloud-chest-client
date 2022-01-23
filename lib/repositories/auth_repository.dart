import 'package:cloud_chest/data/network_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthRepository {
  NetworkService _authService = NetworkService(apiUrl: 'auth');
  final String _accessTokenKey = dotenv.env['REQUEST_ACCESS_TOKEN_KEY']!;
  final String _refreshTokenKey = dotenv.env['REQUEST_REFRESH_TOKEN_KEY']!;

  // Sends login/register data to the API
  Future<Map<String, String>> authenticate(
      String email, String password) async {
    try {
      final response =
          await _authService.post(data: {'email': email, 'password': password});

      return response;
    } catch (err) {
      throw err;
    }
  }

  // Requests new access token from the API
  Future<Map<String, String>> requestNewToken(
      String accessToken, String refreshToken) async {
    try {
      final response = await _authService.post(
          data: {_accessTokenKey: accessToken, _refreshTokenKey: refreshToken});

      final data = response as Map<String, String>;

      return data;
    } catch (err) {
      throw err;
    }
  }
}
