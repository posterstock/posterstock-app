import 'package:dio/dio.dart';
import 'package:supertokens_flutter/dio.dart';
import 'package:supertokens_flutter/supertokens.dart';

class CreatePosterService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.posterstock.co/',
      connectTimeout: 10000,
      receiveTimeout: 10000,
    ),
  );
  String? token;

  CreatePosterService() {
    _dio.interceptors.add(SuperTokensInterceptorWrapper(client: _dio));
  }

  Future<List<dynamic>> getSearchMedia(String searchValue) async {
    token = await SuperTokens.getAccessToken();
    try {
      var response = await _dio.get(
        'api/media/search',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        queryParameters: {
          'query' : searchValue,
        }
      );
      print(response.data);
      return response.data;
    } on DioError catch (e) {
      print(e.response);
      rethrow;
    }
  }
}
