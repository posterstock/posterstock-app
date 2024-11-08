/// NFT для постера
class NftForPoster {
  final String chain;

  ///  токен
  final String collection;

  /// название коллекции
  final String nft;

  ///  название
  final int number;

  ///  какой по счету
  final int allCount;

  ///  всего количество нфт
  final double price;

  ///  стоимосить в токенах
  final double priceReal;

  ///  коммиссия
  final double fee;

  /// в чем прайс
  final String blocChain;

  /// адрес коллекции
  final String contractAdress;

  /// адрес нфт
  final String nftAddress;

  /// комиссия сервиса
  final double serviceFee;

  /// роялти
  final double royalty;

  NftForPoster({
    required this.chain,
    required this.collection,
    required this.nft,
    required this.number,
    required this.allCount,
    required this.price,
    required this.priceReal,
    required this.fee,
    required this.blocChain,
    required this.contractAdress,
    required this.serviceFee,
    required this.royalty,
    required this.nftAddress,
  });

  factory NftForPoster.fromJson(Map<String, dynamic> json) {
    // Logger.i('json $json');
    // for (var item in json.entries) {
    //   print('-----------------------------------------------------');
    //   print(
    //       'item >>>>>>>>>>>>>>>>>> ${item.key} ==== ${item.value.runtimeType} === ${item.value}');
    //   print('-----------------------------------------------------');
    // }

    return NftForPoster(
      chain: json['chain'] ?? '',
      collection: json['collection'] ?? '',
      nft: json['nft'] ?? '',
      number: json['number'] ?? 0,
      allCount: json['all_count'] ?? 0,
      price: json['price'] ?? 0,
      priceReal: json['priceReal'] ?? 0,
      fee: json['fee'] ?? 0.3,
      blocChain: json['blocChain'] ?? '',
      contractAdress: json['address'] ?? '',
      serviceFee: json['serviceFee'] ?? 0,
      royalty: json['royalty'] ?? 0,
      nftAddress: json['nft_address'] ?? '',
    );
  }
  factory NftForPoster.fromChain(String chain) {
    return NftForPoster(
      chain: chain,
      collection: '',
      nft: '',
      number: 0,
      allCount: 0,
      price: 0,
      priceReal: 0,
      fee: 0.3,
      blocChain: 'TON',
      contractAdress: '',
      serviceFee: 0,
      royalty: 0,
      nftAddress: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chain': chain,
      'collection': collection,
      'nft': nft,
      'number': number,
      'all_count': allCount,
      'price': price,
      'priceReal': priceReal,
      'fee': fee,
      'blocChain': blocChain,
      'address': contractAdress,
      'serviceFee': serviceFee,
      'royalty': royalty,
      'nft_address': nftAddress,
    };
  }

  NftForPoster copyWith({
    String? chain,
    String? collection,
    String? nft,
    int? number,
    int? allCount,
    double? price,
    double? priceReal,
    double? fee,
    String? blocChain,
    String? address,
    double? serviceFee,
    double? royalty,
    String? nftAddress,
  }) {
    return NftForPoster(
      chain: chain ?? this.chain,
      collection: collection ?? this.collection,
      nft: nft ?? this.nft,
      number: number ?? this.number,
      allCount: allCount ?? this.allCount,
      price: price ?? this.price,
      priceReal: priceReal ?? this.priceReal,
      fee: fee ?? this.fee,
      blocChain: blocChain ?? this.blocChain,
      contractAdress: address ?? this.contractAdress,
      serviceFee: serviceFee ?? this.serviceFee,
      royalty: royalty ?? this.royalty,
      nftAddress: nftAddress ?? this.nftAddress,
    );
  }

  factory NftForPoster.init() {
    return NftForPoster(
      chain: '',
      collection: '',
      nft: '',
      number: 0,
      allCount: 0,
      price: 0,
      priceReal: 0,
      fee: 0.3,
      blocChain: 'TON',
      contractAdress: '',
      serviceFee: 0,
      royalty: 0,
      nftAddress: '',
    );
  }
}
