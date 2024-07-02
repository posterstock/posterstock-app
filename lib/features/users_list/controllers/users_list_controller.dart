import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/users_list/repository/users_list_repository.dart';
import 'package:poster_stock/features/users_list/state_hodlers/users_list_state_holder.dart';

final usersListControllerProvider = Provider<UsersListController>(
  (ref) => UsersListController(
    userListStateHolder: ref.watch(userListStateHolderProvider.notifier),
  ),
);

class UsersListController {
  final UserListStateHolder userListStateHolder;
  final usersListRepository = UsersListRepository();
  bool gotAll = false;
  bool? followers;
  int? id;
  bool loading = false;

  UsersListController({
    required this.userListStateHolder,
  });

  void clearUsers() {
    userListStateHolder.clearState();
    usersListRepository.clear();
    loading = false;
    id = null;
    followers = null;
  }

  Future<void> getUsers({
    bool followers = false,
    required int id,
  }) async {
    if (loading) return;
    loading = true;
    if (this.id != id || followers != this.followers) {
      gotAll = false;
      userListStateHolder.clearState();
    }
    this.id = id;
    this.followers = followers;
    if (gotAll) return;
    final users = await usersListRepository.getPosts(
      followers: followers,
      id: id,
    );
    gotAll = users.$2;
    userListStateHolder.setState(users.$1);
    loading = false;
  }
}
