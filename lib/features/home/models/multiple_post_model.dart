import 'package:flutter/material.dart';
import 'package:poster_stock/features/home/models/nft.dart';
import 'package:poster_stock/features/home/models/post_base_model.dart';
import 'package:poster_stock/features/home/models/user_model.dart';

class MultiplePostSingleModel {
  final int id;
  final int startYear;
  final int? endYear;
  final String image;
  final String title;
  final String? description;
  final NftForPoster nft;
  final bool isNft;

  MultiplePostSingleModel({
    required this.id,
    required this.startYear,
    this.endYear,
    required this.image,
    required this.title,
    this.description,
    required this.nft,
    required this.isNft,
  });

  factory MultiplePostSingleModel.fromJson(Map<String, dynamic> json) {
    NftForPoster nft = NftForPoster.init();
    if (json['nft'] != null) {
      nft = NftForPoster.fromJson(json['nft'] as Map<String, dynamic>);
    }
    return MultiplePostSingleModel(
      id: json['id'] as int,
      startYear: json['start_year'],
      endYear: json['end_year'],
      image: json['preview_image'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      nft: nft,
      isNft: nft.isNft,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'start_year': startYear,
        'end_year': endYear,
        'description': description,
        'preview_image': image,
        'title': title,
        'nft': nft.toJson(),
        'isNft': isNft,
      };
}

class MultiplePostModel extends PostBaseModel {
  final List<MultiplePostSingleModel> posters;
  final String? image;

  MultiplePostModel({
    required this.posters,
    this.image,
    required String name,
    required bool isArtist,
    required bool isNft,
    required NftForPoster nft,
    required UserModel author,
    required int? creationTime,
    required int id,
    required bool liked,
    required String? type,
    int likes = 0,
    int comments = 0,
    String? description,
  }) : super(
          type: type,
          id: id,
          name: name,
          author: author,
          creationTime: creationTime,
          likes: likes,
          liked: liked,
          comments: comments,
          description: description,
          isArtist: isArtist,
          isNft: isNft,
          nft: nft,
        );

  factory MultiplePostModel.fromJson(Map<String, dynamic> json,
      {bool previewPrimary = false}) {
    NftForPoster nft = NftForPoster.init();
    bool isNft = false;
    if (json['nft'] != null) {
      nft = NftForPoster.fromJson(json['nft'] as Map<String, dynamic>);
      isNft = true;
    }
    if (json['chain'] != null) {
      nft = NftForPoster.fromChain(json['chain']);
      isNft = true;
    }
    const List<Color> avatar = [
      Color(0xfff09a90),
      Color(0xfff3d376),
      Color(0xff92bdf4),
    ];
    final img = (previewPrimary
            ? (json['preview_image'] as String? ?? json['image'] as String?)
            : (json['image'] as String? ?? json['preview_image'] as String?)) ??
        '';
    final image = img == 'https://api.posterstock.com/images/'
        ? 'https://api.posterstock.com/images/default_list_cover.png'
        : img;
    return MultiplePostModel(
      type: json['type'],
      id: json['id'] as int,
      name: json['title'] as String,
      liked: json['has_liked'] as bool,
      author: json['user'] == null
          ? UserModel(
              id: json['user_id'] as int? ?? 0,
              name: json['name'] as String? ?? '',
              username: json['username'] as String? ?? '',
              imagePath: (json['profile_image'] as String?) ==
                      "https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp"
                  ? null
                  : json['profile_image'] as String?,
              followed: !(json['is_suggested'] as bool? ?? true),
              color: avatar[(json['user_id'] as int? ?? 0) % 3],
            )
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      creationTime: json['created_at'],
      likes: json['likes_count'] as int,
      comments: json['comments_count'] as int,
      description: json['description'] as String?,
      posters: (json['posters'] as List<dynamic>?)
              ?.map(
                (e) => MultiplePostSingleModel.fromJson(e),
              )
              .toList() ??
          [],
      image: image,
      nft: nft,
      isNft: isNft,
      isArtist: json['isArtist'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'id': id,
        'has_liked': liked,
        'title': name,
        'description': description,
        'likes_count': likes,
        'comments_count': comments,
        'user': author.toJson(),
        'image': image,
        'created_at': creationTime,
        'posters': posters.map((i) => i.toJson()).toList(),
        'isArtist': isArtist,
        'nft': nft.toJson(),
        'isNft': isNft,
      };

  @override
  MultiplePostModel copyWith({
    int? id,
    String? type,
    String? name,
    UserModel? author,
    int? creationTime,
    String? description,
    int? likes,
    int? comments,
    bool? liked,
    String? image,
    bool? isArtist,
    NftForPoster? nft,
    bool? isNft,
    List<MultiplePostSingleModel>? posters,
  }) {
    return MultiplePostModel(
      posters: posters ?? this.posters,
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      author: author ?? this.author,
      creationTime: creationTime ?? this.creationTime,
      description: description ?? this.description,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      liked: liked ?? this.liked,
      image: image ?? this.image,
      isArtist: isArtist ?? this.isArtist,
      nft: nft ?? this.nft,
      isNft: isNft ?? this.isNft,
    );
  }
}
