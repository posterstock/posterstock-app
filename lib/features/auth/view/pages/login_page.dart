import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/common/widgets/custom_scaffold.dart';
import 'package:poster_stock/themes/build_context_extension.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../common/widgets/app_text_field.dart';
import '../../controllers/sign_up_controller.dart';
import '../../state_holders/email_code_state_holder.dart';
import '../../state_holders/email_state_holder.dart';
import '../widgets/auth_button.dart';
import '../widgets/custom_app_bar.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailState = ref.watch(emailStateHolderProvider);
    final codeState = ref.watch(emailCodeStateHolderProvider);
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
                    AppLocalizations.of(context)!.loginCode,
                    style: context.textStyles.title2,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    emailState ?? 'test@email.ru',
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
                      AppLocalizations.of(context)!.codeSent,
                      style: context.textStyles.callout!.copyWith(
                        color: context.colors.textsSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  AppTextField(
                    hint: AppLocalizations.of(context)!.pasteLoginCode,
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
                    height: 24,
                  ),
                  AuthButton(
                    text: AppLocalizations.of(context)!.contWithLoginCode,
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
                    onTap: () {},
                  ),
                  const Spacer(),
                  RichText(
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: AppLocalizations.of(context)!.privacyPolicyText1,
                      style: context.textStyles.caption2,
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              AppLocalizations.of(context)!.privacyPolicyLink1,
                          style: context.textStyles.caption2!.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => launchUrlString(
                                  "https://thedirection.org/posterstock_terms",
                                ),
                        ),
                        TextSpan(
                          text:
                              AppLocalizations.of(context)!.privacyPolicyText2,
                          style: context.textStyles.caption2,
                        ),
                        TextSpan(
                          text:
                              AppLocalizations.of(context)!.privacyPolicyLink2,
                          style: context.textStyles.caption2!.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => launchUrlString(
                                "https://thedirection.org/posterstock_privacy"),
                        ),
                        TextSpan(
                          text:
                              AppLocalizations.of(context)!.privacyPolicyText3,
                          style: context.textStyles.caption2,
                        ),
                        TextSpan(
                          text:
                              AppLocalizations.of(context)!.privacyPolicyLink3,
                          style: context.textStyles.caption2!.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () =>
                                launchUrlString("https://thedirection.org/"),
                        ),
                        TextSpan(
                          text: '.',
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
