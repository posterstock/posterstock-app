import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

import '../../../../common/state_holders/router_state_holder.dart';

class CustomAppBar extends ConsumerWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 42,
      child: Row(
        children: [
          const Expanded(
            child: CustomBackButtonWithWord(),
          ),
          Expanded(
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/logo.svg',
                width: 30,
              ),
            ),
          ),
          const Expanded(
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}

/// кнопка назад с надписью назад
class CustomBackButtonWithWord extends ConsumerWidget {
  const CustomBackButtonWithWord({
    this.color,
    this.addOnTap,
    super.key,
  });

  final Color? color;
  final Future<void> Function()? addOnTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      highlightColor: Colors.transparent,
      onTap: () async {
        if (addOnTap != null) {
          await addOnTap!();
        }
        if (context.mounted) {
          ref.watch(router)!.pop();
        }
      },
      child: SizedBox(
        height: double.infinity,
        child: Row(
          children: [
            const SizedBox(width: 9),
            SvgPicture.asset(
              'assets/icons/back_icon.svg',
              width: 18,
              colorFilter: ColorFilter.mode(
                color ?? context.colors.iconsDefault!,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              AppLocalizations.of(context)!.back,
              style: context.textStyles.bodyRegular!.copyWith(color: color),
            )
          ],
        ),
      ),
    );
  }
}

/// кнопка назад без надписи
class CustomBackButton extends ConsumerWidget {
  const CustomBackButton({
    this.color,
    this.addOnTap,
    super.key,
  });

  final Color? color;
  final Future<void> Function()? addOnTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        highlightColor: Colors.transparent,
        onTap: () async {
          if (addOnTap != null) {
            await addOnTap!();
          }
          if (context.mounted) {
            ref.watch(router)!.pop();
          }
        },
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.only(left: 16.0, right: 20.0),
          child: SvgPicture.asset(
            'assets/icons/back_icon.svg',
            width: 18,
            colorFilter: ColorFilter.mode(
              color ?? context.colors.iconsDefault!,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
