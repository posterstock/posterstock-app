import 'package:dio/dio.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:poster_stock/common/data/dio_keeper.dart';
import 'package:poster_stock/features/account/profile_mapper.dart';
import 'package:poster_stock/features/home/models/list_base_model.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';

class UserNetwork {
  final Dio _dio = DioKeeper.getDio();

  String? _postCursor;

  Future<UserDetailsModel> getUserInfo(int id) async {
    try {
      final response = await _dio.get('api/users/$id/');
      return ProfileMapper.fromJson(response.data);
    } on DioError catch (e) {
      Logger.e('Ошибка при получении пользователя $e');
      Logger.e(e.response?.headers);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<(List<PostMovieModel>?, bool)> getUserPosts(
    int id, {
    bool restart = false,
  }) async {
    if (restart) _postCursor = null;
    final response = await _dio.get('api/posters/users/$id',
        options: Options(headers: {}),
        queryParameters: {
          'cursor': _postCursor,
        });
    final List<Map<String, dynamic>> result = [];
    _postCursor = response.data['next_cursor'];
    for (var a in response.data['posters'] ?? []) {
      result.add(a);
    }
    return (result.map(_fromJson).toList(), response.data['has_more'] as bool);
  }

  PostMovieModel _fromJson(Map<String, dynamic> json) =>
      PostMovieModel.fromJson(json, previewPrimary: true);

  Future<List<ListBaseModel>?> getLists(int id) async {
    try {
      final response = await _dio.get(
        'api/lists/users/$id/',
      );
      final List<Map<String, dynamic>> result = [];
      for (var a in response.data) {
        result.add(a);
      }
      return result.map(_listFromJson).toList();
    } on DioError catch (e) {
      Logger.e('Ошибка при получении списков $e');
      Logger.e(e.response?.headers);
      return null;
    }
  }

  ListBaseModel _listFromJson(Map<String, dynamic> json) =>
      ListBaseModel.fromJson(json, previewPrimary: true);
}
