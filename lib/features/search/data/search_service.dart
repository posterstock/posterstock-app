import 'package:dio/dio.dart';
import 'package:supertokens_flutter/dio.dart';
import 'package:supertokens_flutter/supertokens.dart';

class SearchService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.posterstock.co/',
      connectTimeout: 10000,
      receiveTimeout: 10000,
    ),
  );
  String? token;

  SearchService() {
    _dio.interceptors.add(SuperTokensInterceptorWrapper(client: _dio));
  }

  Future<List<dynamic>> searchUsers(String searchValue) async {
    token = await SuperTokens.getAccessToken();
    try {
      var response = await _dio.get(
          'api/users/search',
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