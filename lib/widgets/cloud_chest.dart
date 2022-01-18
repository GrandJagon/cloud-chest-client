import 'package:cloud_chest/providers/album_provider.dart';
import 'package:cloud_chest/providers/auth_provider.dart';
import 'package:cloud_chest/providers/content_provider.dart';
import 'package:cloud_chest/screens/albums/album_detail_screen.dart';
import 'package:cloud_chest/screens/auth/auth_screen.dart';
import 'package:cloud_chest/screens/auth/connect_screen.dart';
import 'package:cloud_chest/screens/content/content_viewer.dart';
import 'package:cloud_chest/screens/home_screen.dart';
import 'package:cloud_chest/widgets/misc/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_chest/helpers/config_helper.dart';
import 'package:cloud_chest/utils/alert_dialog_factory.dart';

class CloudChest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, AlbumProvider>(
          create: (_) => (AlbumProvider('', '')),
          update: (_, auth, previous) =>
              AlbumProvider(auth.accessToken!, auth.userId!),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ContentProvider>(
          create: (_) => (ContentProvider('', '')),
          update: (_, auth, previous) =>
              ContentProvider(auth.accessToken!, auth.userId!),
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
              : Consumer<AuthProvider>(
                  builder: (ctx, auth, _) => FutureBuilder(
                    future: auth.tryAutoConnect(),
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return LoadingWidget();
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (!snapshot.hasError && auth.isAuthData)
                          return HomeScreen();
                        if (!snapshot.hasError && !auth.isAuthData)
                          return AuthScreen();
                        else {
                          Future.delayed(
                            Duration.zero,
                            () => showDialog(
                              context: context,
                              builder: (ctx) =>
                                  AlertDialogFactory.oneButtonDialog(
                                      ctx, snapshot.error.toString(), 'OK'),
                            ),
                          );
                          return AuthScreen();
                        }
                      } else
                        return AuthScreen();
                    },
                  ),
                ),
          routes: {
            AuthScreen.routeName: (ctx) => AuthScreen(),
            ConnectScreen.routeName: (ctx) => ConnectScreen(),
            HomeScreen.routeName: (ctx) => HomeScreen(),
            AlbumDetailScreen.routeName: (ctx) => AlbumDetailScreen(),
            ContentViewer.routeName: (ctx) => ContentViewer()
          }),
    );
  }
}
