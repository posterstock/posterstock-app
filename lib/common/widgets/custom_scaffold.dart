import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    Key? key,
    required this.child,
    this.bottomNavBar,
    this.backgroundColor,
    this.resize = false,
  }) : super(key: key);
  final Widget child;
  final Widget? bottomNavBar;
  final Color? backgroundColor;
  final bool resize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? context.colors.backgroundsPrimary,
      resizeToAvoidBottomInset: resize,
      bottomNavigationBar: bottomNavBar,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              Theme.of(context).brightness == Brightness.light
                  ? Brightness.dark
                  : Brightness.light,
          statusBarBrightness: Theme.of(context).brightness,
          systemNavigationBarColor: context.colors.backgroundsPrimary,
          systemNavigationBarIconBrightness:
              Theme.of(context).brightness == Brightness.light
                  ? Brightness.dark
                  : Brightness.light,
        ),
        child: SafeArea(
          child: child,
        ),
      ),
    );
  }
}
