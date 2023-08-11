import 'package:poster_stock/features/home/models/multiple_post_model.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';
import 'package:poster_stock/features/profile/repository/i_profile_repository.dart';

import '../data/profile_service.dart';

class ProfileRepository implements IProfileRepository {
  final profileService = ProfileService();

  @override
  Future<UserDetailsModel> getProfileInfo(int? id) async {
    final result = (await profileService.getProfileInfo(id));
    return UserDetailsModel.fromJson(result);
  }

  @override
  Future<void> follow(int? id, bool follow) async {
    await profileService.follow(id, follow);
  }

  @override
  Future<List<PostMovieModel>> getProfilePosts(int? id) async {
    try {
      final result = (await profileService.getUserPosts(id));
      return result
          .map(
            (e) => PostMovieModel.fromJson(e),
          )
          .toList();
    } catch (e) {
      print(e);
    }
    return [];
  }

  @override
  Future<List<MultiplePostModel>?> getProfileLists(int? id) async {
    try {
      final result = (await profileService.getUserLists(id));
      return result
          .map(
            (e) => MultiplePostModel.fromJson(e),
          )
          .toList();
    } catch (e) {
      print(e);
    }
    return [];
  }
}
