// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:poster_stock/common/data/token_keeper.dart';
import 'package:poster_stock/common/state_holders/router_state_holder.dart';
import 'package:poster_stock/common/widgets/app_snack_bar.dart';
import 'package:poster_stock/common/widgets/app_text_button.dart';
import 'package:poster_stock/common/widgets/custom_scaffold.dart';
import 'package:poster_stock/features/NFT/models/ton_wallet_service.dart';
import 'package:poster_stock/features/auth/controllers/auth_controller.dart';
import 'package:poster_stock/features/auth/controllers/sign_up_controller.dart';
import 'package:poster_stock/features/edit_profile/api/edit_profile_api.dart';
import 'package:poster_stock/features/notifications/state_holders/notifications_count_state_holder.dart';
import 'package:poster_stock/features/settings/state_holders/change_wallet_state_holder.dart';
import 'package:poster_stock/features/settings/state_holders/chosen_language_state_holder.dart';
import 'package:poster_stock/features/settings/view/screens/widgets.dart';
import 'package:poster_stock/features/theme_switcher/controller/theme_controller.dart';
import 'package:poster_stock/features/theme_switcher/state_holder/theme_value_state_holder.dart';
import 'package:poster_stock/main.dart';
import 'package:poster_stock/navigation/app_router.gr.dart';
import 'package:poster_stock/themes/app_themes.dart';
import 'package:poster_stock/themes/build_context_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supertokens_flutter/supertokens.dart';
import 'package:url_launcher/url_launcher_string.dart';

@RoutePage()
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final tonWallet = TonWalletService();
  String connectedWallet = '';
  bool isLoading = false;
  StreamSubscription? walletSubscription;
  bool isTonWalletConnected = false;

  @override
  void initState() {
    super.initState();
    ref.read(changeWalletStateHolderProvider.notifier).loadFromLocal();
    isTonWalletConnected = tonWallet.isConnected;
    if (!isTonWalletConnected) {
      restoreTonWalletConnection();
    }

    setState(() {});
    subscribeToWallet();
  }

  Future<void> restoreTonWalletConnection() async {
    bool restored = await tonWallet.restoreConnection();
    if (restored) {
      connectedWallet = tonWallet.getWalletAddress();
    }
    setState(() {});
  }

  void subscribeToWallet() {
    walletSubscription = tonWallet.connectionStream.listen((address) {
      setState(() {
        isLoading = false;
      });
      if (address.isNotEmpty) {
        Logger.i('Кошелек успешно подключен: $address');
        connectedWallet = address;
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBars.build(
            context,
            null,
            "Кошелек успешно подключен",
          ),
        );
      } else {
        Logger.i('Ошибка подключения кошелька');
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBars.build(
            context,
            null,
            "Ошибка подключения кошелька",
          ),
        );
      }
      Logger.e('Кошелек: $address');
      setState(() {});
    });
  }

  @override
  void dispose() {
    if (walletSubscription != null) {
      walletSubscription?.cancel();
    }
    super.dispose();
  }

  Future<void> handleWalletConnection() async {
    setState(() => isLoading = true);
    await tonWallet.init();
    try {
      // Подключаем кошелек
      final isConnected = await tonWallet.connect();
      if (isConnected) {
        connectedWallet = tonWallet.getWalletAddress();
        setState(() {});
      }
    } catch (e) {
      Logger.e('Error connecting wallet: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeValueStateHolderProvider);

    return CustomScaffold(
      backgroundColor: context.colors.backgroundsSecondary,
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Column(
              children: [
                AppBar(
                  backgroundColor: context.colors.backgroundsSecondary,
                  elevation: 0,
                  leadingWidth: 130,
                  toolbarHeight: 42,
                  titleSpacing: 0,
                  centerTitle: true,
                  leading: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        ref.watch(router)!.pop();
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.only(left: 7.0, right: 40.0),
                        child: SvgPicture.asset(
                          'assets/icons/back_icon.svg',
                          width: 18,
                          colorFilter: ColorFilter.mode(
                              context.colors.iconsDefault!, BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    context.txt.settings,
                    style: context.textStyles.bodyBold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(16),
                      SettingsButton(
                        onTap: () {
                          ref.watch(router)!.push(
                                const ChooseLanguageRoute(),
                              );
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 129,
                              child: Text(
                                context.txt.settings_language,
                                style: context.textStyles.bodyRegular,
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              child: Text(
                                ref
                                        .watch(chosenLanguageStateHolder)
                                        ?.languageName ??
                                    context.txt.settings_english,
                                maxLines: 1,
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                                style: context.textStyles.bodyRegular!.copyWith(
                                  color: context.colors.textsSecondary,
                                ),
                              ),
                            ),
                            const Gap(16),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: context.colors.iconsDisabled,
                            ),
                          ],
                        ),
                      ),
                      if (email != null)
                        const SizedBox(
                          height: 24,
                        ),
                      if (email != null)
                        SettingsButton(
                          onTap: () {
                            scaffoldMessengerKey.currentState?.showSnackBar(
                              SnackBars.build(
                                context,
                                null,
                                //TODO: localize
                                "Сhanging the email is currently not possible. Please contact support.",
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 129,
                                child: Text(
                                  context.txt.settings_email,
                                  style: context.textStyles.bodyRegular,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  email!,
                                  maxLines: 1,
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      context.textStyles.bodyRegular!.copyWith(
                                    color: context.colors.textsSecondary,
                                  ),
                                ),
                              ),
                              const Gap(16),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                                color: context.colors.iconsDisabled,
                              ),
                            ],
                          ),
                        ),
                      const Gap(16),
                      SettingsButton(
                        onTap: () {},
                        child: Row(
                          children: [
                            Text(
                              'Ton Wallet',
                              style: context.textStyles.bodyRegular,
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: isLoading ? null : handleWalletConnection,
                              child: Container(
                                height: 32,
                                decoration: BoxDecoration(
                                  color: context.colors.backgroundsPrimary,
                                  borderRadius: BorderRadius.circular(33),
                                ),
                                child: AppTextButton(
                                  onTap:
                                      isLoading ? null : handleWalletConnection,
                                  text: connectedWallet.isNotEmpty
                                      ? '${connectedWallet.substring(2, 8)}...${connectedWallet.substring(connectedWallet.length - 4)}'
                                      : context.txt.nft_connect,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (email == null) const Gap(16),
                      if (email == null)
                        DoubleButton(
                          onTap1: () {
                            /*showModalBottomSheet(
                        context: context,
                        builder: (context) => GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: AreYouSureDialog(
                              actionText: 'Disconnect Google account',
                              onTap: () {},
                            ),
                          ),
                        ),
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                      );*/
                          },
                          onTap2: () {},
                          child1: Row(
                            children: [
                              Text(
                                context.txt.settings_googleConnect,
                                style: context.textStyles.bodyRegular,
                              ),
                              const Spacer(),
                              if (google)
                                Text(
                                  //TODO: localize
                                  '􀆅',
                                  style: context.textStyles.headline!.copyWith(
                                    color: context.colors.iconsActive,
                                  ),
                                ),
                            ],
                          ),
                          child2: Row(
                            children: [
                              Text(
                                context.txt.settings_appleConnect,
                                style: context.textStyles.bodyRegular,
                              ),
                              const Spacer(),
                              if (apple)
                                Text(
                                  //TODO: localize
                                  '􀆅',
                                  style: context.textStyles.headline!.copyWith(
                                    color: context.colors.iconsActive,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      if (email == null) const Gap(8),
                      if (email == null)
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            context.txt.settings_manageAccounts,
                            style: context.textStyles.footNote!.copyWith(
                              color: context.colors.textsSecondary,
                            ),
                          ),
                        ),
                      const Gap(24),
                      MultipleSettingsButton(
                        onTaps: [
                          () {
                            changeTheme(ref, Themes.system);
                          },
                          () {
                            changeTheme(ref, Themes.light);
                          },
                          () {
                            changeTheme(ref, Themes.dark);
                          },
                        ],
                        children: [
                          Row(
                            children: [
                              Text(
                                //TODO: localize
                                context.txt.system_theme,
                                style: context.textStyles.bodyRegular,
                              ),
                              const Spacer(),
                              if (theme == Themes.system)
                                Text(
                                  //TODO: localize
                                  "􀆅",
                                  style: context.textStyles.headline!.copyWith(
                                    color: context.colors.iconsActive,
                                  ),
                                ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                context.txt.system_theme_light,
                                style: context.textStyles.bodyRegular,
                              ),
                              const Spacer(),
                              if (theme == Themes.light)
                                Text(
                                  //TODO: localize
                                  "􀆅",
                                  style: context.textStyles.headline!.copyWith(
                                    color: context.colors.iconsActive,
                                  ),
                                ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                context.txt.system_theme_dark,
                                style: context.textStyles.bodyRegular,
                              ),
                              const Spacer(),
                              if (theme == Themes.dark)
                                Text(
                                  //TODO: localize
                                  "􀆅",
                                  style: context.textStyles.headline!.copyWith(
                                    color: context.colors.iconsActive,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      const Gap(24),
                      MultipleSettingsButton(
                        onTaps: [
                          () {
                            launchUrlString(
                              "https://thedirection.org/posterstock_terms",
                            );
                          },
                          () {
                            launchUrlString(
                              "https://thedirection.org/posterstock_privacy",
                            );
                          }
                        ],
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  context.txt.settings_terms,
                                  style: context.textStyles.bodyRegular,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                                color: context.colors.iconsDisabled,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  context.txt.settings_privacy,
                                  style: context.textStyles.bodyRegular,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                                color: context.colors.iconsDisabled,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      SettingsButton(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => Container(
                              color: Colors.transparent,
                              child: AreYouSureDialog(
                                actionText: context.txt.settings_logout,
                                //TODO: localize
                                secondAction: 'Delete account with all data',
                                onTapSecond: () async {
                                  bool delete = await treDelete(context);
                                  ref
                                      .read(changeWalletStateHolderProvider
                                          .notifier)
                                      .setWallet('');
                                  if (!delete) return;
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  try {
                                    await ref
                                        .read(signUpControllerProvider)
                                        .removeFCMToken();
                                    ref
                                        .read(
                                            notificationsCountStateHolderProvider
                                                .notifier)
                                        .updateState(0);
                                    await FirebaseMessaging.instance
                                        .deleteToken();
                                  } catch (_) {}
                                  try {
                                    try {
                                      await EditProfileApi().deleteAccount();
                                    } catch (e) {
                                      Logger.e(
                                          'Ошибка при удалении аккаунта $e');
                                    }
                                    TokenKeeper.token = null;
                                    await prefs.remove('token');
                                    await prefs.remove('google');
                                    await prefs.remove('apple');
                                    await prefs.remove('email');
                                    apple = false;
                                    google = false;
                                    email = null;
                                  } catch (e) {
                                    Logger.e('Ошибка при удалении аккаунта $e');
                                  }
                                  ref
                                      .read(authControllerProvider)
                                      .stopLoading();
                                  ref.watch(router)!.pushAndPopUntil(
                                      AuthRoute(),
                                      predicate: (value) => false);
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  }
                                },
                                onTap: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  try {
                                    await ref
                                        .read(signUpControllerProvider)
                                        .removeFCMToken();
                                    ref
                                        .read(
                                            notificationsCountStateHolderProvider
                                                .notifier)
                                        .updateState(0);
                                    await FirebaseMessaging.instance
                                        .deleteToken();
                                  } catch (_) {}
                                  try {
                                    await SuperTokens.signOut();
                                    TokenKeeper.token = null;
                                    await prefs.remove('token');
                                    await prefs.remove('google');
                                    await prefs.remove('apple');
                                    await prefs.remove('email');
                                    apple = false;
                                    google = false;
                                    email = null;
                                  } catch (e) {
                                    Logger.e('Ошибка при выходе $e');
                                  }
                                  ref
                                      .read(authControllerProvider)
                                      .stopLoading();
                                  ref.watch(router)!.pushAndPopUntil(
                                      AuthRoute(),
                                      predicate: (value) => false);
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ),
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                          );
                        },
                        child: Center(
                          child: Text(
                            context.txt.settings_logout,
                            style: context.textStyles.bodyRegular!.copyWith(
                              color: context.colors.textsError,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 66,
                      ),
                      Column(
                        children: [
                          Text(
                            context.txt.settings_TMDBapi,
                            textAlign: TextAlign.center,
                            style: context.textStyles.footNote!.copyWith(
                              color: context.colors.textsDisabled,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SvgPicture.asset('assets/icons/TMDB.svg'),
                          const SizedBox(
                            height: 32,
                          ),
                          FutureBuilder(
                            future: PackageInfo.fromPlatform(),
                            builder: (context, snapshot) {
                              return Text(
                                'Posterstock ${snapshot.data?.version ?? ''}',
                                textAlign: TextAlign.center,
                                style: context.textStyles.footNote!.copyWith(
                                  color: context.colors.textsDisabled,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Future<void> saveTheme(Themes theme) async {
    final instance = await SharedPreferences.getInstance();
    instance.setString('theme', theme.toString());
  }

  void changeTheme(WidgetRef ref, Themes theme) {
    saveTheme(theme);
    if (theme == Themes.dark) {
      ref
          .read(themeControllerProvider)
          .updateTheme(AppThemes.darkThemeData, theme);
    } else if (theme == Themes.light) {
      ref
          .read(themeControllerProvider)
          .updateTheme(AppThemes.lightThemeData, theme);
    } else {
      var systemBrightness =
          SchedulerBinding.instance.window.platformBrightness;
      if (systemBrightness == Brightness.light) {
        ref.read(themeControllerProvider).updateTheme(
              AppThemes.lightThemeData,
              theme,
            );
      } else {
        ref.read(themeControllerProvider).updateTheme(
              AppThemes.darkThemeData,
              theme,
            );
      }
    }
  }
}
