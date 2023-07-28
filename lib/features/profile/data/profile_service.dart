import 'package:dio/dio.dart';
import 'package:poster_stock/features/profile/data/i_profile_service.dart';
import 'package:supertokens_flutter/dio.dart';

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

  @override
  Future<Map<String, dynamic>> getProfileInfo(String token, int id) async {
    try {
      final response = await _dio.get(
        'api/users/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print(response);
      return response.data;
    } on DioError catch (e) {
      print(e.response);
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
