abstract class IProfileService {
  Future<Map<String, dynamic>> getProfileInfo(String token, int id);

  Future<Map<String, dynamic>> getProfileLists(String token, int id);

  Future<Map<String, dynamic>> getProfilePosts(String token, int id);
}