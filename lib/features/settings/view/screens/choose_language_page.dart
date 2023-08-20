import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:poster_stock/common/constants/languages.dart';
import 'package:poster_stock/common/state_holders/router_state_holder.dart';
import 'package:poster_stock/common/widgets/custom_scaffold.dart';
import 'package:poster_stock/features/settings/state_holders/chosen_language_state_holder.dart';
import 'package:poster_stock/features/settings/view/screens/settings_page.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

import '../../controllers/app_language_controller.dart';

@RoutePage()
class ChooseLanguagePage extends ConsumerWidget {
  const ChooseLanguagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  'Language',
                  style: context.textStyles.bodyBold,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    MultipleSettingsButton(
                      onTaps: [
                        () {
                        print(Languages.english().languageName);
                          ref.read(appLanguageControllerProvider).updateLanguage(
                                Languages.english(),
                              );
                        },
                        () {
                          ref.read(appLanguageControllerProvider).updateLanguage(
                                Languages.russian(),
                              );
                        },
                      ],
                      children: [
                        Row(
                          children: [
                            Text(
                              'English',
                              style: context.textStyles.bodyRegular,
                            ),
                            const Spacer(),
                            if (ref
                                    .watch(chosenLanguageStateHolder)
                                    ?.locale
                                    .languageCode ==
                                'en')
                              Text(
                                '􀆅',
                                style: context.textStyles.headline!.copyWith(
                                  color: context.colors.iconsActive,
                                ),
                              ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Русский',
                              style: context.textStyles.bodyRegular,
                            ),
                            const Spacer(),
                            if (ref
                                    .watch(chosenLanguageStateHolder)
                                    ?.locale
                                    .languageCode ==
                                'ru')
                              Text(
                                '􀆅',
                                style: context.textStyles.headline!.copyWith(
                                  color: context.colors.iconsActive,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
