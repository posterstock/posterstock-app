import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:poster_stock/features/profile/data/i_profile_service.dart';
import 'package:supertokens_flutter/dio.dart';
import 'package:supertokens_flutter/supertokens.dart';

class ProfileService implements IProfileService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://posterstock.co/',
      connectTimeout: 10000,
      receiveTimeout: 10000,
    ),
  );

  ProfileService() {
    _dio.interceptors.add(SuperTokensInterceptorWrapper(client: _dio));
  }

  Future<List<Map<String, dynamic>>> getUserPosts(String token, int? id) async {
    final response = await _dio.get(
      'api/posters/users/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final List<Map<String, dynamic>> result = [];
    for (var a in response.data) {
      result.add(a);
    }
    return result;
  }

  Future<List<Map<String, dynamic>>> getUserLists(String token, int? id) async {
    final response = await _dio.get(
      'api/lists/users/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final List<Map<String, dynamic>> result = [];
    for (var a in response.data) {
      result.add(a);
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> getProfileInfo(String token, int? id) async {
    try {
      if (id == null) {
        try {
          final response = await _dio.post(
            'api/profiles/',
            options: Options(headers: {'Authorization': 'Bearer $token'}),
            data: jsonEncode({
              'id': await SuperTokens.getUserId(),
            }),
          );
          (response.data as Map<String, dynamic>).addAll({'myself' : true});
          return response.data;
        } catch (e) {
          rethrow;
        }
      }
      final response = await _dio.get(
        'api/users/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print(response);
      return response.data;
    } on DioError catch (e) {
      //print(e.response);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getProfileLists(String token, int id) {
    // TODO: implement getProfileLists
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getProfilePosts(String token, int id) {
    // TODO: implement getProfilePosts
    throw UnimplementedError();
  }
}
