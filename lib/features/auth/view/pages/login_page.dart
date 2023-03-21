import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

import '../../../../common/widgets/app_text_field.dart';
import '../../state_holders/email_state_holder.dart';
import '../widgets/auth_button.dart';
import '../widgets/custom_app_bar.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailState = ref.watch(emailStateHolderProvider);
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        child: SafeArea(
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
                        'Sign up code',
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
                          'We just sent you a temporary up code.\nPlease check your inbox.',
                          style: context.textStyles.callout!.copyWith(
                            color: context.colors.textsSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const AppTextField(
                        hint: 'Paste login code',
                        removable: true,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      AuthButton(
                        text: 'Continue with login code',
                        fillColor: context.colors.buttonsDisabled,
                        borderColor: context.colors.fieldsActive!,
                        pressedBorderColor: context.colors.fieldsActive!,
                        disabledTextStyle:
                        context.textStyles.calloutBold!.copyWith(
                          color: context.colors.textsAction!.withOpacity(0.5),
                        ),
                        disabledBorderColor: Colors.transparent,
                        textStyle: context.textStyles.calloutBold!.copyWith(
                          color: context.colors.textsAction!,
                        ),
                        onTap: () {
                          print(1);
                        },
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
        ),
      ),
    );
  }
}
