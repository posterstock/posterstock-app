import 'package:flutter_riverpod/flutter_riverpod.dart';

final nameStateHolderProvider = StateNotifierProvider<NameStateHolder, String>(
  (ref) => NameStateHolder(),
);

class NameStateHolder extends StateNotifier<String> {
  NameStateHolder() : super('');

  Future<void> updateState(String name) async{
    state = name;
    return;
  }

  void clearState() {
    state = '';
  }
}
