import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/navigation_page/state_holder/menu_state_holder.dart';

final menuControllerProvider = Provider<MenuController>(
  (ref) => MenuController(
    menuState: ref.watch(menuStateHolderProvider.notifier),
    menuValue: ref.watch(menuStateHolderProvider),
  ),
);

class MenuController {
  final MenuStateHolder menuState;
  final bool menuValue;

  MenuController({
    required this.menuState,
    required this.menuValue,
  });

  void switchMenu() {
    menuState.updateState(!menuValue);
  }
}
