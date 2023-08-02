abstract class IHomePageApi {
  Future<(Map<String, dynamic>?, bool)?> getPosts(String token, {bool getNewPosts = false});

  Future<void> setLike(String token, int id, bool like);
}
