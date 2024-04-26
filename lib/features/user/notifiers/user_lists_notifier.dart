import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/home/models/list_base_model.dart';
import 'package:poster_stock/features/user/user_cache.dart';
import 'package:poster_stock/features/user/user_network.dart';

final userListsStateNotifier = StateNotifierProvider.autoDispose
    .family<UserListsNotifier, List<ListBaseModel?>, int>(
  (ref, id) => UserListsNotifier(id).._init(),
);

class UserListsNotifier extends StateNotifier<List<ListBaseModel?>> {
  final UserNetwork network = UserNetwork();
  final UserCache cache = UserCache();
  final int id;

  UserListsNotifier(this.id) : super(List.generate(8, (_) => null));

  Future<void> _init() async {
    final cachedResult = await cache.getLists(id);
    state = cachedResult ?? [];

    final result = await network.getLists(id);
    cache.cacheLists(id, result);
    if (!mounted) return;
    state = result ?? [];
  }
}
