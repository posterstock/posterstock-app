import 'package:flutter/material.dart';
import 'package:poster_stock/features/home/models/nft.dart';
import 'package:poster_stock/features/home/models/post_base_model.dart';
import 'package:poster_stock/features/home/models/user_model.dart';

class PostMovieModel extends PostBaseModel {
  final String imagePath;
  final bool? hasBookmarked;
  final bool? hasInCollection;
  final String? tmdbLink;
  final String? mediaType;
  final int? mediaId;
  final int startYear;
  final int? endYear;

  PostMovieModel({
    required this.imagePath,
    this.hasBookmarked,
    this.hasInCollection,
    this.tmdbLink,
    this.mediaId,
    this.mediaType,
    required this.startYear,
    this.endYear,
    int? creationTime,
    required int id,
    required String name,
    required UserModel author,
    required bool liked,
    required String? type,
    int likes = 0,
    int comments = 0,
    String? description,
    required bool isArtist,
    required NftForPoster nft,
    required bool isNft,
    required bool isSale,
  }) : super(
          type: type,
          id: id,
          name: name,
          author: author,
          creationTime: creationTime,
          likes: likes,
          comments: comments,
          description: description,
          liked: liked,
          isArtist: isArtist,
          nft: nft,
          isNft: isNft,
          isSale: isSale,
        );

  get year => endYear == null || endYear == 0
      ? startYear.toString()
      : '${startYear.toString()}  - ${endYear.toString()}';

  factory PostMovieModel.fromJson(Map<String, dynamic> json,
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
    final imagePath = previewPrimary
        ? (json['preview_image'] as String? ?? json['image'] as String?)
        : (json['image'] as String? ?? json['preview_image'] as String?);
    return PostMovieModel(
      type: json['type'],
      id: json['id'] as int? ?? -1,
      liked: json['has_liked'] as bool? ?? false,
      hasBookmarked: json['has_bookmarked'] as bool?,
      hasInCollection: false,
      startYear: json['start_year'],
      endYear: json['end_year'],
      imagePath: imagePath ?? '',
      name: json['title'] as String,
      author: json['user'] == null
          ? UserModel(
              id: json['user_id'] as int? ?? 0,
              name: json['name'] as String? ?? '',
              username: json['username'] as String? ?? '',
              imagePath: (json['profile_image'] as String?) ==
                      "https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp"
                  ? null
                  : json['profile_image'] as String?,
              followed: !(json['is_suggested'] as bool? ??
                  !(json['is_following'] as bool? ?? false)),
              color: avatar[(json['user_id'] as int? ?? 0) % 3],
              isArtist: json['isArtist'] ?? false,
            )
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      creationTime: json['created_at'],
      likes: json['likes_count'] as int? ?? 0,
      comments: json['comments_count'] as int? ?? 0,
      description: json['description'] as String?,
      tmdbLink: json['tmdb_link'] as String?,
      mediaId: json['media_id'] as int?,
      mediaType: json['media_type'] as String?,
      isArtist: json['isArtist'] ?? false,
      nft: nft,
      isNft: isNft,
      isSale: json['isSale'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'id': id,
        'has_liked': liked,
        'has_bookmarked': hasBookmarked,
        'start_year': startYear,
        'end_year': endYear,
        'image': imagePath,
        'title': name,
        'description': description,
        'tmdb_link': tmdbLink,
        'media_id': mediaId,
        'media_type': mediaType,
        'likes_count': likes,
        'created_at': creationTime,
        'comments_count': comments,
        'user': author.toJson(),
        'isArtist': isArtist,
        'nft': nft.toJson(),
        'isNft': isNft,
        'isSale': isSale,
      };

  @override
  PostMovieModel copyWith({
    int? startYear,
    int? endYear,
    String? imagePath,
    int? id,
    String? type,
    String? name,
    UserModel? author,
    int? creationTime,
    bool? liked,
    int? likes,
    int? comments,
    String? description,
    bool? hasBookmarked,
    bool? hasInCollection,
    bool? isArtist,
    NftForPoster? nft,
    bool? isNft,
    bool? isSale,
  }) {
    return PostMovieModel(
      type: type ?? this.type,
      startYear: startYear ?? this.startYear,
      endYear: endYear ?? this.endYear,
      hasBookmarked: hasBookmarked ?? this.hasBookmarked,
      hasInCollection: hasInCollection ?? this.hasInCollection,
      imagePath: imagePath ?? this.imagePath,
      id: id ?? this.id,
      name: name ?? this.name,
      author: author ?? this.author,
      creationTime: creationTime ?? this.creationTime,
      liked: liked ?? this.liked,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      description: description ?? this.description,
      mediaId: mediaId,
      mediaType: mediaType,
      tmdbLink: tmdbLink,
      isArtist: isArtist ?? this.isArtist,
      isNft: isNft ?? this.isNft,
      nft: nft ?? this.nft,
      isSale: isSale ?? this.isSale,
    );
  }
}
