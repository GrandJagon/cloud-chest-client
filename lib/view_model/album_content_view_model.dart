import 'package:cloud_chest/data/api_response.dart';
import 'package:cloud_chest/models/content.dart';
import 'package:cloud_chest/repositories/content_repository.dart';
import 'package:flutter/cupertino.dart';

class AlbumContentViewModel extends ChangeNotifier {
  ContentRepository _contentRepo = ContentRepository();
  String _accessToken = '';
  ApiResponse _response = ApiResponse.loading();
  List<Content> _contentList = [];
  Content? _currentItem;

  ApiResponse get response => _response;

  List get contentList => [..._contentList];

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
    notifyListeners();
  }

  // Fecthes an album content given an ID
  Future<void> fetchAlbumContent(String albumId) async {
    if (_response.status != ResponseStatus.LOADING)
      _setResponse(ApiResponse.loading());

    await _contentRepo
        .getAlbumContent(albumId, _accessToken)
        .then(
          (albumContent) => _setContentList(albumContent),
        )
        .onError(
          (error, stackTrace) => _setResponse(
            ApiResponse.error(
              error.toString(),
            ),
          ),
        );
  }

  // Upload new content to the album given an ID
  Future<void> uploadToAlbum(String albumId, List<String> newContent) async {
    await _contentRepo
        .postNewContent(newContent, albumId)
        .then((addedContent) => _addToContentList(addedContent))
        .whenComplete(() => notifyListeners())
        .onError(
      (error, stackTrace) {
        _setResponse(ApiResponse.done());
        throw error!;
      },
    );
  }
}
