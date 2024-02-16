import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/account/account_network.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';

final accountNotifier =
    StateNotifierProvider<AccountNotifier, UserDetailsModel?>(
  (ref) => AccountNotifier().._init(),
);

class AccountNotifier extends StateNotifier<UserDetailsModel?> {
  final AccountNetwork network = AccountNetwork();

  AccountNotifier() : super(null);

  UserDetailsModel? get account => state;

  Future<void> _init() async {
    state = await network.getProfileInfo();
  }
}
