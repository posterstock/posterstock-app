import 'dart:typed_data';

import 'package:poster_stock/features/create_list/data/create_list_service.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';

class CreateListRepository {
  final service = CreateListService();

  Future<bool?> createList({
    required String title,
    required String description,
    required List<int> posters,
    Uint8List? image,
    bool? generated,
    int? id,
    String? imagePath,
  }) async {
    return await service.createList(
      title: title,
      description: description,
      posters: posters,
      image: image,
      generated: generated,
      id: id,
      imagePath: imagePath,
    );
  }

  Future<(List<PostMovieModel>, bool)> searchPosts(
      String value, int userId) async {
    final rawList = await service.searchPosts(value, userId);
    return (
      rawList.$1?.map((e) => PostMovieModel.fromJson(e)).toList() ?? [],
      rawList.$2
    );
  }
}
