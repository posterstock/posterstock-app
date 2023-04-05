abstract class IHomePageApi {
  Future<Map<String, dynamic>> getPosts(String token, int offset);
}
