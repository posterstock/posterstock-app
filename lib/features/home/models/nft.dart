/// NFT для постера
class NftForPoster {
  final String chain;
  final String collection;
  final String nft;
  final int number;
  final int allCount;

  NftForPoster({
    required this.chain,
    required this.collection,
    required this.nft,
    required this.number,
    required this.allCount,
  });

  factory NftForPoster.fromJson(Map<String, dynamic> json) {
    return NftForPoster(
      chain: json['chain'] ?? '',
      collection: json['collection'] ?? '',
      nft: json['nft'] ?? '',
      number: json['number'] ?? 0,
      allCount: json['all_count'] ?? 0,
    );
  }
  factory NftForPoster.fromChain(String chain) {
    return NftForPoster(
      chain: chain,
      collection: '',
      nft: '',
      number: 0,
      allCount: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chain': chain,
      'collection': collection,
      'nft': nft,
      'number': number,
      'all_count': allCount,
    };
  }

  NftForPoster copyWith({
    String? chain,
    String? collection,
    String? nft,
    int? number,
    int? allCount,
  }) {
    return NftForPoster(
      chain: chain ?? this.chain,
      collection: collection ?? this.collection,
      nft: nft ?? this.nft,
      number: number ?? this.number,
      allCount: allCount ?? this.allCount,
    );
  }

  factory NftForPoster.init() {
    return NftForPoster(
      chain: '',
      collection: '',
      nft: '',
      number: 0,
      allCount: 0,
    );
  }

  get isNft => chain.isNotEmpty;
}
