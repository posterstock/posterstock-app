import 'package:poster_stock/features/home/models/post_base_model.dart';

abstract class IHomePagePostsRepository {
  Future<(List<PostBaseModel>?, bool)?> getPosts(
      {bool getNesPosts = false});

  Future<void> setLike(int? id, bool like);

  Future<void> setLikeList(int? id, bool like);
}
