import 'package:poster_stock/features/home/models/list_base_model.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';
import 'package:poster_stock/features/search/data/search_service.dart';

class SearchRepository {
  final service = SearchService();
  Future<(List<UserDetailsModel>, bool)> searchUsers(String searchValue) async {
    final apiResult = await service.searchUsers(searchValue);
    return (
      apiResult.$1?.map((e) => UserDetailsModel.fromJson(e)).toList() ?? [],
      apiResult.$2
    );
  }

  Future<(List<PostMovieModel>, bool)> searchPosts(String searchValue) async {
    final apiResult = await service.searchPosters(searchValue);
    return (
      apiResult.$1?.map((e) => PostMovieModel.fromJson(e)).toList() ?? [],
      apiResult.$2
    );
  }

  Future<(List<ListBaseModel>, bool)> searchLists(String searchValue) async {
    final apiResult = await service.searchLists(searchValue);
    return (
      apiResult.$1?.map((e) => ListBaseModel.fromJson(e)).toList() ?? [],
      apiResult.$2
    );
  }
}
