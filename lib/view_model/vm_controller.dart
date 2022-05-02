import 'package:cloud_chest/view_model/account/account_settings_view_model.dart';
import 'package:cloud_chest/view_model/album_list/album_list_view_model.dart';
import 'package:cloud_chest/view_model/album_settings/user_search_view_model.dart';
import 'package:cloud_chest/view_model/content/current_album_content_view_model.dart';

class VmController {
  // Resets all view models data
  // To be called when logging out
  static void reset() {
    print('Resetting view models');
    AlbumListViewModel().reset();
    CurrentAlbumViewModel().reset();
    AccountSettingsViewModel().reset();
    UserSearchViewModel().reset();
  }

  // Sets access token and user id in all needing view models
  // To be called at login
  static void init(String accessToken, String userId) {
    print('Initiating view models');
    AlbumListViewModel().setToken(accessToken);
    CurrentAlbumViewModel().setToken(accessToken);
    UserSearchViewModel().setToken(accessToken);
    AccountSettingsViewModel().setToken(accessToken);
    AccountSettingsViewModel().setUserDetail('id', userId);
  }

  static void refreshToken(String accessToken) {
    print('Propagating new token to view models');
    AlbumListViewModel().setToken(accessToken);
    CurrentAlbumViewModel().setToken(accessToken);
    UserSearchViewModel().setToken(accessToken);
    AccountSettingsViewModel().setToken(accessToken);
  }
}
