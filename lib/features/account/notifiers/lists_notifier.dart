import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/account/account_network.dart';
import 'package:poster_stock/features/account/notifiers/account_notifier.dart';
import 'package:poster_stock/features/home/models/list_base_model.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';

final accountListsStateNotifier =
    StateNotifierProvider.autoDispose<ListsNotifier, List<ListBaseModel?>>(
  (ref) => ListsNotifier(ref.watch(accountNotifier.notifier)).._init(),
);

class ListsNotifier extends StateNotifier<List<ListBaseModel?>> {
  ListsNotifier(this.accountNotifier) : super(List.generate(8, (_) => null));

  final AccountNotifier accountNotifier;
  final AccountNetwork network = AccountNetwork();

  UserDetailsModel? get account => accountNotifier.account;

  Future<void> _init() async {
    if (accountNotifier.account == null) return;
    load();
  }

  void load() async {
    final result = await network.getLists(account!.id);
    state = result ?? [];
  }
}
