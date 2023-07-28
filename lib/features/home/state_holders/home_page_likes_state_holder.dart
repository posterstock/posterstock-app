import 'package:flutter_riverpod/flutter_riverpod.dart';

final homePageLikesStateHolderProvider =
StateNotifierProvider<HomePageLikesStateHolder, List<(bool, int)>?>(
      (ref) => HomePageLikesStateHolder(null),
);

class HomePageLikesStateHolder
    extends StateNotifier<List<(bool, int)>?> {
  HomePageLikesStateHolder(super.state);

  Future<void> setState(List<(bool, int)>? posts) async {
    state = posts;
  }
}
