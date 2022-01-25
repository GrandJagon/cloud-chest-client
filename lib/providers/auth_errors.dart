class AuthError extends Error {
  final String _message, _title;

  AuthError(this._message, this._title);

  String get message => _message;

  @override
  String toString() {
    return "$_title : $_message";
  }
}

class AuthConnectionError extends AuthError {
  AuthConnectionError(message) : super(message, 'Auth Connection Error');
}

class NoAuthDataError extends AuthError {
  NoAuthDataError(message) : super(message, 'No Auth Data Error');
}

class AuthDataNonValidError extends AuthError {
  AuthDataNonValidError(message) : super(message, 'Auth Data Non Valid Error');
}
