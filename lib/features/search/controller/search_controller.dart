import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/search/repository/search_repository.dart';
import 'package:poster_stock/features/search/state_holders/search_users_state_holder.dart';
import 'package:poster_stock/features/search/state_holders/search_value_state_holder.dart';

final searchControllerProvider = Provider<SearchController>(
  (ref) => SearchController(
    searchValueState: ref.watch(searchValueStateHolderProvider.notifier),
    searchUsersState: ref.watch(searchUsersStateHolderProvider.notifier),
  ),
);

class SearchController {
  final SearchValueStateHolder searchValueState;
  final SearchUsersStateHolder searchUsersState;
  final SearchRepository searchRepository = SearchRepository();

  SearchController({
    required this.searchValueState,
    required this.searchUsersState,
  });

  String searchValue = '';

  Future<void> updateSearch(String value) async {
    searchValue = value;
    bool stop = false;
    await Future.delayed(const Duration(milliseconds: 300), () {
      if (searchValue != value) stop = true;
    });
    if (stop) return;
    print(value);
    searchValueState.updateState(value);
    searchUsersState.setState(null);
    try {
      var users = await searchRepository.searchUsers(value);
      users.forEach((element) {print('12${element.id}');});
      searchUsersState.setState(
        users,
      );
    } catch (e) {
      print(e);
    }
  }
}
