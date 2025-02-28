abstract class IHomePageApi {
  Future<(Map<String, dynamic>?, bool)?> getPosts(String lang,
      {bool getNewPosts = false});

  Future<void> setLike(int id, bool like);

  Future<void> setLikeList(int id, bool like);

  Future<void> getPostersOwners(String addressNft);
}
