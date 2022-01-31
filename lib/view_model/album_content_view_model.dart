import 'package:cloud_chest/data/api_response.dart';
import 'package:cloud_chest/models/content.dart';
import 'package:cloud_chest/repositories/content_repository.dart';
import 'package:flutter/cupertino.dart';

class AlbumContentViewModel extends ChangeNotifier {
  ContentRepository _contentRepo = ContentRepository();
  String _accessToken = '';
  String _currentAlbumId = '';
  ApiResponse _response = ApiResponse.loading();
  List<Content> _contentList = [];

  ApiResponse get response => _response;

  List<Content> get contentList => [..._contentList];

  void setToken(String token) {
    _accessToken = token;
  }

  void _setResponse(ApiResponse response) {
    _response = response;
    notifyListeners();
  }

  void _setContentList(List<Content> contentList) {
    _contentList = contentList;
    _setResponse(ApiResponse.done());
  }

  void _addToContentList(List<Content> newContent) {
    _contentList.addAll(newContent);
  }

  void _removeFromContentList(List<Content> contentToRemove) {
    contentToRemove.forEach(
      (content) {
        _contentList.remove(content);
      },
    );
  }

  // Fecthes an album content given an ID and sets the ID as the current album ID until new album is fetched
  Future<void> fetchAlbumContent(String albumId) async {
    // Resets selection when fetching as it is likely different album or page reloading
    _contentList.clear();
    _currentAlbumId = albumId;

    if (_response.status != ResponseStatus.LOADING)
      _setResponse(ApiResponse.loading());

    await _contentRepo
        .getAlbumContent(albumId, _accessToken)
        .then(
          (albumContent) => _setContentList(albumContent),
        )
        .catchError(
          (error, stackTrace) => _setResponse(
            ApiResponse.error(
              error.toString(),
            ),
          ),
        );
  }

  // Upload new content to the album given an ID
  Future<void> uploadToAlbum(List<String> newContent) async {
    await _contentRepo
        .postNewContent(newContent, _currentAlbumId, _accessToken)
        .then((addedContent) => _addToContentList(addedContent))
        .whenComplete(() => notifyListeners())
        .catchError(
      (error, stackTrace) {
        _setResponse(ApiResponse.done());
        throw error!;
      },
    );
  }

  // Deletes a list of items from the album
  Future<void> deleteFromAlbum(List<Content> contentToDelete) async {
    await _contentRepo
        .deleteContent(contentToDelete, _currentAlbumId, _accessToken)
        .then((_) => _removeFromContentList(contentToDelete))
        .whenComplete(() => notifyListeners())
        .catchError(
      (error, stackTrace) {
        _setResponse(ApiResponse.done());
        throw error!;
      },
    );
  }
}
