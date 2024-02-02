import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/user/notifiers/user_lists_notifier.dart';
import 'package:poster_stock/features/user/notifiers/user_notifier.dart';
import 'package:poster_stock/features/user/notifiers/user_posters_notifier.dart';

final userControllerProvider = Provider.family.autoDispose<UserController, int>(
  (ref, id) => UserController(
    id,
    ref.read(userNotifier(id).notifier),
    ref.read(userPostersNotifier(id).notifier),
    ref.read(userListsStateNotifier(id).notifier),
  ),
);

class UserController {
  final int userId;
  final UserNotifier userNotifier;
  final UserPostersNotifier userPostersNotifier;
  final UserListsNotifier userListsNotifier;

  UserController(
    this.userId,
    this.userNotifier,
    this.userPostersNotifier,
    this.userListsNotifier,
  );
}
