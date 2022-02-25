import 'dart:convert';
import 'dart:io';
import 'package:cloud_chest/data/network_service.dart';
import 'package:cloud_chest/models/album_detail.dart';
import 'package:cloud_chest/models/content.dart';
import 'package:cloud_chest/models/factories/content_factory.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SingleAlbumRepository {
  final NetworkService _singleAlbumService =
      NetworkService(apiUrl: 'singleAlbum');
  final String _authTokenKey = dotenv.env['REQUEST_AUTH_TOKEN_KEY']!;
  final String _albumIdKey = dotenv.env['REQUEST_ALBUM_KEY']!;

  // Retrieves content for an album given an album id
  Future<List<Content>> getAlbumContent(
      String albumId, String accessToken) async {
    try {
      final headers = {_authTokenKey: accessToken};
      final params = {_albumIdKey: albumId};
      final response = await _singleAlbumService.get(
          headers: headers, params: params) as List;

      if (response is Exception) throw response;

      List<Content> albumContent =
          response.map((json) => ContentFactory.createFromJson(json)).toList();

      return albumContent;
    } catch (err, stack) {
      print(stack);
      return Future.error(err);
    }
  }

  // Fetches a single album from the API and splits it between content and detail
  Future<Map<dynamic, dynamic>> getSingleAlbum(
      String albumId, String accessToken) async {
    try {
      final headers = {_authTokenKey: accessToken};
      final params = {_albumIdKey: albumId};
      final response =
          await _singleAlbumService.get(headers: headers, params: params);

      if (response is Exception) throw response;

      List<dynamic> albumContent = response['files']
          .map((json) => ContentFactory.createFromJson(json))
          .toList();

      AlbumDetail albumDetail = AlbumDetail.fromJson(response);

      return {'content': albumContent, 'detail': albumDetail};
    } catch (err, stack) {
      print(stack);
      return Future.error(err);
    }
  }

  // Upload new content to an album via multipart post request
  Future<List<Content>> postNewContent(
      List<String> newContent, String albumId, String accessToken) async {
    try {
      final headers = {_authTokenKey: accessToken};
      final params = {_albumIdKey: albumId};
      final response = await _singleAlbumService.multipart(
          headers: headers, data: newContent, method: 'POST', params: params);

      if (response is Exception) throw response;

      List<Content> addedContent = response
          .map<Content>((json) => ContentFactory.createFromJson(json))
          .toList();

      return addedContent;
    } catch (err, stack) {
      print(err);
      print(stack);
      rethrow;
    }
  }

  // Deletes given content from an album
  Future<bool> deleteContent(
      List<Content> contentToDelete, String albumId, String accessToken) async {
    try {
      final headers = {
        _authTokenKey: accessToken,
        HttpHeaders.contentTypeHeader: 'application/json'
      };
      final params = {_albumIdKey: albumId};

      var jsonContent =
          contentToDelete.map((e) => e.toJsonForDeletion()).toList();

      final body = json.encode(jsonContent);

      final response = await _singleAlbumService.delete(
          headers: headers, body: body, params: params);

      if (response is Exception) throw response;

      return true;
    } catch (err, stack) {
      print(stack);
      print(err);
      rethrow;
    }
  }

  // Returns the details for a given album
  Future<Map<String, dynamic>> getAlbumDetails(
      String accessToken, String albumId) async {
    try {
      final response = await _singleAlbumService.get(
          headers: {_authTokenKey: accessToken},
          params: {'albumId': albumId},
          urlPart: 'details');

      if (response is Exception) throw response;

      return response;
    } catch (err) {
      return Future.error(err);
    }
  }
}
