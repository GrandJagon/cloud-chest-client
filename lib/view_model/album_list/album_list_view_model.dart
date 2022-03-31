// Handles data passing between the model and the view
// Holds the state of the user album list
import 'package:cloud_chest/data/api_response.dart';
import 'package:cloud_chest/models/content/album.dart';
import 'package:cloud_chest/repositories/album_list_repository.dart';
import 'package:flutter/material.dart';

class AlbumListViewModel extends ChangeNotifier {
  String _accessToken = '';
  ApiResponse _response = ApiResponse.loadingFull();
  final AlbumListRepository _albumListRepo = AlbumListRepository();
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
    _albumList.add(album);
    _setResponse(ApiResponse.done());
  }

  // Set the response as loading and fetches the data from repo before setting it as a response
  Future<void> fetchAlbums() async {
    if (_response.status != ResponseStatus.LOADING_FULL)
      _response = ApiResponse.loadingFull();
    await _albumListRepo
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
  Future<void> createAlbum(String title) async {
    _setResponse(ApiResponse.loadingPartial());
    await _albumListRepo
        .postNewAlbum(_accessToken, title)
        .then((response) => _addToAlbumList(response))
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
    _setResponse(ApiResponse.loadingPartial());
    await _albumListRepo
        .deleteAlbum(_accessToken, albumId)
        .catchError((error, stackTrace) => throw error!)
        .then((value) {
      _albumList.removeWhere((album) => album.albumId == albumId);
      notifyListeners();
    }).whenComplete(
      () => _setResponse(
        ApiResponse.done(),
      ),
    );
  }

  // Called from currentAlbumViewModel in order to propagate new settings to the list
  // For list update purpose (title and thumbnail)
  void updateAlbum(String albumId, String title, String thumbnail) {
    Album targetAlbum = getAlbumById(albumId);

    targetAlbum.title = title;
    targetAlbum.thumbnail = thumbnail;

    notifyListeners();
  }
}
