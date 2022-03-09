import 'dart:convert';
import 'package:cloud_chest/data/network_service.dart';
import 'package:cloud_chest/exceptions/cloud_chest_exceptions.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Allows to fetch data concerning user and edit it
class UserRepository {
  final NetworkService _userService = NetworkService(apiUrl: 'users');
  final String _authTokenKey = dotenv.env['REQUEST_AUTH_TOKEN_KEY']!;
  final String _albumIdKey = dotenv.env['REQUEST_ALBUM_KEY']!;

  // Fetches a user either from username or email
  Future<dynamic> getUser(
    String? data,
    String accessToken,
  ) async {
    try {
      if (data == null)
        throw FetchException('Username or email need to be provided');

      final headers = {_authTokenKey: accessToken};

      final params = {'search': data};

      final response = await _userService.get(headers: headers, params: params);

      print(response);

      if (response is Exception) throw response;

      return response;
    } catch (err, stack) {
      print(stack);
      return Future.error(err);
    }
  }
}
