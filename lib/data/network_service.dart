import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'cloud_chest_exceptions.dart';
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

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _parseResponse(response);
    } on SocketException {
      throw FetchException('No internet connection');
    }
  }

  Future<dynamic> patch(String url, Map<String, dynamic> data) {
    throw new UnsupportedError('This service dos not support patch request');
  }

  // Handles delete requests
  Future<dynamic> delete(
      {String? urlPart,
      Map<String, String>? headers,
      Map<String, String>? params}) async {
    Uri url = NetworkUtils.createEndpoint(apiUrl, urlPart ?? '', params);

    try {
      final dynamic response = await http.post(url, headers: headers).timeout(
            Duration(
              seconds: int.parse(
                dotenv.env['REQUEST_TIMEOUT']!,
              ),
            ),
          );
      return _parseResponse(response);
    } on SocketException {
      throw FetchException('No internet connection');
    }
  }

  // Parses responses and returns it as JSON
  // Throws error according to status code if necessary
  dynamic _parseResponse(http.Response response) {
    print('PARSING RESPONSE ');
    print('STATUS ' + response.statusCode.toString());
    print(response.body);
    switch (response.statusCode) {
      case 200:
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse;
      case 400:
        return InvalidException(response.body.toString());
      case 401:
      case 403:
        return UnauthorizedException(response.body.toString());
      case 500:
        return ServerException(response.body.toString());
      default:
        return ServerException(response.body.toString());
    }
  }
}
