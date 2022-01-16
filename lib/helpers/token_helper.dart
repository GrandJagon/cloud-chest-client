import 'dart:convert';

// Helper for checking token validity
class TokenHelper {
  static Map<String, dynamic> decodeToken(String rawToken) {
    final parts = rawToken.split('.');

    if (parts.length < 3) throw Exception('Malformed token');

    var payload = parts[1];

    // Adding the correct padding to decode base 64
    switch (payload.length % 4) {
      case 0:
        break;
      case 2:
        payload += '==';
        break;
      case 3:
        payload += '=';
        break;
      default:
        throw Exception('Malformed token');
    }

    final strPayload = String.fromCharCodes(base64Url.decode(payload));
    final token = json.decode(strPayload);

    return token;
  }
}
