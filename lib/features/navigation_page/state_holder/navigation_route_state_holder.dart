import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigationRouterStateHolderProvider =
    StateNotifierProvider<NavigationRouterStateHolder, TabsRouter?>(
  (ref) => NavigationRouterStateHolder(null),
);

class NavigationRouterStateHolder extends StateNotifier<TabsRouter?> {
  NavigationRouterStateHolder(super.state);

  Future<void> updatePage(int page) async {
    state?.setActiveIndex(page);
  }

  Future<void> setRouter(TabsRouter router) async {
    state = router;
  }
}
