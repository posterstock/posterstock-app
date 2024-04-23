import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/account/account_cache.dart';
import 'package:poster_stock/features/account/account_network.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';

final accountNotifier =
    StateNotifierProvider.autoDispose<AccountNotifier, UserDetailsModel?>(
  (ref) => AccountNotifier()..load(),
);

class AccountNotifier extends StateNotifier<UserDetailsModel?> {
  final AccountNetwork network = AccountNetwork();
  final AccountCache cache = AccountCache();

  AccountNotifier() : super(null);

  UserDetailsModel? get account => state;

  Future<void> load() async {
    state = await cache.getProfileInfo();
    state = await network.getProfileInfo();
    cache.cacheProfileInfo(state!);
  }
}
