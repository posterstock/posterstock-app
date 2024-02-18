import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:poster_stock/common/data/dio_keeper.dart';
import 'package:poster_stock/features/account/profile_mapper.dart';
import 'package:poster_stock/features/home/models/list_base_model.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';

class AccountNetwork {
  final Dio _dio = DioKeeper.getDio();

  String? _postsCursor;
  String? _bookmarkCursor;

  Future<UserDetailsModel> getProfileInfo() async {
    try {
      final response = await _dio.get('api/profiles/');
      return ProfileMapper.fromJson(response.data);
    } on DioError catch (e) {
      print(e.response);
      print(e.response?.headers);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<(List<PostMovieModel>?, bool)> getPosters(
    int id, {
    bool restart = false,
  }) async {
    if (restart) _postsCursor = null;
    final response = await _dio.get(
      'api/posters/users/$id',
      queryParameters: {'cursor': _postsCursor},
    );
    final List<Map<String, dynamic>> result = [];
    _postsCursor = response.data['next_cursor'];
    for (var a in response.data['posters'] ?? []) {
      result.add(a);
    }
    return (result.map(_fromJson).toList(), response.data['has_more'] as bool);
  }

  PostMovieModel _fromJson(Map<String, dynamic> json) =>
      PostMovieModel.fromJson(json, previewPrimary: true);

  Future<(List<PostMovieModel>?, bool)> getBookmarks(
      {bool restart = false}) async {
    if (restart) _bookmarkCursor = null;
    final response = await _dio.get(
      'api/bookmarks/my',
      queryParameters: {'cursor': _bookmarkCursor},
    );
    final List<Map<String, dynamic>> result = [];
    _bookmarkCursor = response.data['next_cursor'];
    for (var a in response.data['entries'] ?? []) {
      result.add(a);
    }
    log('reslut ${result.length}');
    return (
      result.map(_fromJson).toList(),
      response.data['has_more'] as bool,
    );
  }

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
      print(e.response?.headers);
      print(e.response?.data);
      return null;
    }
  }

  ListBaseModel _listFromJson(Map<String, dynamic> json) =>
      ListBaseModel.fromJson(json, previewPrimary: true);
}
