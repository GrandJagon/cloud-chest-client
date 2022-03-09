import 'dart:convert';
import 'dart:async';
import 'dart:io';
import '../exceptions/cloud_chest_exceptions.dart';
import 'package:cloud_chest/utils/network.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// Handles all API call to return JSON formatted responsed or error
class NetworkService {
  // Url parts reserved for the given API
  final String apiUrl;

  NetworkService({required this.apiUrl});

  // Handles get requests
  Future<dynamic> get(
      {String? urlPart,
      Map<String, String>? headers,
      Map<String, String>? params}) async {
    Uri url = NetworkUtils.createEndpoint(apiUrl, urlPart ?? '', params);

    try {
      final dynamic response = await http.get(url, headers: headers).timeout(
            Duration(
              seconds: int.parse(
                dotenv.env['REQUEST_TIMEOUT']!,
              ),
            ),
          );
      return _parseResponse(response);
    } on SocketException {
      throw FetchException('No internet connection');
    } on TimeoutException {
      throw FetchException('Make sure the server is running.');
    }
  }

  // Handles post requests
  Future<dynamic> post(
      {required Map<String, dynamic> data,
      String? urlPart,
      Map<String, String>? headers,
      Map<String, String>? params}) async {
    Uri url = NetworkUtils.createEndpoint(apiUrl, urlPart ?? '', params);

    try {
      final dynamic response =
          await http.post(url, headers: headers, body: data).timeout(
                Duration(
                  seconds: int.parse(
                    dotenv.env['REQUEST_TIMEOUT']!,
                  ),
                ),
              );
      return _parseResponse(response);
    } on SocketException {
      throw FetchException('No internet connection');
    } on TimeoutException {
      throw FetchException('Make sure the server is running.');
    }
  }

  //Handles multi-part requests
  Future<dynamic> multipart(
      {required List<String> data,
      required String method,
      String? urlPart,
      Map<String, String>? headers,
      Map<String, String>? params}) async {
    Uri url = NetworkUtils.createEndpoint(apiUrl, urlPart ?? '', params);
    try {
      final request = new http.MultipartRequest(method, url);

      if (headers != null) request.headers.addAll(headers);

      // Adds each part of data
      data.forEach((path) async {
        request.files.add(
          await http.MultipartFile.fromPath('file', path),
        );
      });

      final streamedResponse = await request.send().timeout(
            Duration(
              seconds: int.parse(
                dotenv.env['REQUEST_TIMEOUT']!,
              ),
            ),
          );
      final response = await http.Response.fromStream(streamedResponse);

      print(response);

      return _parseResponse(response);
    } on SocketException {
      throw FetchException('No internet connection');
    } on TimeoutException {
      throw FetchException(
          'There seems to be a conection problem, make sure the server is on.');
    }
  }

  Future<dynamic> patch({
    String? urlPart,
    Map<String, String>? headers,
    Map<String, String>? params,
    Map<String, String>? data,
  }) async {
    Uri url = NetworkUtils.createEndpoint(apiUrl, urlPart ?? '', params);

    try {
      final dynamic response =
          await http.patch(url, headers: headers, body: data).timeout(
                Duration(
                  seconds: int.parse(
                    dotenv.env['REQUEST_TIMEOUT']!,
                  ),
                ),
              );
      return _parseResponse(response);
    } on SocketException {
      throw FetchException('No internet connection');
    } on TimeoutException {
      throw FetchException('Make sure the server is running.');
    }
  }

  // Handles delete requests
  Future<dynamic> delete(
      {String? urlPart,
      Map<String, String>? headers,
      Map<String, String>? params,
      dynamic body}) async {
    Uri url = NetworkUtils.createEndpoint(apiUrl, urlPart ?? '', params);

    print('body to be sent ===> ' + body.toString());

    try {
      final dynamic response =
          await http.delete(url, headers: headers, body: body).timeout(
                Duration(
                  seconds: int.parse(
                    dotenv.env['REQUEST_TIMEOUT']!,
                  ),
                ),
              );
      return _parseResponse(response);
    } on SocketException {
      throw FetchException('No internet connection');
    } on TimeoutException {
      throw FetchException(
          'There seems to be a conection problem, make sure the server is on.');
    }
  }

  // Parses responses and returns it as JSON
  // Throws error according to status code if necessary
  dynamic _parseResponse(http.Response response) {
    print(('STATUS ' + response.statusCode.toString() + response.body));
    switch (response.statusCode) {
      case 200:
        // Checks json validity and returns raw body if invalid
        try {
          final jsonResponse = jsonDecode(response.body);
          return jsonResponse;
        } catch (e) {
          return response.body;
        }
      case 400:
        return InvalidException(response.body.toString());
      case 401:
      case 403:
        return UnauthorizedException(response.body.toString());
      case 404:
        return null;
      case 500:
        return ServerException(response.body.toString());
      default:
        return ServerException(response.body.toString());
    }
  }
}
