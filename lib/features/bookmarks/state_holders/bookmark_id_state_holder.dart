import 'package:flutter_riverpod/flutter_riverpod.dart';

final bookmarksIdStateHolderProvider =
    StateNotifierProvider<BookmarksIdStateHolder, int?>(
  (ref) => BookmarksIdStateHolder(null),
);

class BookmarksIdStateHolder extends StateNotifier<int?> {
  BookmarksIdStateHolder(super.state);

  void setState(int value) {
    state = value;
  }

  void clearState() {
    state = null;
  }
}
