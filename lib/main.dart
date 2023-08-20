import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:poster_stock/common/constants/languages.dart';
import 'package:poster_stock/common/data/token_keeper.dart';
import 'package:poster_stock/common/helpers/custom_scroll_behavior.dart';
import 'package:poster_stock/common/state_holders/router_state_holder.dart';
import 'package:poster_stock/features/settings/controllers/app_language_controller.dart';
import 'package:poster_stock/features/settings/state_holders/chosen_language_state_holder.dart';
import 'package:poster_stock/features/theme_switcher/state_holder/theme_state_holder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supertokens_flutter/supertokens.dart';

import 'common/services/notifications_service.dart';
import 'firebase_options.dart';
import 'navigation/app_router.dart';
import 'navigation/app_router.gr.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

/// Тут логика по получению пушей в бэкграугнде
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint(
      "Handling a background message: ${message.messageId}${message.data}");
  showPush(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SuperTokens.init(
    apiDomain: 'https://api.posterstock.co/',
  );

  PhotoManager.clearFileCache();
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final fcmToken = await FirebaseMessaging.instance.getToken();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final prefs = await SharedPreferences.getInstance();
  debugPrint("FCM TOKEN $fcmToken");
  TokenKeeper.token =
      prefs.getString('token') == '' ? null : prefs.getString('token');
  //TODO
  PackageInfo.setMockInitialValues(
    appName: 'Posterstock',
    packageName: 'com.thedirection.posterstock',
    version: '0.0.t',
    buildNumber: '1',
    buildSignature: 'Posterstock',
  );

  runApp(ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  App({Key? key}) : super(key: key);

  AppRouter? _appRouter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (_appRouter == null) {
      _appRouter = AppRouter();
      initPushes(_appRouter!);
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final theme = ref.watch(themeStateHolderProvider);
    final appLocale = ref.watch(chosenLanguageStateHolder);
    final rtr = ref.watch(router);
    final Locale systemLocale = WidgetsBinding.instance.window.locale;
    List<Languages> langs = [
      Languages.english(),
      Languages.russian(),
    ];
    List<Locale> locales = langs.map((e) => e.locale).toList();
    if (rtr == null) {
      Future(() {
        ref.read(router.notifier).setRouter(_appRouter);
        if (initLink != null) {
          print('i did');
          _appRouter!.pushNamed(initLink!);
          print(initLink);
          initLink = null;
        }
      });
    }
    if (appLocale == null) {
      Future(() {
        if (locales.contains(systemLocale)) {
          for (int i = 0; i < locales.length; i++) {
            if (locales[i] == systemLocale) {
              ref.read(appLanguageControllerProvider).updateLanguage(langs[i]);
            }
          }
        } else {
          ref.read(appLanguageControllerProvider).updateLanguage(langs[0]);
        }
      });
    }
    return MaterialApp.router(
      routerConfig: _appRouter!.config(deepLinkBuilder: (deepLink) {
        if(deepLink.path == '/') return DeepLink([AuthRoute()]);
        return deepLink;
      }),
      scaffoldMessengerKey: scaffoldMessengerKey,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: locales,
      locale: appLocale?.locale ?? locales[0],
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: ScrollConfiguration(
            behavior: CustomScrollBehavior(),
            child: child ?? const SizedBox(),
          ),
        );
      },
      theme: theme,
    );
  }
}
