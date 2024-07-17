import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:poster_stock/common/menu/menu_state.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class MenuDialog extends StatelessWidget {
  static Future<dynamic> showBottom(
    BuildContext context,
    MenuState state,
  ) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: context.colors.backgroundsPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      builder: (_) => MenuDialog(state),
    );
  }

  final MenuState state;

  const MenuDialog(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Material(
              color: context.colors.slidersTrack,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              child: const SizedBox(width: 36, height: 4),
            )),
        if (state.title != null)
          Text(
            state.title!,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Color(0xFF212121),
            ),
          ),
        const Gap(15),
        ...state.items
            .map(
              (it) => it is MenuItem
                  ? InkWell(
                      radius: 0,
                      borderRadius: BorderRadius.circular(0),
                      splashColor: context.colors.iconsActive,
                      onTap: () {
                        Navigator.of(context).pop();
                        it.callback();
                      },
                      child: _MenuItemWidget(it),
                    )
                  : it is MenuTitle
                      ? _MenuTitleWidget(it)
                      : const SizedBox(),
            )
            .toList(),
        SizedBox(height: MediaQuery.of(context).padding.bottom)
      ],
    );
  }
}

class _MenuItemWidget extends StatelessWidget {
  final MenuItem item;

  const _MenuItemWidget(this.item);

  @override
  Widget build(BuildContext context) {
    final color =
        item.danger ? context.colors.textsError! : context.colors.textsPrimary!;
    return SizedBox(
      height: 52,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
              height: 0, thickness: 0.5, color: context.colors.fieldsDefault),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  item.asset,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.title,
                    style: context.textStyles.bodyRegular!.copyWith(
                      color: color,
                    ),
                  ),
                )
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _MenuTitleWidget extends StatelessWidget {
  final MenuTitle item;

  const _MenuTitleWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Text(
        item.title,
        style: context.textStyles.footNote!.copyWith(
          color: context.colors.textsSecondary,
        ),
      ),
    );
  }
}
