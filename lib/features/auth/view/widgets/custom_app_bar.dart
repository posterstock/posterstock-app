import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: Row(
        children: [
          const Expanded(
            child: CustomBackButton(),
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

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    this.color,
    super.key,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      onTap: () {
        print(1);
        AutoRouter.of(context).pop();
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
