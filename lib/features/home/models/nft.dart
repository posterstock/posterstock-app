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

  ///  на продажу или нет
  final bool isSale;

  /// в чем прайс
  final String blocChain;

  NftForPoster({
    required this.chain,
    required this.collection,
    required this.nft,
    required this.number,
    required this.allCount,
    required this.price,
    required this.priceReal,
    required this.fee,
    required this.isSale,
    required this.blocChain,
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
      isSale: json['isSale'] != null,
      blocChain: json['blocChain'] ?? '',
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
      isSale: false,
      blocChain: 'TON',
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
      'isSale': isSale,
      'blocChain': blocChain,
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
    bool? isSale,
    String? blocChain,
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
      isSale: isSale ?? this.isSale,
      blocChain: blocChain ?? this.blocChain,
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
        isSale: false,
        blocChain: 'TON');
  }

  get isNft => chain.isNotEmpty;
}
