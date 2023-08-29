import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/navigation_page/state_holder/menu_state_holder.dart';
import 'package:poster_stock/features/navigation_page/state_holder/navigation_page_state_holder.dart';
import 'package:poster_stock/features/navigation_page/state_holder/navigation_route_state_holder.dart';
import 'package:poster_stock/features/navigation_page/state_holder/previous_page_state_holder.dart';
import 'package:poster_stock/features/navigation_page/view/navigation_page.dart';
import 'package:poster_stock/features/profile/controllers/profile_controller.dart';
import 'package:poster_stock/navigation/app_router.gr.dart';

import '../../../common/state_holders/router_state_holder.dart';

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

  void jumpToPage(int page, BuildContext context, WidgetRef ref) {
    FocusScope.of(context).unfocus();
    if (previousPageState.state.isNotEmpty) {
      ref.watch(router)!.popUntilRouteWithPath('/');
    }
    if (menuValue == true) {
      menuState.updateState(!menuValue);
    }
    previousPageState.updatePage(routerValue?.activeIndex ?? 0);
    routerState.updatePage(page);
    pagesState.updatePage(page);
    if (page == 3) {
      ref.read(profileControllerApiProvider).clearUser();
    }
  }

  void backToPage(BuildContext context, WidgetRef ref) {
    FocusScope.of(context).unfocus();
    ref.watch(router)!.popUntilRouteWithPath('/');
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
