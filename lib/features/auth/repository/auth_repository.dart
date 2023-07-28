import 'package:poster_stock/features/auth/data/auth_service.dart';

class AuthRepository {
  final AuthService _service = AuthService();

  Future<(String, String)> sendEmail(String email) async {
    return await _service.sendEmail(email);
  }

  Future<int> getId(String token) async {
    return await _service.getId(token);
  }

  Future<String?> confirmCode({
    required String code,
    required String sessionId,
    required String deviceId,
    required String name,
    required String login,
    required String email,
  }) async {
    return await _service.confirmCode(
      code: code,
      sessionId: sessionId,
      deviceId: deviceId,
      name: name,
      login: login,
      email: email,
    );
  }
}
