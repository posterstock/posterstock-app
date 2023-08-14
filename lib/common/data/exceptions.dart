class AlreadyHasAccountException implements Exception {
  final String message;

  AlreadyHasAccountException(this.message);

  @override
  String toString() {
    return message;
  }
}
