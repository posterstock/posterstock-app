import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/account/notifiers/account_notifier.dart';
import 'package:poster_stock/features/account/notifiers/bookmarks_notifier.dart';
import 'package:poster_stock/features/account/notifiers/lists_notifier.dart';
import 'package:poster_stock/features/account/notifiers/posters_notifier.dart';

final accountControllerProvider = Provider<AccountController>(
  (ref) => AccountController(
    ref.read(accountNotifier.notifier),
    ref.read(accountPostersStateNotifier.notifier),
    ref.read(accountBookmarksStateNotifier.notifier),
    ref.read(accountListsStateNotifier.notifier),
  ).._init(),
);

class AccountController {
  final AccountNotifier account;
  final PostersNotifier posters;
  final BookmarksNotifier bookmarks;
  final ListsNotifier lists;

  AccountController(
    this.account,
    this.posters,
    this.bookmarks,
    this.lists,
  );

  Future<void> _init() async {
    await account.init();
    posters.load(account.account!.id);
    bookmarks.load();
    lists.load(account.account!.id);
  }

  void loadMorePosters() {
    posters.loadMore(account.account!.id);
  }

  void loadMoreBookmarks() {
    bookmarks.loadMore();
  }
}
