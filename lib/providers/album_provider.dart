import 'dart:async';
import 'dart:io';
import 'package:cloud_chest/models/album.dart';
import 'package:cloud_chest/utils/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AlbumProvider extends ChangeNotifier {
  final String accessToken;
  final String userId;
  late List<Album> _albums;

  AlbumProvider(this.accessToken, this.userId);

  List<Album> get albums => [..._albums];

  int get size => _albums.length;

  Album getAlbumById(String id) =>
      _albums.firstWhere((album) => album.albumId == id);

  // Fetches all the albums to which the user has access
  Future<void> fetchAndSetAlbums() async {
    _albums = [];
    Uri url = NetworkUtils.createEndpoint('albums', '');

    try {
      final response = await http.get(url, headers: {
        'auth-token': accessToken
      }).timeout(Duration(seconds: int.parse(dotenv.env['REQUEST_TIMEOUT']!)));

      if (response.statusCode != 200)
        return Future.error(HttpException('Error while fetching user albums'));

      final decodedResponse = json.decode(response.body);
      final albumList = decodedResponse['albumList'];

      for (var i = 0; i < albumList.length; i++) {
        _albums.add(Album(
            albumId: albumList[i]['albumId'],
            title: albumList[i]['title'],
            thumbnail: albumList[i]['thumbnail'] ?? '',
            rights: albumList[i]['rights']));
      }

      notifyListeners();
    } on TimeoutException catch (err, stack) {
      print(stack);
      return Future.error(HttpException(
          'The server is not responding. Make sure it it up and running'));
    } on Exception catch (err, stack) {
      print(stack);
      return Future.error(HttpException(
          'An error occured while trying to fetch your albums data.'));
    }
  }

  // Request a new album to be created
  Future<void> createAlbum(String title, String desc) async {
    Uri url = NetworkUtils.createEndpoint('albums', '/create');

    try {
      final response = await http.post(url, headers: {
        'auth-token': accessToken
      }, body: {
        'title': title,
        'description': desc
      }).timeout(Duration(seconds: int.parse(dotenv.env['REQUEST_TIMEOUT']!)));

      if (response.statusCode != 200) {
        return Future.error(HttpException('Error while creating album'));
      }

      final decodedResponse = json.decode(response.body);

      final _newAlbum = Album(
          albumId: decodedResponse['albumId'],
          title: decodedResponse['title'],
          rights: ['admin']);

      _albums.add(_newAlbum);

      print('Album succesfully created ' + decodedResponse.toString());

      notifyListeners();
    } on TimeoutException catch (err) {
      print(err);
      return Future.error(HttpException(
          'The server is not responding. Make sure it is up and running'));
    } on Exception catch (err) {
      print(err);
      return Future.error(
          HttpException('An error occured whil creating th albul'));
    }
  }
}
