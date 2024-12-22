import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class PaymentButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final double paymentAmount;
  final Function()? onTap; // Добавлен final
  final bool isTon;
  final bool isTonConnect;

  const PaymentButton({
    // теперь const конструктор возможен
    super.key,
    required this.isLoading,
    required this.paymentAmount,
    required this.onTap,
    required this.text,
    this.isTon = true,
    this.isTonConnect = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: 51,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isLoading
              ? context.colors.buttonsPrimary?.withOpacity(0.4)
              : context.colors.buttonsPrimary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: isLoading
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    context.colors.textsBackground!),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: context.textStyles.calloutBold!.copyWith(
                      color: context.colors.textsBackground,
                    ),
                  ),
                  if (isTon) const Gap(4),
                  if (isTon)
                    SvgPicture.asset(
                      'assets/icons/ton_white.svg',
                    ),
                ],
              ),
      ),
    );
  }
}
