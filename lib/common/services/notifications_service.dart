import 'package:auto_route/auto_route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/common/state_holders/router_state_holder.dart';
import 'package:poster_stock/features/navigation_page/state_holder/navigation_page_state_holder.dart';
import 'package:poster_stock/features/notifications/state_holders/notifications_count_state_holder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';

/// Defines a iOS/MacOS notification category for plain actions.
const String darwinNotificationCategoryPlain = 'plainCategory';

String? initLink;

void bgHandler (NotificationResponse response, StackRouter? router) {
  var splittedUrl = response.payload?.split('/') ?? [];
  bool hasHttp = splittedUrl[0].startsWith('http');
  splittedUrl.removeAt(0);
  if (hasHttp) {
    splittedUrl.removeAt(0);
    splittedUrl.removeAt(0);
  }
  initLink = '/';
  for (var i = 0; i < splittedUrl.length; i++) {
    initLink = '${initLink!}${splittedUrl[i]}/';
  }
  if (initLink != null && router != null) {
    router.pushNamed(initLink!);
  }
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  //'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

var initialzationSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/ic_notification');

const DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

@pragma('vm:entry-point')
void onDidReceiveLocalNotification(
    int? id, String? title, String? body, String? payload) async {
  // display a dialog with the notification details, tap ok to go to another page
  initLink = payload;
}

Future<void> initPushes(StackRouter? routerLocal, WidgetRef ref) async {
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Слушатель получения пушей из Firebase
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    showPush(message, ref: ref);
  });

  FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {

    showPush(message, ref: ref);
  });

  FirebaseMessaging.instance.getInitialMessage().then((value) {
    flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails()
        .then((value) async {
      if (value?.didNotificationLaunchApp != true) return;
      bgHandler(value!.notificationResponse!, routerLocal);
    });
  });

  var initializationSettings = InitializationSettings(
      android: initialzationSettingsAndroid, iOS: initializationSettingsDarwin);
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    //onDidReceiveBackgroundNotificationResponse: bgHandler,
    onDidReceiveNotificationResponse: (response) {
      if (routerLocal != null) {
        routerLocal.pushNamed(response.payload!);
      }
    }
  );
}

/// Метод который показывает сам пуш. По дефолту сделано, чтобы показывало все с
/// поля notification, но можно всё поменять на data
void showPush(RemoteMessage message, {WidgetRef? ref}) async {
  flutterLocalNotificationsPlugin.show(
    message.hashCode,
    message.data['text'].split(' ')[0],
    message.data['text'],
    NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        //channel.description,
        color: Colors.transparent,
        icon: "@mipmap/ic_notification",
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: iosNotificationDetails,
    ),
    payload: message.data['deep_link'],
  );
  final prefs = await SharedPreferences.getInstance();
  await prefs.reload();
  int count = prefs.getInt('notification_count') ?? 0;
  prefs.setInt('notification_count', count + 1);
  ref?.read(notificationsCountStateHolderProvider.notifier).updateState(count + 1);
}

const DarwinNotificationDetails iosNotificationDetails =
    DarwinNotificationDetails(
  categoryIdentifier: darwinNotificationCategoryPlain,
);
