import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';

final searchUsersStateHolderProvider =
StateNotifierProvider<SearchUsersStateHolder, List<UserDetailsModel>?>(
      (ref) => SearchUsersStateHolder(null),
);

class SearchUsersStateHolder extends StateNotifier<List<UserDetailsModel>?> {
  SearchUsersStateHolder(super.state);

  void updateState(List<UserDetailsModel>? newValue) {
    state = [...?state, ...?newValue];
  }

  void setState(List<UserDetailsModel>? newValue) {
    state = newValue;
  }
}
