import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/notification_model.dart';

final notificationsStateHolderProvider =
    StateNotifierProvider<NotificationsStateHolder, List<NotificationModel>?>(
  (ref) => NotificationsStateHolder(null),
);

class NotificationsStateHolder extends StateNotifier<List<NotificationModel>?> {
  NotificationsStateHolder(super.state);

  void updateState(List<NotificationModel> list) {
    if (list.isEmpty && state != null) return;
    state = [...?state, ...list];
  }

  void updateStateStart(List<NotificationModel> list) {
    if (list.isEmpty && state != null) return;
    for (int i = 0; i < (state?.length ?? 0); i++) {
      for (int j = 0; j < list.length; j++) {
        if (state![i].id == state![j].id) {
          state!.removeAt(i);
          i--;
        }
      }
    }
    state = [...list, ...?state];
  }
}
