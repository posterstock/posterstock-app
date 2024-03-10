import 'package:poster_stock/common/constants/languages.dart';
import 'package:poster_stock/features/create_poster/data/create_poster_service.dart';
import 'package:poster_stock/features/create_poster/model/media_model.dart';

class CreatePosterRepository {
  final service = CreatePosterService();

  Future<void> createPoster(int mediaId, String mediaType, String image,
      String description, Languages lang) async {
    await service.createPoster(mediaId, mediaType, image, description, lang);
  }

  Future<void> editPoster(int id, String image, String description) async {
    await service.editPoster(id, image, description);
  }

  Future<void> createBookmark(
      int mediaId, String mediaType, String image, Languages lang) async {
    await service.createBookmark(mediaId, mediaType, image, lang);
  }

  Future<List<MediaModel>> getSearchMedia(
      String searchValue, Languages language) async {
    return (await service.getSearchMedia(searchValue, language))
        .map((e) => MediaModel.fromJson(e))
        .toList();
  }

  Future<List<String>?> getMediaPosters(String mediaType, int mediaId) async {
    final result =
        (await service.getMediaPosters(mediaType, mediaId))['posters'];
    List<String> resultStr = [];
    for (var a in result) {
      resultStr.add(a.toString());
    }
    return resultStr;
  }
}
