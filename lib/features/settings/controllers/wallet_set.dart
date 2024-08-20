import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/settings/state_holders/change_wallet_state_holder.dart';

final changeWalletControllerProvider = Provider<ChangeWalletController>(
  (ref) => ChangeWalletController(
    changeWalletStateHolder:
        ref.watch(changeWalletStateHolderProvider.notifier),
    changeWalletCodeStateHolder:
        ref.watch(changeWalletStateHolderProvider.notifier),
  ),
);

class ChangeWalletController {
  const ChangeWalletController({
    required this.changeWalletStateHolder,
    required this.changeWalletCodeStateHolder,
  });

  final ChangeWalletStateHolder changeWalletStateHolder;
  final ChangeWalletStateHolder changeWalletCodeStateHolder;

  Future<void> updateWallet(String value) async {
    changeWalletStateHolder.setWallet(value);
  }
}
