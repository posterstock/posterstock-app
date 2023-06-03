import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/search/state_holders/search_value_state_holder.dart';

final searchControllerProvider = Provider<SearchController>(
  (ref) => SearchController(
    searchValueState: ref.watch(searchValueStateHolderProvider.notifier),
  ),
);

class SearchController {
  final SearchValueStateHolder searchValueState;

  SearchController({required this.searchValueState});

  Future<void> updateSearch(String value) async {
    searchValueState.updateState(value);
  }
}
