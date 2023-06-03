import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:poster_stock/common/widgets/custom_scaffold.dart';
import 'package:poster_stock/features/settings/state_holders/chosen_language_state_holder.dart';
import 'package:poster_stock/navigation/app_router.gr.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScaffold(
      backgroundColor: context.colors.backgroundsSecondary,
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
                'Settings',
                style: context.textStyles.bodyBold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  SettingsButton(
                    onTap: () {
                      AutoRouter.of(context).push(
                        const ChooseLanguageRoute(),
                      );
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Language',
                            style: context.textStyles.bodyRegular,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          ref.watch(chosenLanguageStateHolder)?.languageName ??
                              "English",
                          style: context.textStyles.bodyRegular!.copyWith(
                            color: context.colors.textsSecondary,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: context.colors.iconsDisabled,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  SettingsButton(
                    onTap: () {
                      AutoRouter.of(context).push(
                        ChangeEmailScreen(),
                      );
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Email',
                            style: context.textStyles.bodyRegular,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'itsmishakiva@outlook.com',
                          style: context.textStyles.bodyRegular!.copyWith(
                            color: context.colors.textsSecondary,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: context.colors.iconsDisabled,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  DoubleButton(
                    onTap1: () {},
                    onTap2: () {},
                    child1: Row(
                      children: [
                        Text(
                          'Connected Google Account',
                          style: context.textStyles.bodyRegular,
                        ),
                        const Spacer(),
                        Text(
                          '􀆅',
                          style: context.textStyles.headline!.copyWith(
                            color: context.colors.iconsActive,
                          ),
                        ),
                      ],
                    ),
                    child2: Row(
                      children: [
                        Text(
                          'Connected Apple Account',
                          style: context.textStyles.bodyRegular,
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Manage Google or Apple accounts to Posterstock\nto log in',
                      style: context.textStyles.footNote!.copyWith(
                        color: context.colors.textsSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  DoubleButton(
                    onTap1: () {},
                    onTap2: () {},
                    child1: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Terms of Service',
                            style: context.textStyles.bodyRegular,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: context.colors.iconsDisabled,
                        ),
                      ],
                    ),
                    child2: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Privacy Policy',
                            style: context.textStyles.bodyRegular,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: context.colors.iconsDisabled,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  SettingsButton(
                    onTap: () {},
                    child: Center(
                      child: Text(
                        'Logout',
                        style: context.textStyles.bodyRegular!.copyWith(
                          color: context.colors.textsError,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 66,
                  ),
                  Column(
                    children: [
                      Text(
                        'This product uses the TMDB API but is not endorsed or certified by TMDB',
                        textAlign: TextAlign.center,
                        style: context.textStyles.footNote!.copyWith(
                          color: context.colors.textsDisabled,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SvgPicture.asset('assets/icons/TMDB.svg'),
                      const SizedBox(
                        height: 32,
                      ),
                      FutureBuilder(
                        future: PackageInfo.fromPlatform(),
                        builder: (context, snapshot) {
                          print(snapshot.error);
                          return Text(
                            'Posterstock ${snapshot.data?.version ?? ''}',
                            textAlign: TextAlign.center,
                            style: context.textStyles.footNote!.copyWith(
                              color: context.colors.textsDisabled,
                            ),
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    Key? key,
    required this.onTap,
    required this.child,
  }) : super(key: key);
  final void Function() onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Material(
        color: context.colors.backgroundsPrimary,
        child: InkWell(
          highlightColor: Colors.transparent.withOpacity(0.1),
          onTap: onTap,
          child: SizedBox(
            height: 48,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class DoubleButton extends StatelessWidget {
  const DoubleButton(
      {Key? key,
      required this.onTap1,
      required this.child1,
      required this.onTap2,
      required this.child2})
      : super(key: key);
  final void Function() onTap1;
  final Widget child1;
  final void Function() onTap2;
  final Widget child2;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Material(
        color: context.colors.backgroundsPrimary,
        child: SizedBox(
          height: 96.5,
          child: Column(
            children: [
              Expanded(
                child: InkWell(
                  highlightColor: Colors.transparent.withOpacity(0.1),
                  onTap: onTap1,
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      child: child1,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(
                  color: context.colors.fieldsDefault,
                  height: 0.5,
                  thickness: 0.5,
                ),
              ),
              Expanded(
                child: InkWell(
                  highlightColor: Colors.transparent.withOpacity(0.1),
                  onTap: onTap2,
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      child: child2,
                    ),
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

class MultipleSettingsButton extends StatelessWidget {
  const MultipleSettingsButton({
    Key? key,
    required this.onTaps,
    required this.children,
  })  : assert(onTaps.length == children.length),
        super(key: key);
  final List<void Function()> onTaps;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Material(
        color: context.colors.backgroundsPrimary,
        child: SizedBox(
          height: 48 * children.length + (children.length - 1) * 0.5,
          child: Column(
            children: List.generate(
              children.length,
              (index) => Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: InkWell(
                        highlightColor: Colors.transparent.withOpacity(0.1),
                        onTap: onTaps[index],
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: children[index],
                          ),
                        ),
                      ),
                    ),
                    if (index != children.length - 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Divider(
                          color: context.colors.fieldsDefault,
                          height: 0.5,
                          thickness: 0.5,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
