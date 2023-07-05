import 'package:flutter_riverpod/flutter_riverpod.dart';

final bookmarksChosenPosterStateHolderProvider =
    StateNotifierProvider<BookmarksChosenPosterStateHolder, (int, String)?>(
  (ref) => BookmarksChosenPosterStateHolder(null),
);

class BookmarksChosenPosterStateHolder extends StateNotifier<(int, String)?> {
  BookmarksChosenPosterStateHolder(super.state);

  void updateState((int, String)? poster) {
    state = poster;
  }
}
