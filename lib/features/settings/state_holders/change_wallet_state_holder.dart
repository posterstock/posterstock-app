import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/NFT/models/wallet_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

final changeWalletStateHolderProvider =
    StateNotifierProvider<ChangeWalletStateHolder, WalletState>(
  (ref) => ChangeWalletStateHolder(WalletState.init()),
);

class ChangeWalletStateHolder extends StateNotifier<WalletState> {
  ChangeWalletStateHolder(
    WalletState state,
  ) : super(state) {
    loadFromLocal(); // Загрузка из локалки при инициализации
  }

  void setWallet(String wallet) {
    state = state.copyWith(original: state, wallet: wallet);
    saveToLocal();
  }

  void setNetworkType(NetworkType type) {
    state = state.copyWith(original: state, networkType: type);
    saveToLocal();
  }

  void setBlockchain(Blockchain blockchain) {
    state = state.copyWith(original: state, blockchain: blockchain);
    saveToLocal();
  }

  Future<void> saveToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(state.toJson());
    await prefs.setString('walletState', jsonString);
  }

  Future<void> loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('walletState');
    if (jsonString != null) {
      final jsonMap = json.decode(jsonString);
      state = WalletState.fromJson(jsonMap); // Конвертация из JSON
    } else {
      state = WalletState.init();
      saveToLocal();
    }
  }
}
