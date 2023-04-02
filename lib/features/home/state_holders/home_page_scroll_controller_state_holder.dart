import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homePageScrollControllerStateHolderProvider = StateNotifierProvider<
    HomePageScrollControllerStateHolder, ScrollController>(
  (ref) => HomePageScrollControllerStateHolder(
    ScrollController(),
  ),
);

class HomePageScrollControllerStateHolder
    extends StateNotifier<ScrollController> {
  HomePageScrollControllerStateHolder(ScrollController controller)
      : super(controller);
}
