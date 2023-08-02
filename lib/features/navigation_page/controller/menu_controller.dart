import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/navigation_page/state_holder/menu_state_holder.dart';
import 'package:poster_stock/features/navigation_page/state_holder/navigation_page_state_holder.dart';
import 'package:poster_stock/features/navigation_page/state_holder/navigation_route_state_holder.dart';
import 'package:poster_stock/features/navigation_page/state_holder/previous_page_state_holder.dart';
import 'package:poster_stock/features/navigation_page/view/navigation_page.dart';
import 'package:poster_stock/navigation/app_router.gr.dart';

final menuControllerProvider = Provider<MenuController>(
  (ref) => MenuController(
    menuState: ref.watch(menuStateHolderProvider.notifier),
    menuValue: ref.watch(menuStateHolderProvider),
    routerState: ref.watch(navigationRouterStateHolderProvider.notifier),
    pagesState: ref.watch(navigationPageStateHolderProvider.notifier),
    routerValue: ref.watch(navigationRouterStateHolderProvider),
    previousPageState: ref.watch(previousPageStateHolderProvider.notifier),
  ),
);

class MenuController {
  final MenuStateHolder menuState;
  final NavigationPageStateHolder pagesState;
  final NavigationRouterStateHolder routerState;
  final bool menuValue;
  final TabsRouter? routerValue;
  final PreviousPageStateHolder previousPageState;

  MenuController({
    required this.menuState,
    required this.menuValue,
    required this.pagesState,
    required this.routerState,
    required this.routerValue,
    required this.previousPageState,
  });

  void switchMenu() {
    menuState.updateState(!menuValue);
  }

  void jumpToPage(int page, BuildContext context) {
    FocusScope.of(context).unfocus();
    AutoRouter.of(context).popUntilRouteWithPath('navigation');
    if (menuValue ==true) {
      menuState.updateState(!menuValue);
    }
    previousPageState.updatePage(routerValue?.activeIndex ?? 0);
    routerState.updatePage(page);
    pagesState.updatePage(page);
  }

  void backToPage(BuildContext context) {
    FocusScope.of(context).unfocus();
    AutoRouter.of(context).popUntilRouteWithPath('navigation');
    if (menuValue ==true) {
      menuState.updateState(!menuValue);
    }
    final page = previousPageState.state.last;
    previousPageState.removeLast();
    routerState.updatePage(page);
    pagesState.updatePage(page);
  }

  Future<void> setRouter(TabsRouter router) async {
    await routerState.setRouter(router);
  }
}
