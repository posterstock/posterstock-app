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

  Future<void> updateSearch(String value) async {
    searchValueState.updateState(value);
    searchUsersState.setState(null);
    searchUsersState.updateState(
      await searchRepository.searchUsers(value),
    );
  }
}
