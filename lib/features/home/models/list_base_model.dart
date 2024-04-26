import 'package:poster_stock/features/home/models/user_model.dart';

class ListBaseModel {
  final int id;
  final String title;
  final String image;
  final UserModel? user;
  final int? postersCount;

  ListBaseModel({
    required this.id,
    required this.title,
    required this.image,
    this.postersCount,
    this.user,
  });

  factory ListBaseModel.fromJson(Map<String, dynamic> json,
      {bool previewPrimary = false}) {
    final image = (previewPrimary
            ? (json['preview_image'] as String? ?? json['image'] as String?)
            : (json['image'] as String? ?? json['preview_image'] as String?)) ??
        '';
    return ListBaseModel(
      id: json['id'],
      title: json['title'],
      image: image == 'https://api.posterstock.com/images/'
          ? 'https://api.posterstock.com/images/default_list_cover.png'
          : image,
      postersCount: json['posters_count'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'image': image,
        'posters_count': postersCount,
      };

  ListBaseModel copyWith({
    int? id,
    String? title,
    String? image,
    UserModel? user,
  }) {
    return ListBaseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      user: user ?? this.user,
    );
  }
}
