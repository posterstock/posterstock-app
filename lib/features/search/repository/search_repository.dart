import 'package:poster_stock/features/create_poster/model/media_model.dart';
import 'package:poster_stock/features/home/models/user_model.dart';
import 'package:poster_stock/features/profile/models/user_details_model.dart';
import 'package:poster_stock/features/search/data/search_service.dart';

class SearchRepository {
  final service = SearchService();
  Future<List<UserDetailsModel>> searchUsers(String searchValue) async {
    return (await service.searchUsers(searchValue)).map((e) => UserDetailsModel.fromJson(e)).toList();
  }
}