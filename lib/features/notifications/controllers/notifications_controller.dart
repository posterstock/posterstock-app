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

  Future<void> getNotificationsData() async {
    notificationsState.updateState(await repo.getNotifications());
  }
}
