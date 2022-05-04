import 'package:cloud_chest/data/network_service.dart';
import 'package:cloud_chest/models/content/album.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AlbumListRepository {
  NetworkService _albumService = NetworkService(apiUrl: 'albums');
  final String _authTokenKey = dotenv.env['REQUEST_AUTH_TOKEN_KEY']!;

  // Singleton initialization
  static final AlbumListRepository _instance = AlbumListRepository._internal();

  factory AlbumListRepository() {
    return _instance;
  }

  AlbumListRepository._internal();

  // Returns user's all albums from the API
  Future<List<Album>> getAlbumList(String accessToken) async {
    try {
      final dynamic response = await _albumService.get(
        headers: {_authTokenKey: accessToken},
      ).catchError(
        (e) => throw e,
      );

      if (response is Exception) throw response;

      List<Album> albums =
          response.map<Album>((album) => Album.fromJson(album)).toList();

      return albums;
    } catch (err, stack) {
      print(stack);
      return Future.error(err);
    }
  }

  // Request new album creation from the API and returns the newly created album
  Future<dynamic> postNewAlbum(String accessToken, String title) async {
    try {
      final response = await _albumService.post(
          headers: {_authTokenKey: accessToken},
          data: {'title': title},
          urlPart: 'create').catchError(
        (e) => throw e,
      );

      if (response is Exception) throw response;

      final newAlbum = Album.fromJson(response);

      return newAlbum;
    } catch (err, stack) {
      return Future.error(err);
    }
  }

  // Requests album deletion from the API and returns the deleted album
  Future<void> deleteAlbum(String accessToken, String albumId) async {
    try {
      await _albumService.delete(
        headers: {_authTokenKey: accessToken},
        params: {'albumId': albumId},
      ).catchError(
        (e) => throw e,
      );
    } catch (err) {
      throw err;
    }
  }
}
