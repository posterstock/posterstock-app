import 'package:flutter/material.dart';
import 'package:poster_stock/common/widgets/progress_border.dart';
import 'package:poster_stock/themes/build_context_extension.dart';
import 'package:poster_stock/themes/constants.dart';

class AuthButton extends StatefulWidget {
  const AuthButton({
    Key? key,
    required this.onTap,
    this.child,
    this.loading = false,
  }) : super(key: key);

  final Widget? child;
  final bool loading;
  final void Function() onTap;

  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton>
    with SingleTickerProviderStateMixin {
  Color? borderColor;
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(vsync: this)
      ..repeat(
        min: 0,
        max: 1,
        period: Duration(milliseconds: 2000),
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    borderColor ??= context.colors.fieldsDefault!;
    return InkWell(
      //overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: widget.onTap,
      onTapDown: (details) {
        setState(() {
          borderColor = context.colors.textsPrimary!;
        });
      },
      onTapCancel: () {
        setState(() {
          borderColor = context.colors.fieldsDefault!;
        });
      },
      onTapUp: (details) {
        setState(() {
          borderColor = context.colors.fieldsDefault!;
        });
      },
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, value) {
          return Container(
            height: Constants.fieldsAndButtonsHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                Constants.borderRadiusButton,
              ),
              border: widget.loading
                  ? ProgressBorder.all(
                      color: context.colors.textsPrimary!,
                      width: 1.5,
                      progressStart: controller.value,
                      progressEnd: controller.value + 0.5,
                    )
                  : Border.all(
                      color: borderColor!,
                      width: 1.5,
                    ),
            ),
            child: Center(
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}
