import 'package:poster_stock/features/create_poster/data/create_poster_service.dart';
import 'package:poster_stock/features/create_poster/model/media_model.dart';

class CreatePosterRepository {
  final service = CreatePosterService();

  Future<void> createPoster(int mediaId, String mediaType, String image, String description) async {
    await service.createPoster(mediaId, mediaType, image, description);
  }

  Future<void> createBookmark(int mediaId, String mediaType, String image) async {
    await service.createBookmark(mediaId, mediaType, image);
  }

  Future<List<MediaModel>> getSearchMedia(String searchValue) async {
    return (await service.getSearchMedia(searchValue))
        .map((e) => MediaModel.fromJson(e))
        .toList();
  }

  Future<List<String>?> getMediaPosters(String mediaType, int mediaId) async {
    final result = (await service.getMediaPosters(mediaType, mediaId))['posters'];
    List<String> resultStr = [];
    for (var a in result) {
      resultStr.add(a.toString());
    }
    return resultStr;
  }
}
