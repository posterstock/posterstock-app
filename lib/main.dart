import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:poster_stock/common/constants/languages.dart';
import 'package:poster_stock/common/data/token_keeper.dart';
import 'package:poster_stock/common/helpers/custom_scroll_behavior.dart';
import 'package:poster_stock/common/state_holders/router_state_holder.dart';
import 'package:poster_stock/features/poster/state_holder/page_transition_controller_state_holder.dart';
import 'package:poster_stock/features/settings/state_holders/chosen_language_state_holder.dart';
import 'package:poster_stock/features/theme_switcher/controller/theme_controller.dart';
import 'package:poster_stock/features/theme_switcher/state_holder/theme_state_holder.dart';
import 'package:poster_stock/features/theme_switcher/state_holder/theme_value_state_holder.dart';
import 'package:poster_stock/themes/app_themes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supertokens_flutter/supertokens.dart';

import 'common/services/notifications_service.dart';
import 'firebase_options.dart';
import 'navigation/app_router.dart';
import 'navigation/app_router.gr.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
// TODO: add exchange rate
double exchangeRate = 0.0;

/// Тут логика по получению пушей в бэкграугнде
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  Logger.i(
      "Handling a background message: ${message.messageId}${message.data}");
  showPush(message);
}

String? initTheme;
bool google = false;
bool apple = false;
String? email;
String? storedLocale;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SuperTokens.init(
    apiDomain: 'https://api.posterstock.com/',
  );

  try {
    PhotoManager.clearFileCache();
  } catch (e) {
    Logger.e('Ошибка очистки кэша $e');
  }
  try {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
    await Firebase.initializeApp(
      name: "Posterstock",
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  } catch (e) {
    Logger.e('Ошибка FirebaseCrashlytics $e');
  }
  try {
    final prefs = await SharedPreferences.getInstance();
    TokenKeeper.token =
        prefs.getString('token') == '' ? null : prefs.getString('token');
    initTheme = prefs.getString('theme');
    google = prefs.getBool('google') ?? false;
    apple = prefs.getBool('apple') ?? false;
    email = prefs.getString('email');
    storedLocale = prefs.getString('locale');
  } catch (e) {
    Logger.e('Ошибка SharedPreferences $e ');
  }
  await Hive.initFlutter();

  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerStatefulWidget {
  const App({Key? key}) : super(key: key);

  static AppRouter? _appRouter;

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with TickerProviderStateMixin {
  late final AnimationController pageTransitionController = AnimationController(
    vsync: this,
    value: 1,
    duration: Duration.zero,
  );

  @override
  Widget build(BuildContext context) {
    if (App._appRouter == null) {
      App._appRouter = AppRouter();
      initPushes(App._appRouter!, ref);
    }
    if (initTheme != null) {
      if (initTheme == 'Themes.dark') {
        Future(() {
          ref
              .read(themeStateHolderProvider.notifier)
              .updateState(AppThemes.darkThemeData);
          ref
              .read(themeValueStateHolderProvider.notifier)
              .updateState(Themes.dark);
        });
      } else if (initTheme == 'Themes.light') {
        Future(() {
          ref
              .read(themeStateHolderProvider.notifier)
              .updateState(AppThemes.lightThemeData);
          ref
              .read(themeValueStateHolderProvider.notifier)
              .updateState(Themes.light);
        });
      }
      initTheme = null;
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final theme = ref.watch(themeStateHolderProvider);
    final appLocale = ref.watch(chosenLanguageStateHolder);
    final rtr = ref.watch(router);
    List<Languages> langs = [
      Languages.english(),
      Languages.russian(),
      Languages.german(),
      Languages.french(),
      Languages.turkish(),
    ];
    List<Locale> locales = langs.map((it) => it.locale).toList();
    if (rtr == null) {
      Future(() {
        ref.read(router.notifier).setRouter(App._appRouter);
      });
    }
    Future(() {
      ref
          .read(pageTransitionControllerStateHolder.notifier)
          .updateState(pageTransitionController);
    });
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: App._appRouter!.config(deepLinkBuilder: (deepLink) {
        if (initLink != null) {
          var route =
              App._appRouter!.matcher.match(initLink!)?[0].toPageRouteInfo();
          if (route != null) {
            if (route is NavigationRoute) return DeepLink([route]);
            return DeepLink([AuthRoute(), route, ...?route.initialChildren]);
          }
          return TokenKeeper.token != null
              ? DeepLink([NavigationRoute()])
              : DeepLink([AuthRoute()]);
        }
        if (deepLink.path == '/' || deepLink.path == '') {
          return TokenKeeper.token != null
              ? DeepLink([NavigationRoute()])
              : DeepLink([AuthRoute()]);
        }
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
      locale: appLocale?.locale,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: ScrollConfiguration(
            behavior: CustomScrollBehavior(),
            child: child ?? const SizedBox(),
          ),
        );
      },
      theme: theme.copyWith(),
    );
  }
}
