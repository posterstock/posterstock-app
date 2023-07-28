import 'package:poster_stock/features/home/models/multiple_post_model.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/home/models/user_model.dart';
import 'package:poster_stock/features/profile/data/mock_profile_service.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';
import 'package:poster_stock/features/profile/repository/i_profile_repository.dart';

import '../data/profile_service.dart';

class ProfileRepository implements IProfileRepository {
  final profileService = ProfileService();

  @override
  Future<UserDetailsModel> getProfileInfo(String token, int id) async {
    final result = (await profileService.getProfileInfo(token, id));
    return UserDetailsModel.fromJson(result);
  }

  @override
  Future<List<MultiplePostModel>?> getProfileLists(String token, int id) async {
    // TODO: implement getProfileLists
    throw UnimplementedError();
  }

  @override
  Future<List<PostMovieModel>?> getProfilePosts(String token, int id) async {
    // TODO: implement getProfilePosts
    throw UnimplementedError();
  }
}
