import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/notification_model.dart';

final notificationsStateHolderProvider =
    StateNotifierProvider<NotificationsStateHolder, List<NotificationModel>?>(
  (ref) => NotificationsStateHolder(null),
);

class NotificationsStateHolder extends StateNotifier<List<NotificationModel>?> {
  NotificationsStateHolder(super.state) {
    Timer timer = Timer(const Duration(minutes: 1), () {
      state = [...?state];
    });
  }

  void updateState(List<NotificationModel> list) {
    if (list.isEmpty && state != null) return;
    state?.sort((a, b) => a.time.isAfter(b.time) ? 0 : 1);
    list?.sort((a, b) => a.time.isAfter(b.time) ? 0 : 1);
    state = [...?state, ...list];
  }

  void updateStateStart(List<NotificationModel> list) {
    if (list.isEmpty && state != null) return;
    for (int i = 0; i < list.length; i++) {
      for (int j = 0; j < (state?.length ?? 0); j++) {
        if (state![j].id == list![i].id) {
          state!.removeAt(j);
          j--;
        }
      }
    }
    state?.sort((a, b) => a.time.isAfter(b.time) ? 0 : 1);
    list?.sort((a, b) => a.time.isAfter(b.time) ? 0 : 1);
    state = [...list, ...?state];
  }

  void clear() {
    state = null;
  }
}
