import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_chest/models/content.dart';
import 'package:cloud_chest/utils/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ContentProvider extends ChangeNotifier {
  final String accessToken;
  final String userId;
  late List<Content> _contentList = [];

  ContentProvider(this.accessToken, this.userId);

  List<Content> get contentList => [..._contentList];

  int getContentIndex(Content content) => _contentList.indexOf(content);

  // Adds content returned by the API to the current album content list
  Future<void> _addToCurrentContent(List<dynamic> newContent) async {
    newContent.forEach((content) {
      _contentList.add(
        new Content(
            path: NetworkUtils.createImagePath(content['path']),
            size: content['size'],
            mimetype: content['mimetype']),
      );
    });
  }

  // Fetch the content of an album from the server
  Future<void> fetchAlbumContent(String albumId) async {
    final url =
        NetworkUtils.createEndpoint('content', '', {'albumId': albumId});
    _contentList.clear();

    try {
      final response = await http.get(url, headers: {
        'auth-token': accessToken
      }).timeout(Duration(seconds: int.parse(dotenv.env['REQUEST_TIMEOUT']!)));

      if (response.statusCode != 200)
        Future.error(HttpException('Error while fetching album content'));

      final decodedResponse = json.decode(response.body);

      final content = decodedResponse['content'] as List;

      if (content.length <= 0) return;

      await _addToCurrentContent(content);

      notifyListeners();
    } on TimeoutException catch (err) {
      print(err);
      return Future.error(HttpException(
          'Server not responding, make sure it is up and running'));
    } on Exception catch (err) {
      print(err);
      return Future.error(HttpException('Error while fetching album content'));
    }
  }

  // Uploads one or several files as bytes
  Future<void> uploadContent(List<String> data, String albumId) async {
    final url =
        NetworkUtils.createEndpoint('content', '', {'albumId': albumId});

    try {
      final request = new http.MultipartRequest("POST", url);
      request.headers.addAll({'auth-token': accessToken});
      data.forEach((file) async {
        print(file.toString());
        request.files.add(await http.MultipartFile.fromPath('file', file));
      });

      print(
          'Files sended as part of the request => ' + request.files.toString());

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200)
        return Future.error(HttpException('Error while uploading data'));

      final newContent = json.decode(response.body)['uploaded'];

      await _addToCurrentContent(newContent);

      notifyListeners();
    } on HttpException catch (err) {
      print(err);
      return Future.error(HttpException(
          'Server not responding. Make sure it is up and running'));
    } on Exception catch (err) {
      print(err);
      return Future.error(HttpException('Error while uploading data'));
    }
  }
}
