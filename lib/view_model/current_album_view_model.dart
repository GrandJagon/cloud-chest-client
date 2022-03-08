import 'package:cloud_chest/data/api_response.dart';
import 'package:cloud_chest/models/album_settings.dart';
import 'package:cloud_chest/models/content.dart';
import 'package:cloud_chest/repositories/single_album_repository.dart';
import 'package:flutter/material.dart';
import 'package:cloud_chest/helpers/download_helper.dart';

// Holds the state for the current album, the one actually on display
class CurrentAlbumViewModel extends ChangeNotifier {
  SingleAlbumRepository _singleAlbumRepo = SingleAlbumRepository();
  String _accessToken = '';
  String _currentAlbumId = '';
  AlbumSettings? _currentAlbumSettings;
  ApiResponse _response = ApiResponse.loading();
  List<dynamic> _contentList = [];

  ApiResponse get response => _response;

  List<Content> get contentList => [..._contentList];

  AlbumSettings get currentAlbumSettings => _currentAlbumSettings!;

  String get currentAlbumId => _currentAlbumId;

  void setToken(String token) {
    _accessToken = token;
  }

  void _setResponse(ApiResponse response) {
    _response = response;
    notifyListeners();
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

  // Updates the details on change by the user
  // Nothing sent to the API until final validation
  void updateDetails(String key, dynamic value) {
    print(key + ' will be updated with new value ' + value.toString());
    switch (key) {
      case 'title':
        _currentAlbumSettings!.title = value;
        return;
      case 'thumbnail':
        _currentAlbumSettings!.thumbnail = value;
        return;
      case 'users':
        _currentAlbumSettings!.users = value;
        return;
    }
  }

  // Validates the dcurrent album details
  // Call made to the API to update the db on server side
  Future<void> validateDetails() async {
    if (response.status != ResponseStatus.LOADING) {
      _setResponse(ApiResponse.loading());
    }

    await _singleAlbumRepo
        .updateAlbumDetails(
            _accessToken, _currentAlbumId, _currentAlbumSettings!)
        .then(
      (data) {
        print('then');
        _setResponse(
          ApiResponse.done(),
        );
      },
    ).catchError(
      (error, stackTrace) {
        print(stackTrace);
        print(error);
      },
    );
  }

  // Fetches a single album content and detail and sets it as current album
  Future<void> fetchSingleAlbum(String albumId) async {
    // Resets selection when fetching as it is likely different album or page reloading
    _contentList.clear();
    _currentAlbumId = albumId;

    if (_response.status != ResponseStatus.LOADING)
      _setResponse(ApiResponse.loading());

    await _singleAlbumRepo
        .getSingleAlbum(albumId, _accessToken)
        .then(
          (data) => _setCurrentState(data),
        )
        .catchError(
          (error, stackTrace) => _setResponse(
            ApiResponse.error(
              error.toString(),
            ),
          ),
        );
  }

  // Sets the current state given an API response
  // Current state contains album content and album detail
  void _setCurrentState(Map<dynamic, dynamic> data) {
    _contentList = data['content'];
    _currentAlbumSettings = data['settings'];
    _setResponse(ApiResponse.done());
  }

  // Upload new content to the album given an ID
  Future<void> uploadToAlbum(List<String> newContent) async {
    _setResponse(ApiResponse.loading());
    await _singleAlbumRepo
        .postNewContent(newContent, _currentAlbumId, _accessToken)
        .then((addedContent) => _addToContentList(addedContent))
        .whenComplete(() => _setResponse(ApiResponse.done()))
        .catchError(
      (error, stackTrace) {
        _setResponse(ApiResponse.done());
        throw error!;
      },
    );
  }

  // Deletes a list of items from the album
  Future<void> deleteFromAlbum(List<Content> contentToDelete) async {
    _setResponse(ApiResponse.loading());
    await _singleAlbumRepo
        .deleteContent(contentToDelete, _currentAlbumId, _accessToken)
        .then((_) => _removeFromContentList(contentToDelete))
        .whenComplete(() => _setResponse(ApiResponse.done()))
        .catchError(
      (error, stackTrace) {
        _setResponse(ApiResponse.done());
        throw error!;
      },
    );
  }

  //Downloads a list of items from the server and stores them in the gallery
  Future<void> downloadFromAlbum(List<Content> contentToDownload) async {
    final List<String> urls = contentToDownload.map((c) => c.path).toList();
    _setResponse(ApiResponse.loading());
    await DownloadHelper()
        .downloadToGallery(urls)
        .whenComplete(() => _setResponse(ApiResponse.done()))
        .catchError((error, stackTrace) {
      _setResponse(ApiResponse.done());
      throw error!;
    });
  }
}
