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

  UsersListController({
    required this.userListStateHolder,
  });

  void clearUsers() {
    userListStateHolder.clearState();
  }

  Future<void> getUsers({
    bool followers = false,
    required int id,
  }) async {
    final users = await usersListRepository.getPosts(
      followers: followers,
      id: id,
    );
    userListStateHolder.setState(users);
  }
}
