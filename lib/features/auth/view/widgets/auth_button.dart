import 'package:flutter/material.dart';
import 'package:poster_stock/common/widgets/progress_border.dart';
import 'package:poster_stock/themes/build_context_extension.dart';
import 'package:poster_stock/themes/constants.dart';

class AuthButton extends StatefulWidget {
  const AuthButton({
    Key? key,
    required this.onTap,
    this.child,
    this.text,
    this.loading = false,
    this.disabled = false,
    this.fillColor,
    this.borderColor,
    this.pressedBorderColor,
    this.loadingBorderColor,
    this.disabledBorderColor,
    this.textStyle,
    this.pressedTextStyle,
    this.disabledTextStyle,
  })  : assert(
          !(text != null && child != null),
        ),
        super(key: key);

  final Widget? child;
  final String? text;
  final bool loading;
  final bool disabled;
  final void Function() onTap;
  final Color? fillColor;
  final Color? borderColor;
  final Color? pressedBorderColor;
  final Color? disabledBorderColor;
  final Color? loadingBorderColor;
  final TextStyle? textStyle;
  final TextStyle? pressedTextStyle;
  final TextStyle? disabledTextStyle;

  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton>
    with SingleTickerProviderStateMixin {
  Color? borderColor;
  TextStyle? textStyle;
  late AnimationController controller;

  @override
  void initState() {
    print(1);
    controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AuthButton oldWidget) {
    if (oldWidget.disabled || widget.fillColor == null) {
      borderColor = null;
      textStyle = null;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.loading) {
      controller.repeat(
        min: 0,
        max: 1,
        period: Duration(milliseconds: 2000),
      );
    }
    if (widget.disabled) {
      borderColor = widget.disabledBorderColor;
      textStyle = widget.disabledTextStyle;
    }
    borderColor ??= widget.borderColor;
    borderColor ??= context.colors.fieldsDefault!;
    textStyle ??= widget.textStyle;
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        Constants.borderRadiusButton,
      ),
      child: Material(
        color: context.colors.backgroundsPrimary,
        child: InkWell(
          onTap: widget.disabled || widget.loading ? null : widget.onTap,
          onTapDown: widget.disabled
              ? null
              : (details) {
                  setState(() {
                    borderColor = widget.pressedBorderColor ??
                        context.colors.textsPrimary!;
                    textStyle = widget.pressedTextStyle;
                  });
                },
          onTapCancel: () {
            setState(() {
              borderColor = widget.borderColor ?? context.colors.fieldsDefault!;
              textStyle = widget.textStyle;
            });
          },
          onTapUp: (details) {
            setState(() {
              borderColor = widget.borderColor ?? context.colors.fieldsDefault!;
              textStyle = widget.textStyle;
            });
          },
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, value) {
              return Container(
                height: Constants.fieldsAndButtonsHeight,
                decoration: BoxDecoration(
                  color: widget.fillColor,
                  borderRadius: BorderRadius.circular(
                    Constants.borderRadiusButton,
                  ),
                  border: widget.loading
                      ? ProgressBorder.all(
                          color: widget.loadingBorderColor ??
                              context.colors.textsPrimary!,
                          width: 1.5,
                          progressStart: controller.value,
                          progressEnd: controller.value + 0.5,
                          bgStrokeColor: widget.disabledBorderColor ??
                              context.colors.fieldsDefault!,
                        )
                      : Border.all(
                          color: borderColor!,
                          width: 1.5,
                        ),
                ),
                child: Center(
                  child: widget.child ??
                      Text(
                        widget.text ?? 'Default button',
                        style: textStyle,
                      ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
