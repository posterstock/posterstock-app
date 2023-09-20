import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';

final userListStateHolderProvider =
    StateNotifierProvider<UserListStateHolder, List<UserDetailsModel>?>(
  (ref) => UserListStateHolder(null),
);

class UserListStateHolder extends StateNotifier<List<UserDetailsModel>?> {
  UserListStateHolder(super.state);

  Future<void> setState(List<UserDetailsModel>? users) async {
    state = [...?state, ...?users];
  }

  Future<void> clearState() async {
    state = null;
  }
}
