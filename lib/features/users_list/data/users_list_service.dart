import 'package:dio/dio.dart';
import 'package:poster_stock/common/data/dio_keeper.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';
import 'package:supertokens_flutter/dio.dart';
import 'package:supertokens_flutter/supertokens.dart';

class UsersListService {
  final Dio _dio = DioKeeper.getDio();

  Future<List<dynamic>> getFollows({
    required bool followers,
    required int id,
  }) async {
    try {
      final response = await _dio.get(
        'api/users/$id/follow${followers ? 'ers' : 'ings'}',
        options: Options(
          contentType: 'text/plain; charset=utf-8',
          headers: {
            'rid': 'thirdpartypasswordless'
          },
        ),
      );
      print('SS${response.data}');
      return response.data;
    } on DioError catch (e) {
      print(e.response?.data);
      print(e.response?.headers);
      rethrow;
    }
  }
}
