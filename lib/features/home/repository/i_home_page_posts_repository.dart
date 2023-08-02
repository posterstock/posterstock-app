import 'package:poster_stock/features/home/models/post_base_model.dart';

abstract class IHomePagePostsRepository {
  Future<(List<List<PostBaseModel>>?, bool)?> getPosts(String token, {bool getNesPosts = false});

  Future<void> setLike(String token, int? index, bool like);
}
