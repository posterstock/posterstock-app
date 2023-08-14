import 'package:poster_stock/features/create_poster/data/create_poster_service.dart';
import 'package:poster_stock/features/create_poster/model/media_model.dart';

class CreatePosterRepository {
  final service = CreatePosterService();
  Future<List<MediaModel>> getSearchMedia(String searchValue) async {
    return (await service.getSearchMedia(searchValue)).map((e) => MediaModel.fromJson(e)).toList();
  }
}