import 'dart:typed_data';

import 'package:poster_stock/features/create_list/data/create_list_service.dart';

class CreateListRepository {
  final service = CreateListService();

  Future<bool?> createList({
    required String title,
    required String description,
    required List<int> posters,
    Uint8List? image,
  }) async {
    return await service.createList(
      title: title,
      description: description,
      posters: posters,
      image: image,
    );
  }
}
