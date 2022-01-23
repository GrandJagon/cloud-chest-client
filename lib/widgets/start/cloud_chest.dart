import 'package:cloud_chest/providers/album_provider_old.dart';
import 'package:cloud_chest/providers/auth_provider_old.dart';
import 'package:cloud_chest/providers/content_provider_old.dart';
import 'package:cloud_chest/screens/album_detail/album_detail_screen.dart';
import 'package:cloud_chest/screens/auth/auth_screen.dart';
import 'package:cloud_chest/screens/auth/connect_screen.dart';
import 'package:cloud_chest/screens/home_screen.dart';
import 'package:cloud_chest/screens/splash_screen.dart';
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
  FutureBuilder _authFutureBuilder(AuthProvider provider, Future future) {
    return FutureBuilder(
      future: future,
      builder: (ctx, snapshot) {
        print('Waiting for future trying to autoconnect');
        if (snapshot.connectionState == ConnectionState.waiting)
          return SplashScreen();
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            print('Redirecting to home screen');
            return HomeScreen();
          }
          if (!snapshot.hasError && !provider.isAuthData)
            return AuthScreen();
          else {
            Future.delayed(
              Duration.zero,
              () => showDialog(
                context: ctx,
                builder: (_) => AlertDialogFactory.oneButtonDialog(
                    ctx, snapshot.error.toString(), 'OK'),
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
                  builder: (ctx, auth, _) => _authFutureBuilder(
                    auth,
                    auth.tryAutoConnect(),
                  ),
                ),
          routes: {
            AuthScreen.routeName: (ctx) => AuthScreen(),
            ConnectScreen.routeName: (ctx) => ConnectScreen(),
            HomeScreen.routeName: (ctx) => HomeScreen(),
            AlbumDetailScreen.routeName: (ctx) => AlbumDetailScreen()
          }),
    );
  }
}
