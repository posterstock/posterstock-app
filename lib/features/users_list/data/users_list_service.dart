import 'package:dio/dio.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:poster_stock/common/data/dio_keeper.dart';

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
      cursor = response.data['next_cursor'];
      return (
        response.data['users_short'] as List<dynamic>? ?? [],
        !response.data['has_more']
      );
    } on DioError catch (e) {
      Logger.e('Ошибка при получении списка пользователей $e');
      rethrow;
    }
  }
}
