import 'package:poster_stock/features/profile/models/user_details_model.dart';
import 'package:poster_stock/features/users_list/data/users_list_service.dart';

class UsersListRepository {
  final UsersListService _api = UsersListService();

  Future<List<UserDetailsModel>?> getPosts({
    required String token,
    required bool followers,
    required int id,
  }) async {
    return (await _api.getPosts(
      token: token,
      followers: followers,
      id: id,
    ))
        .map(
          (e) => UserDetailsModel.fromJson(e),
        )
        .toList();
  }
}
