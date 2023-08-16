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
    if (searchValue.isEmpty) return [];
    token = await SuperTokens.getAccessToken();
    try {
      var response = await _dio.get(
          'api/users/search',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
            receiveTimeout: 10000,
          ),
          queryParameters: {
            'query' : searchValue,
          }
      );
      print('344${response.data}');
      return response.data;
    } on DioError catch (e) {
      print(e.response);
      rethrow;
    }
  }
}