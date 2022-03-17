import 'dart:convert';
import 'dart:io';
import 'package:cloud_chest/data/network_service.dart';
import 'package:cloud_chest/models/album_settings.dart';
import 'package:cloud_chest/models/content/content.dart';
import 'package:cloud_chest/models/factories/content_factory.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Allows fetching data concerning a single album such as content and settings as well as editing it
class SingleAlbumRepository {
  final NetworkService _singleAlbumService =
      NetworkService(apiUrl: 'singleAlbum');
  final String _authTokenKey = dotenv.env['REQUEST_AUTH_TOKEN_KEY']!;
  final String _albumIdKey = dotenv.env['REQUEST_ALBUM_KEY']!;

  // Fetches a single album from the API and splits it between content and detail
  Future<Map<dynamic, dynamic>> getSingleAlbum(
      String albumId, String accessToken) async {
    try {
      final headers = {_authTokenKey: accessToken};
      final params = {_albumIdKey: albumId};
      final response =
          await _singleAlbumService.get(headers: headers, params: params);

      if (response is Exception) throw response;

      List<Content> albumContent = (response['files'] as List<dynamic>)
          .map((json) => ContentFactory.createFromJson(json))
          .toList();

      AlbumSettings albumSettings = AlbumSettings.fromJson(response);

      return {'content': albumContent, 'settings': albumSettings};
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

  // Updates an album details
  Future<void> updateAlbumDetails(
      String accessToken, String albumId, AlbumSettings newSettings) async {
    try {
      final Map<String, String> data = newSettings.toJson();

      final response = await _singleAlbumService.patch(
        headers: {_authTokenKey: accessToken},
        params: {'albumId': albumId},
        data: data,
      );

      if (response is Exception) throw response;

      print(response.toString());
    } catch (err) {
      return Future.error(err);
    }
  }
}
