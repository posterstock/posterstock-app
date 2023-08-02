import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/home/models/multiple_post_model.dart';

final profileListsStateHolderProvider =
    StateNotifierProvider<ProfileListsStateHolder, List<MultiplePostModel>?>(
  (ref) => ProfileListsStateHolder(null),
);

class ProfileListsStateHolder extends StateNotifier<List<MultiplePostModel>?> {
  ProfileListsStateHolder(super.state);

  void updateState(List<MultiplePostModel>? list) {
    state = [...(state ?? []), ...?list];
  }

  void clearState() {
    state = null;
  }
}
