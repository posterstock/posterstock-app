import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/widgets/custom_scaffold.dart';
import 'package:poster_stock/features/settings/controllers/change_email_controller.dart';
import 'package:poster_stock/features/settings/state_holders/change_email_state_holder.dart';
import 'package:poster_stock/navigation/app_router.gr.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class ChangeEmailScreen extends ConsumerWidget {
  ChangeEmailScreen({Key? key}) : super(key: key);

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(changeEmailStateHolderProvider);
    if (controller.text != email) {
      controller.text = email;
    }
    return CustomScaffold(
      backgroundColor: context.colors.backgroundsSecondary,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
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
                titleSpacing: 0,
                centerTitle: true,
                leading: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      AutoRouter.of(context).pop();
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
                  'Change Email',
                  style: context.textStyles.bodyBold,
                ),
                actions: [
                  CupertinoButton(
                    onPressed: () {
                      ref
                          .read(changeEmailControllerProvider)
                          .updateEmail(controller.text);
                      if (checkEmail(controller.text)) {
                        AutoRouter.of(context).push(
                          ChangeEmailCodeScreen(),
                        );
                      }
                    },
                    child: Text('Next'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  //TODO email
                  'Your current email is test@test.com. What would you like to update it to? Your email is not  displayed in your public profile on Posterstock.',
                  style: context.textStyles.footNote!
                      .copyWith(color: context.colors.textsSecondary),
                ),
              ),
              const SizedBox(height: 24),
              Divider(
                height: 1,
                thickness: 1,
                color: context.colors.fieldsDefault,
              ),
              SizedBox(
                height: 47,
                child: TextField(
                  controller: controller,
                  onSubmitted: (value) {
                    ref.read(changeEmailControllerProvider).updateEmail(value);
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: context.colors.backgroundsPrimary,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 12.0),
                    suffixIcon: email.isEmpty
                        ? null
                        : (checkEmail(email)
                            ? Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: SvgPicture.asset(
                                  'assets/icons/ic_check.svg',
                                  colorFilter: ColorFilter.mode(
                                    context.colors.iconsActive!,
                                    BlendMode.srcIn,
                                  ),
                                  width: 24,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  ref
                                      .read(changeEmailControllerProvider)
                                      .updateEmail('');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SvgPicture.asset(
                                    'assets/icons/ic_close.svg',
                                    colorFilter: ColorFilter.mode(
                                      context.colors.textsError!,
                                      BlendMode.srcIn,
                                    ),
                                    width: 24,
                                  ),
                                ),
                              )),
                  ),
                  style: context.textStyles.callout!.copyWith(
                      color: checkEmail(email) || email.isEmpty
                          ? context.colors.textsAction
                          : context.colors.textsError),
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: context.colors.fieldsDefault,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool checkEmail(String value) {
    RegExp regExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    );
    return regExp.hasMatch(value);
  }
}
