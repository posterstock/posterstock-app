import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:poster_stock/features/home/models/list_base_model.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';
import 'package:poster_stock/features/profile/repository/i_profile_repository.dart';

import '../data/profile_service.dart';

class ProfileRepository implements IProfileRepository {
  final profileService = ProfileService();

  @override
  Future<UserDetailsModel> getProfileInfo(dynamic id) async {
    final result = (await profileService.getProfileInfo(id));
    if (result['id'] != null) {
      final blocked = (await profileService.getBlocked(result['id'] as int));

      return UserDetailsModel.fromJson(result).copyWith(
        mySelf: id == null,
        blocked: blocked,
      );
    } else {
      return UserDetailsModel.fromJson(result).copyWith(
        mySelf: id == null,
        blocked: false,
      );
    }
  }

  @override
  Future<(List<PostMovieModel>?, bool)> getMyBookmarks(
      {bool restart = false}) async {
    try {
      final result = (await profileService.getMyBookmarks(restart: restart));
      return (
        result.$1?.map((e) => PostMovieModel.fromJson(e)).toList(),
        result.$2
      );
    } catch (e) {
      Logger.e('Ошибка при получении постеров $e');
    }
    return (<PostMovieModel>[], true);
  }

  @override
  Future<void> follow(int? id, bool follow) async {
    await profileService.follow(id, follow);
  }

  @override
  Future<(List<PostMovieModel>?, bool)> getProfilePosts(int? id,
      {bool restart = false}) async {
    try {
      final result = (await profileService.getUserPosts(id, restart: restart));
      return (
        result.$1
            ?.map(
              (e) => PostMovieModel.fromJson(e, previewPrimary: true),
            )
            .toList(),
        result.$2
      );
    } catch (e) {
      Logger.e('Ошибка при получении постеров $e');
    }
    return (<PostMovieModel>[], false);
  }

  @override
  Future<List<ListBaseModel>?> getProfileLists(int? id) async {
    try {
      final result = (await profileService.getUserLists(id));
      return result
              ?.map(
                (e) => ListBaseModel.fromJson(e, previewPrimary: true),
              )
              .toList() ??
          [];
    } catch (e) {
      Logger.e('Ошибка при получении списков $e');
    }
    return [];
  }
}
