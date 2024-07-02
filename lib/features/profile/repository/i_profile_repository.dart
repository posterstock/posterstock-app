import 'package:poster_stock/features/home/models/list_base_model.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';

abstract class IProfileRepository {
  Future<UserDetailsModel> getProfileInfo(dynamic id);

  Future<(List<PostMovieModel>?, bool)> getProfilePosts(int? id,
      {bool restart = false});

  Future<List<ListBaseModel>?> getProfileLists(int? id);

  Future<void> follow(int? id, bool follow);

  Future<(List<PostMovieModel>?, bool)> getMyBookmarks({bool restart = false});
}
