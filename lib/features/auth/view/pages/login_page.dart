import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/common/state_holders/router_state_holder.dart';
import 'package:poster_stock/common/widgets/custom_scaffold.dart';
import 'package:poster_stock/features/auth/state_holders/code_error_state_holder.dart';
import 'package:poster_stock/features/auth/state_holders/sign_up_loading_state_holder.dart';
import 'package:poster_stock/themes/build_context_extension.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../common/widgets/app_text_field.dart';
import '../../controllers/sign_up_controller.dart';
import '../../state_holders/email_code_state_holder.dart';
import '../../state_holders/email_state_holder.dart';
import '../widgets/auth_button.dart';
import '../widgets/custom_app_bar.dart';

@RoutePage()
class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailState = ref.watch(emailStateHolderProvider);
    final loading = ref.watch(signupLoadingStateHolderProvider);
    final codeState = ref.watch(emailCodeStateHolderProvider);
    final codeErrorState = ref.watch(codeErrorStateHolderProvider);
    return CustomScaffold(
      child: Column(
        children: [
          const CustomAppBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    AppLocalizations.of(context)!.login_auth_title,
                    style: context.textStyles.title2,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    emailState ?? 'test@email.com',
                    style: context.textStyles.callout!.copyWith(
                      color: context.colors.textsSecondary,
                    ),
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context)!.login_auth_sendText,
                      style: context.textStyles.callout!.copyWith(
                        color: context.colors.textsSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  AppTextField(
                    hint: AppLocalizations.of(context)!
                        .login_signup_inputCode_hint,
                    removableWhenNotEmpty: true,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      ref.read(signUpControllerProvider).setCode(value);
                    },
                    onRemoved: () {
                      ref.read(signUpControllerProvider).removeCode();
                    },
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                    height: 13,
                    width: double.infinity,
                    child: Text(
                      codeErrorState ?? '',
                      style: context.textStyles.caption2!.copyWith(
                        color: context.colors.textsError,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  AuthButton(
                    loading: loading,
                    loadingBorderColor: context.colors.fieldsActive!,
                    text: AppLocalizations.of(context)!.login_welcome_otp,
                    disabled: codeState.isEmpty,
                    fillColor: context.colors.buttonsDisabled,
                    borderColor: context.colors.fieldsActive!,
                    pressedBorderColor: context.colors.fieldsActive!,
                    disabledTextStyle: context.textStyles.calloutBold!.copyWith(
                      color: context.colors.textsAction!.withOpacity(0.5),
                    ),
                    disabledBorderColor: Colors.transparent,
                    textStyle: context.textStyles.calloutBold!.copyWith(
                      color: context.colors.textsAction!,
                    ),
                    onTap: () async {
                      ref
                          .read(codeErrorStateHolderProvider.notifier)
                          .setValue(null);
                      print("SIGNING");
                      bool success = await ref
                          .read(signUpControllerProvider)
                          .processSignIn();
                      if (success) {
                        await ref.watch(router)!.replaceNamed('/');
                        //ref.watch(router)!.removeWhere((route) => route is AuthRoute);
                        /*ref.watch(router)!.pushAndPopUntil(
                          NavigationRoute(),
                          predicate: (route) {
                            return false;
                          },
                        );*/
                      }
                    },
                  ),
                  const Spacer(),
                  RichText(
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text:
                          AppLocalizations.of(context)!.login_welcome_privacy1,
                      style: context.textStyles.caption2,
                      children: <TextSpan>[
                        const TextSpan(text: ''),
                        TextSpan(
                          text:
                              AppLocalizations.of(context)!.login_welcome_terms,
                          style: context.textStyles.caption2!.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => launchUrlString(
                                  "https://thedirection.org/posterstock_terms",
                                ),
                        ),
                        const TextSpan(text: ''),
                        TextSpan(
                          text: AppLocalizations.of(context)!
                              .login_welcome_privacy2,
                          style: context.textStyles.caption2,
                        ),
                        const TextSpan(text: ''),
                        TextSpan(
                          text: AppLocalizations.of(context)!
                              .login_welcome_policy,
                          style: context.textStyles.caption2!.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => launchUrlString(
                                "https://thedirection.org/posterstock_privacy"),
                        ),
                        const TextSpan(text: ''),
                        TextSpan(
                          text: AppLocalizations.of(context)!
                              .login_welcome_privacy3,
                          style: context.textStyles.caption2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
