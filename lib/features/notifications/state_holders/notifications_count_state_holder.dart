import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationsCountStateHolderProvider =
StateNotifierProvider<NotificationsCountStateHolder, int>(
      (ref) => NotificationsCountStateHolder(0),
);

class NotificationsCountStateHolder extends StateNotifier<int> {
  NotificationsCountStateHolder(super.state);

  void updateState(int value) {
    state = value;
  }
}
