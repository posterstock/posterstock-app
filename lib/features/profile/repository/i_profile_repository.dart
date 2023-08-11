import 'package:poster_stock/features/home/models/multiple_post_model.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/home/models/user_model.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';

abstract class IProfileRepository {
  Future<UserDetailsModel> getProfileInfo(int? id);

  Future<List<PostMovieModel>?> getProfilePosts(int? id);

  Future<List<MultiplePostModel>?> getProfileLists(int? id);

  Future<void> follow(int? id, bool follow);
}
