import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/notification_model.dart';

final notificationsStateHolderProvider =
    StateNotifierProvider<NotificationsStateHolder, List<NotificationModel>?>(
  (ref) => NotificationsStateHolder(null),
);

class NotificationsStateHolder extends StateNotifier<List<NotificationModel>?> {
  NotificationsStateHolder(super.state);

  void updateState(List<NotificationModel> list) {
    state = [...(state ?? []), ...list];
  }
}
