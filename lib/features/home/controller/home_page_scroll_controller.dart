import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/home/state_holders/home_page_scroll_controller_state_holder.dart';

final homePageScrollControllerProvider = Provider<HomePageScrollController>(
  (ref) => HomePageScrollController(
    scrollControllerState:
        ref.watch(homePageScrollControllerStateHolderProvider),
  ),
);

class HomePageScrollController {
  final ScrollController scrollControllerState;

  HomePageScrollController({required this.scrollControllerState});

  void animateScrollToZero() {
    scrollControllerState.animateTo(
      scrollControllerState.position.atEdge ? -130 : 0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }
}
