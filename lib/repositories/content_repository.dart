import 'dart:convert';
import 'dart:io';

import 'package:cloud_chest/data/network_service.dart';
import 'package:cloud_chest/models/content.dart';
import 'package:cloud_chest/models/factories/content_factory.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ContentRepository {
  final NetworkService _contentService = NetworkService(apiUrl: 'content');
  final String _auth_token_key = dotenv.env['REQUEST_AUTH_TOKEN_KEY']!;
  final String _album_id_key = dotenv.env['REQUEST_ALBUM_KEY']!;

  // Retrieves content for an album given an album id
  Future<List<Content>> getAlbumContent(
      String albumId, String accessToken) async {
    try {
      final headers = {_auth_token_key: accessToken};
      final params = {_album_id_key: albumId};
      final response =
          await _contentService.get(headers: headers, params: params) as List;

      if (response is Exception) throw response;

      List<Content> albumContent =
          response.map((json) => ContentFactory.createFromJson(json)).toList();

      return albumContent;
    } catch (err, stack) {
      print(stack);
      return Future.error(err);
    }
  }

  // Upload new content to an album via multipart post request
  Future<List<Content>> postNewContent(
      List<String> newContent, String albumId, String accessToken) async {
    try {
      final headers = {_auth_token_key: accessToken};
      final params = {_album_id_key: albumId};
      final response = await _contentService.multipart(
          headers: headers, data: newContent, method: 'POST', params: params);

      if (response is Exception) throw response;

      List<Content> addedContent = response
          .map<Content>((json) => ContentFactory.createFromJson(json))
          .toList();

      return addedContent;
    } catch (err, stack) {
      print(err);
      print(stack);
      throw err;
    }
  }

  // Deletes given content from an album
  Future<bool> deleteContent(
      List<Content> contentToDelete, String albumId, String accessToken) async {
    try {
      final headers = {
        _auth_token_key: accessToken,
        HttpHeaders.contentTypeHeader: 'application/json'
      };
      final params = {_album_id_key: albumId};

      var jsonContent =
          contentToDelete.map((e) => e.toJsonForDeletion()).toList();

      final body = json.encode(jsonContent);

      final response = await _contentService.delete(
          headers: headers, body: body, params: params);

      if (response is Exception) throw response;

      return true;
    } catch (err, stack) {
      print(stack);
      print(err);
      throw err;
    }
  }
}
