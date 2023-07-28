import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/home/models/user_model.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';

final profileInfoStateHolderProvider =
    StateNotifierProvider<ProfileInfoStateHolder, UserDetailsModel?>(
  (ref) => ProfileInfoStateHolder(null),
);

class ProfileInfoStateHolder extends StateNotifier<UserDetailsModel?> {
  ProfileInfoStateHolder(super.state);

  void updateState(UserDetailsModel? user) {
    state = user;
  }

  void clearState() {
    state = null;
  }
}
