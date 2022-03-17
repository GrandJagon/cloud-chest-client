import 'package:cloud_chest/helpers/network/config_helper.dart';

class NetworkUtils {
  // Returns an endpoint url given an api and a request
  static Uri createEndpoint(String apiName, String urlPart,
      [Map<String, dynamic>? params]) {
    final host = Config().get('host');
    final port = Config().get('port');
    final url = Uri.https(host + ':' + port, apiName + '/' + urlPart, params);

    return url;
  }

  // Returns a path to fetch the image for the API
  // Takes the image file name as argument
  static String createContentPath(String filename) {
    final host = Config().get('host');
    final port = Config().get('port');

    return 'https://' + host + ':' + port + '/' + filename;
  }
}
