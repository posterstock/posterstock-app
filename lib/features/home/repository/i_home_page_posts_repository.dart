import 'package:poster_stock/features/home/models/post_base_model.dart';

abstract class IHomePagePostsRepository {
  Future<List<PostBaseModel>> getPosts();
}
