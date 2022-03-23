import 'dart:convert';
import 'package:cloud_chest/data/network_service.dart';
import 'package:cloud_chest/exceptions/cloud_chest_exceptions.dart';
import 'package:cloud_chest/models/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Allows to fetch data concerning user and edit it
class UserRepository {
  final NetworkService _userService = NetworkService(apiUrl: 'users');
  final String _authTokenKey = dotenv.env['REQUEST_AUTH_TOKEN_KEY']!;

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

      if (response is Exception) throw response;

      return response;
    } on Exception catch (err, stack) {
      print(stack);
      return Future.error(err);
    }
  }

  // Updates an user with the new details provided in data
  Future<dynamic> updateUser(
      String accessToken, String id, Map<String, String> data) async {
    final headers = {_authTokenKey: accessToken};

    final params = data;

    final response = await _userService.patch(headers: headers, params: params);

    if (response.runtimeType == Exception) throw response;

    return response;
  }
}
