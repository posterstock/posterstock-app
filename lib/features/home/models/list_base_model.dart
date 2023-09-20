import 'package:poster_stock/features/home/models/user_model.dart';

class ListBaseModel {
  final int id;
  final String title;
  final String image;
  final UserModel? user;

  ListBaseModel({
    required this.id,
    required this.title,
    required this.image,
    this.user,
  });

  factory ListBaseModel.fromJson(Map<String, dynamic> json, {bool previewPrimary = false}) {
    final image = (previewPrimary ?
    (json['preview_image'] as String? ?? json['image'] as String?) : (json['image'] as String? ?? json['preview_image'] as String?)) ?? '';
    return ListBaseModel(
      id: json['id'],
      title: json['title'],
      image: image == 'https://api.posterstock.co/images/' ? 'https://api.posterstock.co/images/default_list_cover.png' : image,
    );
  }

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
