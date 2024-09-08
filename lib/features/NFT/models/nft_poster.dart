import 'package:poster_stock/features/NFT/models/nft_model.dart';
import 'package:poster_stock/features/home/models/post_base_model.dart';
import 'package:poster_stock/features/home/models/user_model.dart';

class NFTPoster extends PostBaseModel {
  final NFTModel nft;
  NFTPoster({
    required super.comments,
    required super.creationTime,
    required super.description,
    required super.id,
    required super.liked,
    required super.likes,
    required super.name,
    required super.author,
    required super.type,
    required this.nft,
    required super.isArtist,
  });

  Map<String, dynamic> toJson() => {
        'comments': comments,
        'creationTime': creationTime,
        'description': description,
        'liked': liked,
        'likes': likes,
        'name': name,
        'type': type,
        'nft': nft.toJson(),
        'isArtist': isArtist,
      };

  factory NFTPoster.fromJson(Map<String, dynamic> json) {
    return NFTPoster(
      id: json['id'],
      comments: json['comments'],
      creationTime: json['creationTime'],
      description: json['description'],
      liked: json['liked'],
      likes: json['likes'],
      name: json['name'],
      type: json['type'],
      nft: NFTModel.fromJson(json['nft']),
      author: UserModel.fromJson(json['author']),
      isArtist: json['isArtist'],
    );
  }
  @override
  NFTPoster copyWith({
    int? id,
    UserModel? user,
    int? allCount,
    int? item,
    int? comments,
    int? creationTime,
    String? description,
    bool? liked,
    int? likes,
    String? name,
    String? type,
    UserModel? owner,
    UserModel? author,
    NFTModel? nft,
    bool? isArtist,
  }) =>
      NFTPoster(
        id: id ?? this.id,
        comments: comments ?? this.comments,
        creationTime: creationTime ?? this.creationTime,
        description: description ?? this.description,
        liked: liked ?? this.liked,
        likes: likes ?? this.likes,
        name: name ?? this.name,
        type: type ?? this.type,
        author: author ?? this.author,
        nft: nft ?? this.nft,
        isArtist: isArtist ?? this.isArtist,
      );
  // конструктор для создания NFTPoster из PostBaseModel
  factory NFTPoster.fromBaseModel({
    required PostBaseModel model,
    required NFTModel nft,
  }) =>
      NFTPoster(
        nft: nft,
        comments: model.comments,
        creationTime: model.creationTime,
        description: model.description,
        id: model.id,
        liked: model.liked,
        likes: model.likes,
        name: model.name,
        author: model.author,
        type: model.type,
        isArtist: model.isArtist,
      );
}
