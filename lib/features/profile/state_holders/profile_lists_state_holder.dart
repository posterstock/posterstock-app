import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/home/models/list_base_model.dart';
import 'package:poster_stock/features/home/models/multiple_post_model.dart';

final profileListsStateHolderProvider =
    StateNotifierProvider<ProfileListsStateHolder, List<ListBaseModel>?>(
  (ref) => ProfileListsStateHolder(null),
);

class ProfileListsStateHolder extends StateNotifier<List<ListBaseModel>?> {
  ProfileListsStateHolder(super.state);

  void updateState(List<ListBaseModel>? list) {
    state = [...(state ?? []), ...?list];
  }

  void setState(List<ListBaseModel>? list) {
    state = [...?list];
  }

  Future<void> clearState() async {
    state = null;
  }
}
