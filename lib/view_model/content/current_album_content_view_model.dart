import 'package:cloud_chest/data/api_response.dart';
import 'package:cloud_chest/helpers/content/content_path_helper.dart';
import 'package:cloud_chest/models/album_settings.dart';
import 'package:cloud_chest/models/content/content.dart';
import 'package:cloud_chest/repositories/single_album_repository.dart';
import 'package:flutter/material.dart';
import 'package:cloud_chest/helpers/persistance/download_helper.dart';

// Holds the state for the current album, the one actually on display
class CurrentAlbumContentViewModel extends ChangeNotifier {
  SingleAlbumRepository _singleAlbumRepo = SingleAlbumRepository();
  String _accessToken = '';
  String _currentAlbumId = '';
  AlbumSettings? _currentAlbumSettings;
  ApiResponse _response = ApiResponse.loadingFull();
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

  // Validates the current album details
  // Call made to the API to update the db on server side
  Future<void> validateSettings(AlbumSettings newSettings) async {
    if (response.status != ResponseStatus.LOADING_FULL) {
      _setResponse(ApiResponse.loadingFull());
    }

    await _singleAlbumRepo
        .updateAlbumDetails(_accessToken, _currentAlbumId, newSettings)
        .then(
      (data) {
        _currentAlbumSettings = newSettings;

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

    if (_response.status != ResponseStatus.LOADING_FULL)
      _setResponse(ApiResponse.loadingFull());

    await _singleAlbumRepo
        .getSingleAlbum(albumId, _accessToken)
        .then(
          (data) => _setCurrentState(data),
        )
        .catchError((error, stackTrace) {
      print(stackTrace);
      _setResponse(
        ApiResponse.error(
          error.toString(),
        ),
      );
    });
  }

  // Sets the current state given an API response
  // Current state contains album content and album detail
  // Tries to update the album content with local paths if exists in local storage
  // Like so alleviate server bandwidth
  Future<void> _setCurrentState(Map<dynamic, dynamic> data) async {
    _currentAlbumSettings = data['settings'];

    await ContentPathHelper.updateList(data['content']).then(
      (contentList) => {
        _addToContentList(contentList),
        _setResponse(
          ApiResponse.done(),
        ),
      },
    );
  }

  // Upload new content to the album given an ID
  Future<void> uploadToAlbum(List<String> newContent) async {
    _setResponse(ApiResponse.loadingPartial());
    print('ADDING LIST ' + newContent.toString());
    await _singleAlbumRepo
        .postNewContent(newContent, _currentAlbumId, _accessToken)
        .then(
          (addedContent) {
            _addToContentList(addedContent);
            return addedContent;
          },
        )
        .then(
          (addedContent) => ContentPathHelper.addList(addedContent),
        )
        .whenComplete(
          () => _setResponse(
            ApiResponse.done(),
          ),
        )
        .catchError(
          (error, stackTrace) {
            throw error!;
          },
        );
  }

  // Deletes a list of items from the album
  Future<void> deleteFromAlbum(List<Content> contentToDelete) async {
    _setResponse(ApiResponse.loadingPartial());
    await ContentPathHelper.removeList(contentToDelete);
    await _singleAlbumRepo
        .deleteContent(contentToDelete, _currentAlbumId, _accessToken)
        .then((_) => _removeFromContentList(contentToDelete))
        .whenComplete(() => _setResponse(ApiResponse.done()))
        .catchError(
      (error, stackTrace) {
        throw error!;
      },
    );
  }

  //Downloads a list of items from the server and stores them in the gallery
  Future<void> downloadFromAlbum(List<Content> contentToDownload) async {
    await DownloadHelper()
        .downloadToGallery(contentToDownload)
        .then(
          (updatedContent) =>
              ContentPathHelper.addLocalPathToList(updatedContent),
        )
        .catchError((error, stackTrace) {
      print(stackTrace);
      print(error);
      throw error!;
    });
  }
}
