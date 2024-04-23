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

@RoutePage()
class ChooseLanguagePage extends ConsumerWidget {
  const ChooseLanguagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(chosenLanguageStateHolder);
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
                  context.txt.settings_language,
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
                          ref
                              .read(chosenLanguageStateHolder.notifier)
                              .setLocale(Languages.german());
                        },
                        () {
                          ref
                              .read(chosenLanguageStateHolder.notifier)
                              .setLocale(Languages.english());
                        },
                        () {
                          ref
                              .read(chosenLanguageStateHolder.notifier)
                              .setLocale(Languages.french());
                        },
                        () {
                          ref
                              .read(chosenLanguageStateHolder.notifier)
                              .setLocale(Languages.russian());
                        },
                        () {
                          ref
                              .read(chosenLanguageStateHolder.notifier)
                              .setLocale(Languages.turkish());
                        },
                      ],
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Deutsch',
                              style: context.textStyles.bodyRegular,
                            ),
                            if (language?.locale.languageCode == 'de')
                              Text(
                                //TODO: localize
                                '􀆅',
                                style: context.textStyles.headline!.copyWith(
                                  color: context.colors.iconsActive,
                                ),
                              ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'English',
                              style: context.textStyles.bodyRegular,
                            ),
                            if (language?.locale.languageCode == 'en')
                              Text(
                                '􀆅',
                                style: context.textStyles.headline!.copyWith(
                                  color: context.colors.iconsActive,
                                ),
                              ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Français',
                              style: context.textStyles.bodyRegular,
                            ),
                            if (language?.locale.languageCode == 'fr')
                              Text(
                                //TODO: localize
                                '􀆅',
                                style: context.textStyles.headline!.copyWith(
                                  color: context.colors.iconsActive,
                                ),
                              ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Русский',
                              style: context.textStyles.bodyRegular,
                            ),
                            if (language?.locale.languageCode == 'ru')
                              Text(
                                //TODO: localize
                                '􀆅',
                                style: context.textStyles.headline!.copyWith(
                                  color: context.colors.iconsActive,
                                ),
                              ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Türkçe',
                              style: context.textStyles.bodyRegular,
                            ),
                            if (language?.locale.languageCode == 'tr')
                              Text(
                                //TODO: localize
                                '􀆅',
                                style: context.textStyles.headline!.copyWith(
                                  color: context.colors.iconsActive,
                                ),
                              ),
                          ],
                        )
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
