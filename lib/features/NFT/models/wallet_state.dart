/// класс для кошелька
class WalletState {
  final String wallet;
  final NetworkType networkType;
  final Blockchain blockchain;

  WalletState(
      {required this.wallet,
      required this.networkType,
      required this.blockchain});

  factory WalletState.fromJson(Map<String, dynamic> json) {
    return WalletState(
      wallet: json['wallet'] ?? '',
      networkType: json['networkType'] == null
          ? NetworkType.testnet
          : NetworkType.values.byName(json['networkType']),
      blockchain: json['blockchain'] == null
          ? Blockchain.ton
          : Blockchain.values.byName(json['blockchain']),
    );
  }

  factory WalletState.init() {
    return WalletState(
      wallet: '',
      networkType: NetworkType.testnet,
      blockchain: Blockchain.ton,
    );
  }

  WalletState copyWith({
    WalletState? original,
    String? wallet,
    NetworkType? networkType,
    Blockchain? blockchain,
  }) {
    return WalletState(
      wallet: wallet ?? original?.wallet ?? '',
      networkType: networkType ?? original?.networkType ?? NetworkType.testnet,
      blockchain: blockchain ?? original?.blockchain ?? Blockchain.ton,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wallet': wallet,
      'networkType': networkType.name,
      'blockchain': blockchain.name,
    };
  }
}

enum Blockchain {
  ton; // The Open Network (TON)

  // Добавьте другие блокчейны по мере необходимости
  String get name => switch (this) {
        Blockchain.ton => 'TON',
      };
}

enum NetworkType {
  mainnet, // Основная сеть
  testnet, // Тестовая сеть
}
