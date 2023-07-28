import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:poster_stock/features/auth/controllers/auth_controller.dart';
import 'package:poster_stock/features/auth/controllers/sign_up_controller.dart';
import 'package:poster_stock/features/auth/state_holders/auth_error_state_holder.dart';
import 'package:poster_stock/features/auth/state_holders/auth_loading_state_holder.dart';
import 'package:poster_stock/features/auth/view/pages/sign_up_page.dart';
import 'package:poster_stock/features/auth/view/widgets/auth_button.dart';
import 'package:poster_stock/features/theme_switcher/state_holder/theme_state_holder.dart';
import 'package:poster_stock/navigation/app_router.gr.dart';
import 'package:poster_stock/themes/build_context_extension.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../common/state_holders/intl_state_holder.dart';
import '../../../../common/widgets/app_text_field.dart';

class AuthPage extends ConsumerWidget {
  AuthPage({Key? key}) : super(key: key);
  final textEditingController = TextEditingController();
  final ScrollController scrollController1 = ScrollController();
  final ScrollController scrollController2 = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    scrollController1.addListener(() {
      scrollController2.jumpTo(scrollController1.offset);
    });
    scrollController2.addListener(() {
      scrollController2.jumpTo(scrollController1.offset);
    });
    ref.read(localizations.notifier).setLocalizations(
          AppLocalizations.of(context),
        ); //This must be initialized as soon as possible after returning Material App
    final loadingState = ref.watch(authLoadingStateHolderProvider);
    final errorState = ref.watch(authErrorStateHolderProvider);
    final theme = ref.watch(themeStateHolderProvider);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: context.colors.backgroundsPrimary,
            systemNavigationBarIconBrightness:
                Theme.of(context).brightness == Brightness.light
                    ? Brightness.dark
                    : Brightness.light,
          ),
          child: Stack(
            children: [
              ListView(
                padding: EdgeInsets.zero,
                physics: MediaQuery.of(context).size.height < 812
                    ? const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics())
                    : const NeverScrollableScrollPhysics(
                        parent: BouncingScrollPhysics()),
                controller: scrollController2,
                children: [
                  Image.asset(
                    theme.brightness == Brightness.light
                        ? 'assets/images/header_light.png'
                        : 'assets/images/header_dark.png',
                    fit: BoxFit.fitWidth,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                  ),
                ],
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ColumnOrList(
                    controller: scrollController1,
                    isList: MediaQuery.of(context).size.height < 812,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 375 * 220 -
                            72 -
                            MediaQuery.of(context).padding.top,
                        width: double.infinity,
                      ),
                      SizedBox(
                        width: 144,
                        height: 144,
                        child: Theme.of(context).brightness == Brightness.light
                            ? SvgPicture.asset('assets/images/light_logo.svg')
                            : SvgPicture.asset('assets/images/dark_logo.svg'),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        AppLocalizations.of(context)!.welcome,
                        style: context.textStyles.title2!,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 34),
                      AppTextField(
                        hint: AppLocalizations.of(context)!.enterEmail,
                        onSubmitted: (value) {
                          checkEmail(ref, value, context);
                        },
                        controller: textEditingController,
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        height: 20,
                        width: double.infinity,
                        child: errorState != null
                            ? Text(
                                AppLocalizations.of(context)!.emailError,
                                style: context.textStyles.caption1!,
                              )
                            : null,
                      ),
                      const SizedBox(height: 4),
                      AuthButton(
                        loading: ref
                            .watch(authLoadingStateHolderProvider)
                            .loadingEmail,
                        onTap: () {
                          ref.read(authControllerProvider).loadEmail();
                          checkEmail(ref, textEditingController.text, context);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.contWithEmail,
                          style: context.textStyles.calloutBold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          AppLocalizations.of(context)!.or,
                          style: context.textStyles.callout,
                        ),
                      ),
                      const SizedBox(height: 20),
                      AuthButton(
                        onTap: () {
                          loadApple(ref, context);
                        },
                        loading: loadingState.loadingApple,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.apple,
                              color: context.colors.iconsDefault!,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.contWithApple,
                              style: context.textStyles.calloutBold,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      AuthButton(
                        onTap: () {
                          loadGoogle(ref, context);
                        },
                        loading: loadingState.loadingGoogle,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/ic_google.svg',
                              width: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.contWithGoogle,
                              style: context.textStyles.calloutBold,
                            ),
                          ],
                        ),
                      ),
                      if (MediaQuery.of(context).size.height >= 812)
                        const Spacer(),
                      if (MediaQuery.of(context).size.height < 812)
                        const SizedBox(height: 32.0),
                      Center(
                        child: RichText(
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: AppLocalizations.of(context)!
                                .privacyPolicyText1,
                            style: context.textStyles.caption2,
                            children: <TextSpan>[
                              TextSpan(
                                text: AppLocalizations.of(context)!
                                    .privacyPolicyLink1,
                                style: context.textStyles.caption2!.copyWith(
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => launchUrlString(
                                      "https://thedirection.org/posterstock_terms"),
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)!
                                    .privacyPolicyText2,
                                style: context.textStyles.caption2,
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)!
                                    .privacyPolicyLink2,
                                style: context.textStyles.caption2!.copyWith(
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => launchUrlString(
                                      "https://thedirection.org/posterstock_privacy"),
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)!
                                    .privacyPolicyText3,
                                style: context.textStyles.caption2,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loadApple(WidgetRef ref, BuildContext context) async {
    ref.read(authControllerProvider).loadApple();
    /*Future.delayed(const Duration(seconds: 5), () {
      AutoRouter.of(context).pushNamed('login').then((value) {
        ref.read(signUpControllerProvider)
          ..setName('')
          ..setUsername('')
          ..removeCode()
          ..removeUsernameError();
      });
      ref.read(authControllerProvider).stopLoading();
    });*/
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        webAuthenticationOptions: Platform.isIOS
            ? null
            : WebAuthenticationOptions(
                clientId: 'com.thedirection.posterstock.singin',
                redirectUri:
                    Uri.parse('https://posterstock.co/auth/callback/apple'),
              ),
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      ).then((value) {
        ref.read(authControllerProvider).stopLoading();
      });
      print(credential.email?.split('@'));
    } catch (e) {
      print(e);
      ref.read(authControllerProvider).stopLoading();
    }
  }

  void loadGoogle(WidgetRef ref, BuildContext context) async {
    ref.read(authControllerProvider).loadGoogle();
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
      ],
    );
    try {
      var response = await googleSignIn.signIn();
      if (context.mounted) {
        ref.read(signUpControllerProvider)
          ..setName(response!.displayName!)
          ..setUsername(response.email.split('@')[0])
          ..removeCode();
        ref.read(authControllerProvider).setEmail(response.email);
        AutoRouter.of(context).push(const SignUpRoute());
      }
      ref.read(authControllerProvider).stopLoading();
    } catch (error) {
      print(error);
    }
    ref.read(authControllerProvider).stopLoading();
  }

  void checkEmail(WidgetRef ref, String value, BuildContext context) {
    RegExp regExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    );
    if (!regExp.hasMatch(value)) {
      ref.read(authControllerProvider).setError();
      ref.read(authControllerProvider).stopLoading();
    } else {
      ref.read(authControllerProvider).removeError();

      ref.read(authControllerProvider).setEmail(value).then((value) {
        AutoRouter.of(context).pushNamed('sign_up').then((value) {
          ref.read(authControllerProvider).stopLoading();
          ref.read(signUpControllerProvider)
            ..setName('')
            ..setUsername('')
            ..removeCode()
            ..removeUsernameError();
        });
      });
    }
  }
}
