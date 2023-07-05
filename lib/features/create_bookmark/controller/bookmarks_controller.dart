import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/create_bookmark/state_holders/bookmarks_chosen_poster_state_holder.dart';

final bookmarksControllerProvider = Provider<BookmarksController>(
  (ref) => BookmarksController(
    bookmarksChosenPosterStateHolder:
        ref.watch(bookmarksChosenPosterStateHolderProvider.notifier),
  ),
);

class BookmarksController {
  final BookmarksChosenPosterStateHolder bookmarksChosenPosterStateHolder;

  BookmarksController({required this.bookmarksChosenPosterStateHolder});

  void updatePoster((int, String) poster) {
    bookmarksChosenPosterStateHolder.updateState(poster);
  }

  void clearPoster() {
    bookmarksChosenPosterStateHolder.updateState(null);
  }
}
