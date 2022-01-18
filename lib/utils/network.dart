import 'package:cloud_chest/helpers/config_helper.dart';

class NetworkUtils {
  // Returns an endpoint url given an api and a request
  static Uri createEndpoint(String apiName, String urlPart,
      [Map<String, dynamic>? params]) {
    final host = Config().get('host');
    final port = Config().get('port');
    final url = Uri.http(host + ':' + port, apiName + '/' + urlPart, params);

    return url;
  }

  // Returns a path to fetch the image for the API
  // Takes the image file name as argument
  static String createImagePath(String filename) {
    final host = Config().get('host');
    final port = Config().get('port');

    return 'http://' + host + ':' + port + '/' + filename;
  }
}
