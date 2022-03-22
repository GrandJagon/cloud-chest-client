class CloudChestException implements Exception {
  final String _message, _title;

  CloudChestException(this._message, this._title);

  @override
  String toString() {
    return "$_title : $_message";
  }
}

class FetchException extends CloudChestException {
  FetchException(message) : super(message, 'Data fetching exception ');
}

class UnauthorizedException extends CloudChestException {
  UnauthorizedException(message) : super(message, 'Unauthorized request');
}

class InvalidException extends CloudChestException {
  InvalidException(message) : super(message, 'Invalid request');
}

class ServerException extends CloudChestException {
  ServerException(message) : super(message, 'Server error');
}

class DbException extends CloudChestException {
  DbException(message) : super(message, 'Database error');
}

class DlException extends CloudChestException {
  DlException(message) : super(message, 'Download error');
}
