class AuthHandler {
  static bool handleResponse(dynamic data) {
    if (data['status'] == 'OK') return true;
    throw AuthException();
  }
}

class AuthException extends FormatException {
  @override
  String get message => "Error getting data from server";
}
