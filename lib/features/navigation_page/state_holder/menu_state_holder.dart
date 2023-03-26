import 'package:flutter_riverpod/flutter_riverpod.dart';

final menuStateHolderProvider = StateNotifierProvider<MenuStateHolder, bool>(
  (ref) => MenuStateHolder(false),
);

class MenuStateHolder extends StateNotifier<bool> {
  MenuStateHolder(bool value) : super(value);

  void updateState(bool value) {
    state = value;
  }
}
