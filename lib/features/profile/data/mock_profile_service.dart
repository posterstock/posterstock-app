import 'package:poster_stock/features/profile/data/i_profile_service.dart';

class MockProfileService implements IProfileService {
  @override
  Future<Map<String, dynamic>> getProfileInfo(String token, int id) async {
    return {
      'data' : {
        'username' : 'itsmishakiva',
        'name' : 'Misha Kiva',
        'avatar' : 'https://avatars.githubusercontent.com/u/62376075?v=4',
        'followed' : true,
        'description' : 'Hello There!',
        'following' : 15,
        'followers' : 250,
        'posters' : 13,
        'lists' : 10
      },
    };
  }

  @override
  Future<Map<String, dynamic>> getProfileLists(String token, int id) async {
    // TODO: implement getProfileLists
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getProfilePosts(String token, int id) async {
    // TODO: implement getProfilePosts
    throw UnimplementedError();
  }

}