/// NFT для постера
class NftForPoster {
  final String chain;
  final String collection;
  final String nft;

  NftForPoster({
    required this.chain,
    required this.collection,
    required this.nft,
  });

  factory NftForPoster.fromJson(Map<String, dynamic> json) {
    return NftForPoster(
      chain: json['chain'],
      collection: json['collection'],
      nft: json['nft'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'chain': chain,
      'collection': collection,
      'nft': nft,
    };
  }

  NftForPoster copyWith({
    String? chain,
    String? collection,
    String? nft,
  }) {
    return NftForPoster(
      chain: chain ?? this.chain,
      collection: collection ?? this.collection,
      nft: nft ?? this.nft,
    );
  }

  factory NftForPoster.init() {
    return NftForPoster(
      chain: '',
      collection: '',
      nft: '',
    );
  }

  get isNft => chain.isNotEmpty;
}
