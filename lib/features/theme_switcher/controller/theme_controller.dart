import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/theme_switcher/state_holder/theme_state_holder.dart';

final themeControllerProvider = Provider<ThemeController>(
  (ref) => ThemeController(
    themeState: ref.watch(themeStateHolderProvider.notifier),
  ),
);

class ThemeController {
  ThemeController({required this.themeState});

  final ThemeStateHolder themeState;

  void updateTheme(ThemeData value) {
    themeState.updateState(value);
  }
}
