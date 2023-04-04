import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/common/widgets/app_text_field.dart';
import 'package:poster_stock/features/auth/controllers/sign_up_controller.dart';
import 'package:poster_stock/features/auth/state_holders/email_code_state_holder.dart';
import 'package:poster_stock/features/auth/state_holders/email_state_holder.dart';
import 'package:poster_stock/features/auth/state_holders/name_state_holder.dart';
import 'package:poster_stock/features/auth/state_holders/sign_up_username_error_state_holder.dart';
import 'package:poster_stock/features/auth/state_holders/username_state_holder.dart';
import 'package:poster_stock/features/auth/view/widgets/auth_button.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

import '../../../../common/widgets/custom_scaffold.dart';
import '../widgets/custom_app_bar.dart';

class SignUpPage extends ConsumerWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailState = ref.watch(emailStateHolderProvider);
    final nameState = ref.watch(nameStateHolderProvider);
    final codeState = ref.watch(emailCodeStateHolderProvider);
    final usernameState = ref.watch(usernameStateHolderProvider);
    final usernameErrorState =
        ref.watch(signUpUsernameErrorStateHolderProvider);
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
                    AppLocalizations.of(context)!.signUpCode,
                    style: context.textStyles.title2,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    emailState!,
                    style: context.textStyles.callout!.copyWith(
                      color: context.colors.textsSecondary,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  AppTextField(
                    hint: AppLocalizations.of(context)!.name,
                    onChanged: (value) {
                      ref.read(signUpControllerProvider).setName(value);
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  AppTextField(
                    hint: AppLocalizations.of(context)!.username,
                    removableWhenNotEmpty: true,
                    tickOnSuccess: true,
                    hasError: usernameErrorState != null,
                    onChanged: (value) {
                      final validCharacters = RegExp(r'[a-zA-Z0-9_.]+$');
                      ref.read(signUpControllerProvider).setUsername(value);
                      for (int i = 0; i < value.length; i++) {
                        if (!validCharacters.hasMatch(value[i])) {
                          ref
                              .read(signUpControllerProvider)
                              .setWrongSymbolsErrorUsername();
                          return;
                        }
                      }
                      ref.read(signUpControllerProvider).removeUsernameError();
                    },
                    onRemoved: () {
                      ref.read(signUpControllerProvider).removeUsernameError();
                      ref.read(signUpControllerProvider).setUsername('');
                    },
                    isUsername: true,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  SizedBox(
                    height: 13,
                    width: double.infinity,
                    child: Text(
                      usernameErrorState ?? '',
                      style: context.textStyles.caption2!.copyWith(
                        color: context.colors.textsError,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    AppLocalizations.of(context)!.codeSent,
                    style: context.textStyles.callout!.copyWith(
                      color: context.colors.textsSecondary,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
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
                    text: AppLocalizations.of(context)!.createAccount,
                    disabled: usernameErrorState != null ||
                        usernameState.length < 2 ||
                        nameState.isEmpty ||
                        codeState.isEmpty,
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
                  Text(
                    AppLocalizations.of(context)!.privacyPolicy,
                    style: context.textStyles.caption2,
                    textAlign: TextAlign.center,
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
