import 'package:cloud_chest/providers/auth_provider.dart';
import 'package:cloud_chest/providers/content_viewer_provider.dart';
import 'package:cloud_chest/providers/user_selection_provider.dart';
import 'package:cloud_chest/screens/album_content/album_content_screen.dart';
import 'package:cloud_chest/screens/auth/auth_screen.dart';
import 'package:cloud_chest/screens/auth/connect_screen.dart';
import 'package:cloud_chest/screens/content_viewer/content_viewer.dart';
import 'package:cloud_chest/screens/home_screen.dart';
import 'package:cloud_chest/screens/splash_screen.dart';
import 'package:cloud_chest/view_model/album_content_view_model.dart';
import 'package:cloud_chest/view_model/albums_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_chest/helpers/config_helper.dart';
import 'package:cloud_chest/utils/alert_dialog_factory.dart';

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
            return AlbumListScreen();
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
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProvider(create: (context) => UserSelection()),
        ChangeNotifierProxyProvider<Auth, AlbumsViewModel>(
          create: (_) => AlbumsViewModel(),
          update: (_, auth, previous) {
            previous!.setToken(auth.accessToken!);
            return previous;
          },
        ),
        ChangeNotifierProxyProvider<Auth, AlbumContentViewModel>(
          create: (_) => AlbumContentViewModel(),
          update: (_, auth, previous) {
            previous!.setToken(auth.accessToken!);
            return previous;
          },
        ),
        ChangeNotifierProxyProvider<AlbumContentViewModel,
            ContentViewerProvider>(
          create: (_) => ContentViewerProvider(),
          update: (_, albumContentViewModel, previous) {
            previous!.setAlbumToView(albumContentViewModel.contentList);
            return previous;
          },
        )
      ],
      child: MaterialApp(
          title: 'Cloud Chest',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
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
            AlbumListScreen.routeName: (ctx) => AlbumListScreen(),
            AlbumContentScreen.routeName: (ctx) => AlbumContentScreen(),
            ContentViewerScreen.routeName: (ctx) => ContentViewerScreen()
          }),
    );
  }
}
