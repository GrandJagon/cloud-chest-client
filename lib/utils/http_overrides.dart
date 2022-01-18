import 'dart:io';
import 'package:cloud_chest/helpers/config_helper.dart';

// Overrides the HTTP client for all requests
// Check the host and port destination for each request and allows self signed certificate
// Only if it is the same as the ones in user config
class CustomHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final httpClient = super.createHttpClient(context);

    httpClient
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) {
        final isRequestValid = (host == Config().get('host') &&
            port.toString() == Config().get('port'));

        return isRequestValid;
      });

    return httpClient;
  }
}
