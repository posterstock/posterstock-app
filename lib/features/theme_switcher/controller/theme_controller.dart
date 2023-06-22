import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/theme_switcher/state_holder/theme_state_holder.dart';
import 'package:poster_stock/features/theme_switcher/state_holder/theme_value_state_holder.dart';

final themeControllerProvider = Provider<ThemeController>(
  (ref) => ThemeController(
    themeState: ref.watch(themeStateHolderProvider.notifier),
    themeValueState: ref.watch(themeValueStateHolderProvider.notifier),
  ),
);

class ThemeController {
  ThemeController({required this.themeState, required this.themeValueState});

  final ThemeStateHolder themeState;
  final ThemeValueStateHolder themeValueState;

  void updateTheme(ThemeData value, Themes theme) {
    themeState.updateState(value);
    themeValueState.updateState(theme);
  }
}

enum Themes{
  light,
  dark,
  system
}
