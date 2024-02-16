import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/account/account_network.dart';
import 'package:poster_stock/features/account/notifiers/account_notifier.dart';
import 'package:poster_stock/features/home/models/list_base_model.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';

final accountListsStateNotifier =
    StateNotifierProvider<ListsNotifier, List<ListBaseModel?>>(
  (ref) => ListsNotifier(ref.watch(accountNotifier)).._init(),
);

class ListsNotifier extends StateNotifier<List<ListBaseModel?>> {
  ListsNotifier(this.account) : super(List.generate(8, (_) => null));

  final UserDetailsModel? account;
  final AccountNetwork network = AccountNetwork();

  Future<void> _init() async {
    if (account == null) return;
    load();
  }

  void load() async {
    final result = await network.getLists(account!.id);
    state = result ?? [];
  }
}
