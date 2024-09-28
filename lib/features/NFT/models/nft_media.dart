import 'package:poster_stock/features/NFT/models/nft_model.dart';
import 'package:poster_stock/features/home/models/nft.dart';
import 'package:poster_stock/features/poster_dialog/model/media_model.dart';

class NFTMedia extends MediaModel {
  NFTMedia({
    required super.id,
    required super.title,
    required super.type,
    required super.startYear,
    required super.endYear,
    required super.isNft,
    required super.nft,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type.toString(),
        'startYear': startYear,
        'endYear': endYear,
        'nft': nft.toJson(),
      };

  factory NFTMedia.fromJson(Map<String, dynamic> json) {
    return NFTMedia(
      id: json['id'] as int,
      title: json['title'] as String,
      type: json['type'] == 'tv' ? MediaType.tv : MediaType.movie,
      startYear: json['start_year'] as int,
      endYear: json['end_year'] as int?,
      isNft: json['is_nft'] == null ? false : json['is_nft'] as bool,
      nft: json['nft'] == null
          ? NftForPoster.init()
          : json['nft'] as NftForPoster,
    );
  }

  // конструктор для создания NFTMedia из MediaModel
  factory NFTMedia.fromMediaModel({
    required MediaModel model,
    required NFTModel nft,
  }) =>
      NFTMedia(
        id: model.id,
        title: model.title,
        type: model.type,
        startYear: model.startYear,
        endYear: model.endYear,
        isNft: model.isNft,
        nft: model.nft,
      );
}
