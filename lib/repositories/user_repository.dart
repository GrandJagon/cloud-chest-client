import 'dart:convert';
import 'package:cloud_chest/data/network_service.dart';
import 'package:cloud_chest/exceptions/cloud_chest_exceptions.dart';
import 'package:cloud_chest/models/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Allows to fetch data concerning user and edit it
class UserRepository {
  final NetworkService _userService = NetworkService(apiUrl: 'users');
  final String _authTokenKey = dotenv.env['REQUEST_AUTH_TOKEN_KEY']!;

  // Singleton initialization$
  static final UserRepository _instance = UserRepository._internal();

  factory UserRepository() {
    return _instance;
  }

  UserRepository._internal();

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

      return response;
    } catch (err, stack) {
      print(stack);
      return Future.error(err);
    }
  }

  // fetches user details from an id
  Future<dynamic> findUserById(String accessToken, String id) async {
    try {
      final headers = {_authTokenKey: accessToken};

      final params = {'id': id};

      final response = await _userService.get(
          headers: headers, params: params, urlPart: 'byId');

      return {
        'email': response[0]['email'],
        'username': response[0]['username']
      };
    } on Exception catch (err, stack) {
      return Future.error(err);
    }
  }

  // Updates an user with the new details provided in data
  Future<dynamic> updateUser(
      String accessToken, String id, Map<String, String> data) async {
    try {
      final headers = {_authTokenKey: accessToken};

      final response = await _userService.patch(headers: headers, data: data);

      if (response is Exception) throw response;

      return response;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  Future<dynamic> resetPassword(
      String accessToken, Map<String, String> data) async {
    try {
      final headers = {_authTokenKey: accessToken};

      final response = await _userService.post(
          headers: headers, data: data, urlPart: 'resetPassword');

      if (response is Exception) throw response;

      return response;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }
}
