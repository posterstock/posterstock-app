import 'package:poster_stock/features/auth/data/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final AuthService _service = AuthService();

  Future<(String, String)> signUpSendEmail(String email) async {
    return await _service.signUpSendEmail(email);
  }

  Future<bool> getRegistered(String email) async {
    return await _service.getRegistered(email);
  }

  Future<void> registerNotification(String token, String userToken) async {
    return await _service.registerNotification(token, userToken);
  }

  Future<String?> confirmCode({
    required String code,
    required String sessionId,
    required String deviceId,
    String? name,
    String? login,
    required String email,
  }) async {
    final token = await _service.confirmCode(
      code: code,
      sessionId: sessionId,
      deviceId: deviceId,
      name: name,
      login: login,
      email: email,
    );
    if (token == null) return null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    return token;
  }

  Future<void> authApple({
    String? name,
    String? surname,
    String? email,
    String? code,
    String? clientId,
    String? state,
  }) async {
    await _service.authApple(
      name: name,
      surname: surname,
      email: email,
      code: code,
      clientID: clientId,
      state: state,
    );
  }

  Future<void> authGoogle({
    String? accessToken,
    String? idToken,
    String? code,
  }) async {
    await _service.authGoogle(
      idToken: idToken,
      accessToken: accessToken,
      code: code,
    );
  }
}
