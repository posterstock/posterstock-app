/// для обработки PosterOwner
class PosterOwner {
  final List<NFTOwner> nftOwners;
  final String collectionOwnerName;
  final String collectionOwnerImage;
  final String title;
  final int startYear;
  final int endYear;

  PosterOwner({
    required this.nftOwners,
    required this.collectionOwnerName,
    required this.collectionOwnerImage,
    required this.title,
    required this.startYear,
    required this.endYear,
  });

  factory PosterOwner.fromJson(Map<String, dynamic> json) {
    return PosterOwner(
      nftOwners: (json['nft_owners'] as List)
          .map((owner) => NFTOwner.fromJson(owner as Map<String, dynamic>))
          .toList(),
      collectionOwnerName: json['collection_owner_name'] as String,
      collectionOwnerImage: json['collection_owner_image'] as String,
      title: json['title'] as String,
      startYear: json['start_year'] as int,
      endYear: json['end_year'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nft_owners': nftOwners.map((owner) => owner.toJson()).toList(),
      'collection_owner_name': collectionOwnerName,
      'collection_owner_image': collectionOwnerImage,
      'title': title,
      'start_year': startYear,
      'end_year': endYear,
    };
  }
}

class NFTOwner {
  final int index;
  final String ownerImage;
  final String ownerName;
  final int posterId;
  final Price? price;

  NFTOwner({
    required this.index,
    required this.ownerImage,
    required this.ownerName,
    required this.posterId,
    this.price,
  });

  factory NFTOwner.fromJson(Map<String, dynamic> json) {
    return NFTOwner(
      index: json['index'] as int,
      ownerImage: json['owner_image'] as String,
      ownerName: json['owner_name'] as String,
      posterId: json['poster_id'] as int,
      price: json['price'] != null
          ? Price.fromJson(json['price'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'index': index,
      'owner_image': ownerImage,
      'owner_name': ownerName,
      'poster_id': posterId,
    };

    if (price != null) {
      data['price'] = price!.toJson();
    }

    return data;
  }
}

class Price {
  final int price;
  final String tokenName;

  Price({
    required this.price,
    required this.tokenName,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      price: (json['price'] as num).toInt(),
      tokenName: json['token_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'token_name': tokenName,
    };
  }
}
