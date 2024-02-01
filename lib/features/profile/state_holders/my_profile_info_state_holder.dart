import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';

final myProfileInfoStateHolderProvider =
    StateNotifierProvider<MyProfileInfoStateHolder, UserDetailsModel?>(
  (ref) => MyProfileInfoStateHolder(null),
);

class MyProfileInfoStateHolder extends StateNotifier<UserDetailsModel?> {
  MyProfileInfoStateHolder(super.state);

  void updateState(UserDetailsModel? user) {
    state = user;
  }

  Future<void> clearState() async {
    state = null;
  }
}
