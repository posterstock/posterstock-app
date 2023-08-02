import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:poster_stock/common/constants/languages.dart';
import 'package:poster_stock/common/helpers/custom_scroll_behavior.dart';
import 'package:poster_stock/features/settings/controllers/app_language_controller.dart';
import 'package:poster_stock/features/settings/state_holders/chosen_language_state_holder.dart';
import 'package:poster_stock/features/theme_switcher/state_holder/theme_state_holder.dart';
import 'package:supertokens_flutter/supertokens.dart';

import 'firebase_options.dart';
import 'navigation/app_router.gr.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SuperTokens.init(apiDomain: 'https://posterstock.co/');

  PhotoManager.clearFileCache();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final theme = ref.watch(themeStateHolderProvider);
    final appLocale = ref.watch(chosenLanguageStateHolder);
    final Locale systemLocale = WidgetsBinding.instance.window.locale;
    List<Languages> langs = [
      Languages.english(),
      Languages.russian(),
    ];
    List<Locale> locales = langs.map((e) => e.locale).toList();
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
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
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
