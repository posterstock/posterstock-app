import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supertokens_flutter/dio.dart';
import 'package:supertokens_flutter/supertokens.dart';

class DioKeeper {
  static Dio getDio() {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.posterstock.com/',
        connectTimeout: 10000,
        receiveTimeout: 10000,
        maxRedirects: 5,
      ),
    );

    String? token;

    dio.interceptors.add(SuperTokensInterceptorWrapper(client: dio));
    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          if (await SuperTokens.doesSessionExist()) {
            final prefs = await SharedPreferences.getInstance();
            token = await SuperTokens.getAccessToken();
            prefs.setString('token', token ?? '');
          } else {
            bool refreshed = await SuperTokens.attemptRefreshingSession();
            if (refreshed) {
              final prefs = await SharedPreferences.getInstance();
              token = await SuperTokens.getAccessToken();
              prefs.setString('token', token ?? '');
            }
          }
          options.headers['Authorization'] = 'Bearer $token';
          handler.next(options);
        },
      ),
    );
    return dio;
  }
}
