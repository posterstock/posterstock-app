// ignore_for_file: use_build_context_synchronously

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
import 'package:poster_stock/common/helpers/custom_ink_well.dart';
import 'package:poster_stock/common/state_holders/router_state_holder.dart';
import 'package:poster_stock/common/widgets/app_snack_bar.dart';
import 'package:poster_stock/common/widgets/app_text_button.dart';
import 'package:poster_stock/common/widgets/custom_scaffold.dart';
import 'package:poster_stock/features/auth/controllers/auth_controller.dart';
import 'package:poster_stock/features/auth/controllers/sign_up_controller.dart';
import 'package:poster_stock/features/edit_profile/api/edit_profile_api.dart';
import 'package:poster_stock/features/notifications/state_holders/notifications_count_state_holder.dart';
import 'package:poster_stock/features/settings/state_holders/chosen_language_state_holder.dart';
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
class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isWallet = false;
    setWallet() async {
      if (isWallet) return;
      isWallet = true;
      ref.watch(themeValueStateHolderProvider);
      await Future.delayed(const Duration(seconds: 1));
      isWallet = false;
      ref.watch(themeValueStateHolderProvider);
    }

    final theme = ref.watch(themeValueStateHolderProvider);
    return CustomScaffold(
      backgroundColor: context.colors.backgroundsSecondary,
      child: SingleChildScrollView(
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
                        /*ref.watch(router)!.push(
                        ChangeEmailRoute(),
                      );*/
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
                  const Gap(16),
                  SettingsButton(
                    onTap: () {
                      if (!isWallet) {
                        isWallet = true;
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                          'Ton Wallet',
                          style: context.textStyles.bodyRegular,
                        ),
                        const Spacer(),
                        Container(
                          height: 32,
                          decoration: BoxDecoration(
                            color: context.colors.backgroundsPrimary,
                            borderRadius: BorderRadius.circular(33),
                          ),
                          child: AppTextButton(
                            onTap: () {},
                            text: context.txt.connect,
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
                              if (!delete) return;
                              final prefs =
                                  await SharedPreferences.getInstance();
                              try {
                                await ref
                                    .read(signUpControllerProvider)
                                    .removeFCMToken();
                                ref
                                    .read(notificationsCountStateHolderProvider
                                        .notifier)
                                    .updateState(0);
                                await FirebaseMessaging.instance.deleteToken();
                              } catch (_) {}
                              try {
                                try {
                                  await EditProfileApi().deleteAccount();
                                } catch (e) {
                                  Logger.e('Ошибка при удалении аккаунта $e');
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
                              ref.read(authControllerProvider).stopLoading();
                              ref.watch(router)!.pushAndPopUntil(AuthRoute(),
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
                                    .read(notificationsCountStateHolderProvider
                                        .notifier)
                                    .updateState(0);
                                await FirebaseMessaging.instance.deleteToken();
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
                              ref.read(authControllerProvider).stopLoading();
                              ref.watch(router)!.pushAndPopUntil(AuthRoute(),
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
    );
  }

  Future<bool> treDelete(BuildContext context) async {
    bool? exit = await showDialog(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 38.0),
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                height: 132,
                decoration: BoxDecoration(
                  color: context.colors.backgroundsPrimary,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x29000000),
                      offset: Offset(0, 16),
                      blurRadius: 24,
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            //TODO: localize
                            "Are you sure you want to delete all your user data?",
                            style: context.textStyles.bodyBold,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      height: 0.5,
                      thickness: 0.5,
                      color: context.colors.fieldsDefault,
                    ),
                    SizedBox(
                      height: 52,
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomInkWell(
                              onTap: () {
                                Navigator.pop(context, true);
                              },
                              child: Center(
                                child: Text(
                                  context.txt.delete,
                                  style:
                                      context.textStyles.bodyRegular!.copyWith(
                                    color: context.colors.textsError,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: CustomInkWell(
                              onTap: () {
                                Navigator.pop(context, false);
                              },
                              child: Center(
                                child: Text(
                                  context.txt.cancel,
                                  style: context.textStyles.bodyRegular,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    return exit ?? false;
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

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    Key? key,
    required this.onTap,
    required this.child,
  }) : super(key: key);
  final void Function() onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Material(
        color: context.colors.backgroundsPrimary,
        child: InkWell(
          highlightColor: Colors.transparent.withOpacity(0.1),
          onTap: onTap,
          child: SizedBox(
            height: 48,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class DoubleButton extends StatelessWidget {
  const DoubleButton(
      {Key? key,
      required this.onTap1,
      required this.child1,
      required this.onTap2,
      required this.child2})
      : super(key: key);
  final void Function() onTap1;
  final Widget child1;
  final void Function() onTap2;
  final Widget child2;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Material(
        color: context.colors.backgroundsPrimary,
        child: SizedBox(
          height: 96.5,
          child: Column(
            children: [
              Expanded(
                child: InkWell(
                  highlightColor: Colors.transparent.withOpacity(0.1),
                  onTap: onTap1,
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      child: child1,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(
                  color: context.colors.fieldsDefault,
                  height: 0.5,
                  thickness: 0.5,
                ),
              ),
              Expanded(
                child: InkWell(
                  highlightColor: Colors.transparent.withOpacity(0.1),
                  onTap: onTap2,
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      child: child2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MultipleSettingsButton extends StatelessWidget {
  const MultipleSettingsButton({
    Key? key,
    required this.onTaps,
    required this.children,
  })  : assert(onTaps.length == children.length),
        super(key: key);
  final List<void Function()> onTaps;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Material(
        color: context.colors.backgroundsPrimary,
        child: SizedBox(
          height: 48 * children.length + (children.length - 1) * 0.5,
          child: Column(
            children: List.generate(
              children.length,
              (index) => Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: InkWell(
                        highlightColor: Colors.transparent.withOpacity(0.1),
                        onTap: onTaps[index],
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: children[index],
                          ),
                        ),
                      ),
                    ),
                    if (index != children.length - 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Divider(
                          color: context.colors.fieldsDefault,
                          height: 0.5,
                          thickness: 0.5,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AreYouSureDialog extends ConsumerWidget {
  const AreYouSureDialog({
    Key? key,
    required this.actionText,
    required this.secondAction,
    required this.onTap,
    required this.onTapSecond,
  }) : super(key: key);

  final String actionText;
  final String secondAction;
  final void Function() onTap;
  final void Function() onTapSecond;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 252,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: SizedBox(
                  height: 140,
                  child: Material(
                    color: context.colors.backgroundsPrimary,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 36,
                          child: Center(
                            child: Text(
                              context.txt.settings_disconnect_confirm,
                              style: context.textStyles.footNote!.copyWith(
                                color: context.colors.textsSecondary,
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 0.5,
                          thickness: 0.5,
                          color: context.colors.fieldsDefault,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: onTap,
                            child: Center(
                              child: Text(
                                actionText,
                                style: context.textStyles.bodyRegular!.copyWith(
                                  color: context.colors.textsPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 0.5,
                          thickness: 0.5,
                          color: context.colors.fieldsDefault,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              onTapSecond();
                            },
                            child: Center(
                              child: Text(
                                secondAction,
                                style: context.textStyles.bodyRegular!.copyWith(
                                  color: context.colors.textsError,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: SizedBox(
                  height: 52,
                  child: Material(
                    color: context.colors.backgroundsPrimary,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Text(
                          context.txt.cancel,
                          style: context.textStyles.bodyRegular,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
