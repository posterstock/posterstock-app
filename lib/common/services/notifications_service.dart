import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:poster_stock/features/notifications/state_holders/notifications_count_state_holder.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Defines a iOS/MacOS notification category for plain actions.
const String darwinNotificationCategoryPlain = 'plainCategory';

String? initLink;

void bgHandler(NotificationResponse response, StackRouter? router) {
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
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      //onDidReceiveBackgroundNotificationResponse: bgHandler,
      onDidReceiveNotificationResponse: (response) {
    if (routerLocal != null) {
      routerLocal.pushNamed(response.payload!);
    }
  });
}

/// Метод который показывает сам пуш. По дефолту сделано, чтобы показывало все с
/// поля notification, но можно всё поменять на data
@pragma('vm:entry-point')
void showPush(RemoteMessage message, {WidgetRef? ref}) async {
  print(message.data);
  BigPictureStyleInformation? bigPictureStyleInformation;
  String filePath = "";
  try {
    final Response response = await Dio().get(
      (message.data['text'] as String).contains("followed")
          ? message.data['profile_url']
          : message.data['entity_image'],
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );
    if (Platform.isIOS) {
      var documentDirectory = await getApplicationDocumentsDirectory();
      var firstPath = "${documentDirectory.path}/images/account";
      var filePathAndName = '${documentDirectory.path}/images/account/pic.png';
      filePath = filePathAndName;
      await Directory(firstPath).create(recursive: true);
      File file2 = File(filePathAndName);
      file2.writeAsBytesSync(response.data);
    }
    bigPictureStyleInformation = BigPictureStyleInformation(
      ByteArrayAndroidBitmap.fromBase64String(base64Encode(response.data)),
      hideExpandedLargeIcon: true,
      largeIcon:
          ByteArrayAndroidBitmap.fromBase64String(base64Encode(response.data)),
    );
  } catch (e) {
    print(e);
  }
  DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails(
      categoryIdentifier: darwinNotificationCategoryPlain,
      attachments: filePath.isEmpty
          ? []
          : [
              DarwinNotificationAttachment(filePath),
            ]);
  flutterLocalNotificationsPlugin.show(
    message.hashCode,
    message.data['text'],
    message.data['comment'],
    NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        largeIcon: bigPictureStyleInformation?.largeIcon,
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
  ref
      ?.read(notificationsCountStateHolderProvider.notifier)
      .updateState(count + 1);
}
