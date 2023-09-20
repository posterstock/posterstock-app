import 'package:poster_stock/features/profile/models/user_details_model.dart';
import 'package:poster_stock/features/users_list/data/users_list_service.dart';

class UsersListRepository {
  final UsersListService _api = UsersListService();

  Future<(List<UserDetailsModel>?, bool)> getPosts({
    required bool followers,
    required int id,
  }) async {
    final result = await _api.getFollows(
      followers: followers,
      id: id,
    );
    return (
      result.$1
          .map(
            (e) => UserDetailsModel.fromJson(e),
          )
          .toList(),
      result.$2
    );
  }

  Future<void> clear() async {
    _api.followers = null;
    _api.lastId = null;
    _api.cursor = null;
    print(_api.lastId);
    print(_api.followers);
    print('end2');
  }
}
