import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/widgets/custom_scaffold.dart';
import 'package:poster_stock/features/auth/state_holders/email_code_state_holder.dart';
import 'package:poster_stock/features/settings/controllers/change_email_controller.dart';
import 'package:poster_stock/features/settings/state_holders/change_email_code_state_holder.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class ChangeEmailCodeScreen extends ConsumerWidget {
  ChangeEmailCodeScreen({Key? key}) : super(key: key);

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final code = ref.watch(changeEmailCodeStateHolderProvider);
    return CustomScaffold(
      backgroundColor: context.colors.backgroundsSecondary,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                backgroundColor: context.colors.backgroundsSecondary,
                elevation: 0,
                leadingWidth: 130,
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
                titleSpacing: 0,
                centerTitle: true,
                title: Text(
                  'We sent you a code',
                  style: context.textStyles.bodyBold,
                ),
                actions: [
                  CupertinoButton(
                    onPressed: code.length < 4 ? null : () {},
                    child: const Text('Verify'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Enter it below to verify your email.',
                  style: context.textStyles.footNote!
                      .copyWith(color: context.colors.textsSecondary),
                ),
              ),
              const SizedBox(height: 60),
              Divider(
                height: 1,
                thickness: 1,
                color: context.colors.fieldsDefault,
              ),
              SizedBox(
                height: 47,
                child: TextField(
                  keyboardType: TextInputType.phone,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: controller,
                  onChanged: (value) {
                    ref.read(changeEmailControllerProvider).updateCode(value);
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: context.colors.backgroundsPrimary,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 12.0,
                    ),
                  ),
                  style: context.textStyles.callout!.copyWith(
                    color: context.colors.textsPrimary,
                  ),
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
