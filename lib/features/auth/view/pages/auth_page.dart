import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/features/auth/controllers/auth_controller.dart';
import 'package:poster_stock/features/auth/state_holders/auth_error_state_holder.dart';
import 'package:poster_stock/features/auth/state_holders/auth_loading_state_holder.dart';
import 'package:poster_stock/features/auth/view/widgets/auth_button.dart';
import 'package:poster_stock/navigation/app_router.gr.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

import '../../../../common/widgets/app_text_field.dart';

class AuthPage extends ConsumerWidget {
  AuthPage({Key? key}) : super(key: key);
  final textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadingState = ref.watch(authLoadingStateHolderProvider);
    final errorState = ref.watch(authErrorStateHolderProvider);
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Image.asset(
                'assets/header.png',
                fit: BoxFit.fitWidth,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    SizedBox(
                      height:
                          MediaQuery.of(context).size.width / 375 * 220 - 72,
                      width: double.infinity,
                    ),
                    Container(
                      width: 144,
                      height: 144,
                      decoration: BoxDecoration(
                        color: context.colors.backgroundsPrimary,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(36),
                        child: SvgPicture.asset('assets/icons/logo.svg'),
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.welcome,
                      style: context.textStyles.title2,
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
                              style: context.textStyles.caption!,
                            )
                          : null,
                    ),
                    const SizedBox(height: 4),
                    AuthButton(
                      onTap: () {
                        checkEmail(ref, textEditingController.text, context);
                        ref.read(authControllerProvider).stopLoading();
                      },
                      child: Text(
                        AppLocalizations.of(context)!.contWithEmail,
                        style: context.textStyles.calloutBold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context)!.or,
                      style: context.textStyles.callout,
                    ),
                    const SizedBox(height: 20),
                    AuthButton(
                      onTap: () {
                        ref.read(authControllerProvider).loadApple();
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
                        ref.read(authControllerProvider).loadGoogle();
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
                    const SizedBox(height: 28),
                    Text(
                      AppLocalizations.of(context)!.privacyPolicy,
                      style: context.textStyles.caption2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void checkEmail(WidgetRef ref, String value, BuildContext context) {
    RegExp regExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    );
    if (!regExp.hasMatch(value)) {
      ref.read(authControllerProvider).setError();
    } else {
      ref.read(authControllerProvider).removeError();
      AutoRouter.of(context).push(SignUpRoute());
    }
  }
}
