import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/account/account_network.dart';
import 'package:poster_stock/features/home/models/list_base_model.dart';

final accountListsStateNotifier =
    StateNotifierProvider<ListsNotifier, List<ListBaseModel?>>(
  (ref) => ListsNotifier(),
);

class ListsNotifier extends StateNotifier<List<ListBaseModel?>> {
  ListsNotifier() : super(List.generate(8, (_) => null));
  final AccountNetwork network = AccountNetwork();

  void load(int id) async {
    final result = await network.getLists(id);
    state = result ?? [];
  }
}
