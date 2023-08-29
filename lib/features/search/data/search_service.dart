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
  String? lastSearch;
  String? nextCursorUsers;
  String? nextCursorPosts;
  String? nextCursorLists;
  bool gotAllUsers = false;
  bool gotAllPosts = false;
  bool gotAllLists = false;

  SearchService() {
    _dio.interceptors.add(SuperTokensInterceptorWrapper(client: _dio));
  }

  Future<(List<dynamic>, bool)> searchUsers(String searchValue) async {
    if (searchValue.isEmpty) return ([], false);
    token = await SuperTokens.getAccessToken();
    try {
      if (searchValue != lastSearch) {
        nextCursorUsers = null;
        gotAllUsers = false;
      }
      lastSearch = searchValue;
      var response = await _dio.get('api/users/search',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
            receiveTimeout: 10000,
          ),
          queryParameters: {
            'query': searchValue,
            if (nextCursorUsers != null) 'cursor': nextCursorUsers,
          });
      print(response.data);
      gotAllUsers = !response.data['has_more'];
      nextCursorUsers = response.data['next_cursor'];
      return (response.data['users'] as List<dynamic>, gotAllUsers);
    } on DioError catch (e) {
      print(e.response);
      rethrow;
    }
  }

  Future<(List<dynamic>, bool)> searchPosters(String searchValue) async {
    if (searchValue.isEmpty) return ([], false);
    token = await SuperTokens.getAccessToken();
    try {
      if (searchValue != lastSearch) {
        nextCursorPosts = null;
        gotAllPosts = false;
      }
      lastSearch = searchValue;
      var response = await _dio.get('api/posters/search',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
            receiveTimeout: 10000,
          ),
          queryParameters: {
            'query': searchValue,
            if (nextCursorPosts != null) 'cursor': nextCursorPosts,
          });
      gotAllPosts = !response.data['has_more'];
      nextCursorPosts = response.data['next_cursor'];
      print(response.data);
      return (response.data['posters'] as List<dynamic>, gotAllPosts);
    } on DioError catch (e) {
      print(e.response);
      rethrow;
    }
  }

  Future<(List<dynamic>, bool)> searchLists(String searchValue) async {
    if (searchValue.isEmpty) return ([], false);
    token = await SuperTokens.getAccessToken();
    try {
      if (searchValue != lastSearch) {
        nextCursorLists = null;
        gotAllLists = false;
      }
      lastSearch = searchValue;
      var response = await _dio.get('api/lists/search',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
            receiveTimeout: 10000,
          ),
          queryParameters: {
            'query': searchValue,
            if (nextCursorLists != null) 'cursor': nextCursorLists,
          });
      gotAllLists = !response.data['has_more'];
      nextCursorLists = response.data['next_cursor'];
      print(response.data);
      return (response.data['lists'] as List<dynamic>, gotAllLists);
    } on DioError catch (e) {
      print(e.response);
      rethrow;
    }
  }
}
