import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/theme_switcher/controller/theme_controller.dart';

final themeValueStateHolderProvider =
    StateNotifierProvider<ThemeValueStateHolder, Themes>(
  (ref) => ThemeValueStateHolder(
    Themes.system,
  ),
);

class ThemeValueStateHolder extends StateNotifier<Themes> {
  ThemeValueStateHolder(super.state);

  void updateState(Themes data) {
    state = data;
  }
}
