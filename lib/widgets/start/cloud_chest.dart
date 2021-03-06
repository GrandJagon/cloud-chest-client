import 'package:cloud_chest/view_model/account/account_settings_view_model.dart';
import 'package:cloud_chest/view_model/account/change_password_view_model.dart';
import 'package:cloud_chest/view_model/auth/auth_view_model.dart';
import 'package:cloud_chest/screens/account/account_screen.dart';
import 'package:cloud_chest/screens/albums_list/albums_list_screen.dart';
import 'package:cloud_chest/themes/app_theme.dart';
import 'package:cloud_chest/view_model/content/content_viewer_view_model.dart';
import 'package:cloud_chest/view_model/content/content_selection_view_model.dart';
import 'package:cloud_chest/screens/album_content/album_content_screen.dart';
import 'package:cloud_chest/screens/album_settings/album_settings_screen.dart';
import 'package:cloud_chest/screens/auth/auth_screen.dart';
import 'package:cloud_chest/screens/auth/connect_screen.dart';
import 'package:cloud_chest/screens/content_viewer/content_viewer_screen.dart';
import 'package:cloud_chest/screens/misc/splash_screen.dart';
import 'package:cloud_chest/view_model/content/current_album_content_view_model.dart';
import 'package:cloud_chest/view_model/album_list/album_list_view_model.dart';
import 'package:cloud_chest/view_model/album_settings/user_search_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_chest/helpers/network/config_helper.dart';
import 'package:cloud_chest/utils/alert_dialog_factory.dart';
import '../../view_model/album_settings/album_settings_view_model.dart';

class CloudChest extends StatefulWidget {
  @override
  _CloudChestState createState() => _CloudChestState();
}

class _CloudChestState extends State<CloudChest> {
  // Creates the future builder dynamically in order to avoid call future at each rebuild
  FutureBuilder _authFutureBuilder(Auth provider, Future future) {
    return FutureBuilder(
      future: future,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return SplashScreen();
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            return AlbumsListScreen();
          }
          if (!snapshot.hasError && !provider.isConnected) {
            return AuthScreen();
          } else {
            Future.delayed(
              Duration.zero,
              () => showDialog(
                context: ctx,
                builder: (BuildContext context) =>
                    AlertDialogFactory.oneButtonDialog(
                        context, 'Error', snapshot.error.toString(), 'OK'),
              ),
            );
            return AuthScreen();
          }
        } else
          return AuthScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (context) => ContentSelectionViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => AlbumSettingsViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChangePasswordViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => AlbumListViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => CurrentAlbumViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => CurrentAlbumViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserSearchViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => AccountSettingsViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ContentViewerViewModel(),
        )
      ],
      child: MaterialApp(
        title: 'Cloud Chest',
        debugShowCheckedModeBanner: false,
        theme: DarkTheme(),
        home: !Config().isSetup
            ? ConnectScreen()
            : Consumer<Auth>(
                builder: (ctx, auth, _) => _authFutureBuilder(
                  auth,
                  auth.tryAutoConnect(),
                ),
              ),
        routes: {
          AuthScreen.routeName: (ctx) => AuthScreen(),
          ConnectScreen.routeName: (ctx) => ConnectScreen(),
          AlbumsListScreen.routeName: (ctx) => AlbumsListScreen(),
          AlbumContentScreen.routeName: (ctx) => AlbumContentScreen(),
          ContentViewerScreen.routeName: (ctx) => ContentViewerScreen(),
          AlbumSettingScreen.routeName: (ctx) => AlbumSettingScreen(),
          AccountScreen.routeName: (ctx) => AccountScreen()
        },
      ),
    );
  }
}
