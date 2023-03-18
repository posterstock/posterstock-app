import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomAppBar(),
              const SizedBox(
                height: 30,
              ),
              Text(
                'Sign up code',
                style: context.textStyles.title2,
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'Sign up code',
                style: context.textStyles.title2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
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
                        context.colors.iconsDefault!,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 9.58),
                    Text(
                      'Back',
                      style: context.textStyles.bodyRegular,
                    )
                  ],
                ),
              ),
            ),
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
