// Handles data passing between the model and the view
// Holds the state of the user album list
import 'package:cloud_chest/data/api_response.dart';
import 'package:cloud_chest/models/album.dart';
import 'package:cloud_chest/repositories/album_repository.dart';
import 'package:flutter/foundation.dart';

class AlbumsViewModel extends ChangeNotifier {
  String _accessToken = '';
  ApiResponse _response = ApiResponse.loading();
  final AlbumRepository _albumRepo = AlbumRepository();
  List<Album> _albumList = [];

  List<Album> get albumList => [..._albumList];

  ApiResponse get response => _response;

  void setToken(String accessToken) {
    _accessToken = accessToken;
  }

  Album getAlbumById(String id) {
    return _albumList.firstWhere((album) => album.albumId == id);
  }

  // Sets the album list and the response as done
  void _setAlbumList(List<Album> albumList) {
    _albumList = albumList;
    _setResponse(ApiResponse.done());
  }

  // Sets a new response
  void _setResponse(ApiResponse response) {
    _response = response;
    notifyListeners();
  }

  // Adds an album to the current album list
  void _addToAlbumList(Album album) {
    albumList.add(album);
    _setResponse(ApiResponse.done());
  }

  // Set the response as loading and fetches the data from repo before setting it as a response
  Future<void> fetchAlbums() async {
    if (_response.status != ResponseStatus.LOADING)
      _response = ApiResponse.loading();
    await _albumRepo
        .getAlbumList(_accessToken)
        .then((response) => _setAlbumList(response))
        .onError(
          (error, stackTrace) => _setResponse(
            ApiResponse.error(
              error.toString(),
            ),
          ),
        );
    notifyListeners();
  }

  // Creates a new album and adds it to the current album list
  Future<void> createAlbum(String title, String? description) async {
    _setResponse(ApiResponse.loading());
    await _albumRepo
        .postNewAlbum(_accessToken, title, description)
        .then((response) => _addToAlbumList(response))
        .whenComplete(() => notifyListeners())
        .catchError(
            // API call no mandatory for album list to be displayed here
            // No need to update the response as we won't rebuild in case of error but just catching the error and show snackbar
            (error, stackTrace) {
      _setResponse(ApiResponse.done());
      throw error!;
    });
  }

  // Deletes new album and deletes it from the current list
  Future<void> deleteAlbum(String albumId) async {
    await _albumRepo
        .deleteAlbum(_accessToken, albumId)
        .catchError((error, stackTrace) => throw error!)
        .whenComplete(
          () => _albumList.removeWhere((album) => album.albumId == albumId),
        );
  }
}
