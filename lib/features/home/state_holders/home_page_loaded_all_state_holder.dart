import 'package:flutter_riverpod/flutter_riverpod.dart';

final homePageLoadedAllStateHolderProvider =
    StateNotifierProvider<HomePageLoadedAllStateHolder, bool>(
  (ref) => HomePageLoadedAllStateHolder(false),
);

class HomePageLoadedAllStateHolder extends StateNotifier<bool> {
  HomePageLoadedAllStateHolder(bool loaded) : super(loaded);

  Future<void> updateState(bool loaded) async {
    state = loaded;
  }
}
