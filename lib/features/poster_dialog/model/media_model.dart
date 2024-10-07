import 'package:poster_stock/features/home/models/nft.dart';

enum MediaType {
  movie,
  tv,
}

class MediaModel {
  int id;
  int startYear;
  int? endYear;
  String title;
  MediaType type;
  final NftForPoster nft;

  MediaModel({
    required this.id,
    required this.title,
    required this.type,
    required this.startYear,
    required this.endYear,
    required this.nft,
  });

  bool get isNft => nft.chain.isNotEmpty;

  factory MediaModel.fromJson(Map<String, Object?> json) {
    return MediaModel(
      id: json['id'] as int,
      title: json['title'] as String,
      type: json['type'] == 'tv' ? MediaType.tv : MediaType.movie,
      startYear: json['start_year'] as int,
      endYear: json['end_year'] as int?,
      nft: json['nft'] == null
          ? NftForPoster.init()
          : json['nft'] as NftForPoster,
    );
  }
  toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'start_year': startYear,
      'end_year': endYear,
      'nft': nft.toJson(),
    };
  }
}
