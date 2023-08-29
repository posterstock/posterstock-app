import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/notifications/repositories/notifications_repository.dart';
import 'package:poster_stock/features/notifications/state_holders/notifications_state_holder.dart';

import '../repositories/i_notifications_repository.dart';

final notificationsControllerProvider = Provider<NotificationsController>(
  (ref) => NotificationsController(
    notificationsState: ref.watch(notificationsStateHolderProvider.notifier),
  ),
);

class NotificationsController {
  final NotificationsStateHolder notificationsState;
  final INotificationsRepository repo = NotificationsRepository();

  NotificationsController({required this.notificationsState});

  bool loadedAll = false;
  bool loading = false;

  Future<void> getNotificationsData({
    bool getNewPosts = false,
  }) async {
    if (loading) return;
    loading = true;
    try {
      if (getNewPosts) {
        notificationsState
            .updateStateStart(await repo.getNotifications(getNewPosts: true));
      } else if (!loadedAll) {
        var nots = await repo.getNotifications();
        if (nots.isEmpty) {
          loadedAll = true;
        }
        notificationsState.updateState(nots);
      }
    } catch (e) {
      print(e);
    }
    loading = false;
  }
}
