import 'package:dio/dio.dart';
import 'package:poster_stock/common/data/dio_keeper.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';
import 'package:supertokens_flutter/dio.dart';
import 'package:supertokens_flutter/supertokens.dart';

class UsersListService {
  final Dio _dio = DioKeeper.getDio();

  String? cursor;
  int? lastId;
  bool? followers;

  Future<(List<dynamic>, bool)> getFollows({
    required bool followers,
    required int id,
  }) async {
    if (followers != this.followers || lastId != id) {
      cursor = null;
    }
    print(cursor);
    this.followers = followers;
    lastId = id;
    try {
      final response = await _dio.get(
        'api/users/$id/follow${followers ? 'ers' : 'ings'}',
        options: Options(
          contentType: 'text/plain; charset=utf-8',
          headers: {'rid': 'thirdpartypasswordless'},
        ),
        queryParameters: {
          'cursor': cursor,
        },
      );
      print(response.data);
      cursor = response.data['next_cursor'];
      print(cursor);
      return (
        response.data['users_short'] as List<dynamic>? ?? [],
        !response.data['has_more']
      );
    } on DioError catch (e) {
      rethrow;
    }
  }
}
