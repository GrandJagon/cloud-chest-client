import 'package:cloud_chest/data/network_service.dart';
import 'package:cloud_chest/models/album.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AlbumRepository {
  NetworkService _albumService = NetworkService(apiUrl: 'albums');
  final String _auth_token_key = dotenv.env['REQUEST_AUTH_TOKEN_KEY']!;

  Future<List<Album>> getAlbumList(String access_token) async {
    try {
      final response =
          await _albumService.get(headers: {_auth_token_key: access_token});
      final data = response['content'] as List;

      List<Album> albums = data.map((album) => Album.fromJson(album)).toList();

      return albums;
    } catch (err) {
      throw err;
    }
  }

  Future<String> postNewAlbum(
      String access_token, String title, String? description) async {
    try {
      final response = await _albumService.post(
          headers: {_auth_token_key: access_token},
          data: {'title': title, 'description': description ?? ''});

      return response.message;
    } catch (err) {
      throw err;
    }
  }
}
