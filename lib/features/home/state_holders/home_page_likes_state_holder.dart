import 'package:flutter_riverpod/flutter_riverpod.dart';

final homePageLikesStateHolderProvider =
StateNotifierProvider<HomePageLikesStateHolder, List<List<(bool, int)>>?>(
      (ref) => HomePageLikesStateHolder(null),
);

class HomePageLikesStateHolder
    extends StateNotifier<List<List<(bool, int)>>?> {
  HomePageLikesStateHolder(super.state);

  Future<void> setState(List<List<(bool, int)>>? posts) async {
    state = posts;
  }
}
