import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/widgets/custom_scaffold.dart';
import 'package:poster_stock/features/create_bookmark/view/create_bookmark.dart';
import 'package:poster_stock/features/create_list/view/create_list_dialog.dart';
import 'package:poster_stock/features/create_poster/view/create_poster_dialog.dart';
import 'package:poster_stock/features/navigation_page/controller/menu_controller.dart';
import 'package:poster_stock/features/navigation_page/state_holder/menu_state_holder.dart';
import 'package:poster_stock/features/navigation_page/view/widgets/bottom_nav_bar.dart';
import 'package:poster_stock/navigation/app_router.gr.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.pageView(
      physics: const NeverScrollableScrollPhysics(),
      routes: [
        const HomeRoute(),
        SearchRoute(),
        const NotificationsRoute(),
        ProfileRoute(),
      ],
      builder: (context, child, _) {
        return Stack(
          children: [
            CustomScaffold(
              bottomNavBar: const SafeArea(child: AppNavigationBar()),
              child: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness:
                      Theme.of(context).brightness == Brightness.light
                          ? Brightness.dark
                          : Brightness.light,
                  statusBarBrightness: Theme.of(context).brightness,
                ),
                child: SafeArea(
                  child: child,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: 57 + MediaQuery.of(context).padding.bottom,
                ),
                child: const Material(
                  color: Colors.transparent,
                  child: MenuWidget(),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

class MenuWidget extends ConsumerStatefulWidget {
  const MenuWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends ConsumerState<MenuWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool val = ref.watch(menuStateHolderProvider);
    if (val && controller.value != controller.upperBound) {
      controller.forward();
    } else if (!val && controller.value != controller.lowerBound) {
      controller.reverse();
    }
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        if (controller.value == controller.lowerBound) return const SizedBox();
        return Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    context.colors.backgroundsPrimary!.withOpacity(0),
                    context.colors.backgroundsPrimary!
                        .withOpacity(controller.value),
                  ],
                  begin: Alignment.topCenter,
                  end: const Alignment(0.5, 0.3),
                ),
              ),
            ),
            LayerCircle(
              width: width,
              bottomPaddingMul: 1.56,
              radiusMul: 1.8,
              scale: controller.value,
            ),
            LayerCircle(
              width: width,
              bottomPaddingMul: 1.91,
              radiusMul: 2.4,
              scale: controller.value,
            ),
            LayerCircle(
              width: width,
              bottomPaddingMul: 2.35,
              radiusMul: 3.1,
              scale: controller.value,
            ),
            GestureDetector(
              onTap: () {
                ref.read(menuControllerProvider).switchMenu();
              },
              child: Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.transparent,
              ),
            ),
            MenuButton(
              width: width,
              bottomPaddingMul: 0.24,
              color: context.colors.backgroundsDropAction!,
              hightlightColor: context.colors.textsPrimary!.withOpacity(0.2),
              iconColor: context.colors.iconsBackground!,
              picturePath: 'assets/icons/ic_collection.svg',
              label: AppLocalizations.of(context)!.addPoster,
              animationValue: controller.value,
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    useSafeArea: true,
                    builder: (context) => const CreatePosterDialog(),
                );
              },
            ),
            MenuButton(
              width: width,
              bottomPaddingMul: 0.49,
              color: context.colors.backgroundsPrimary!,
              hightlightColor: context.colors.textsPrimary!.withOpacity(0.2),
              iconColor: context.colors.iconsActive!,
              border: Border.all(
                color: context.colors.fieldsHover!,
              ),
              picturePath: 'assets/icons/ic_bookmarks.svg',
              label: AppLocalizations.of(context)!.createBookmark,
              animationValue: controller.value,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (context) => const CreateBookmarkDialog(),
                );
              },
            ),
            MenuButton(
              width: width,
              bottomPaddingMul: 0.745,
              color: context.colors.backgroundsPrimary!,
              hightlightColor: context.colors.textsPrimary!.withOpacity(0.2),
              iconColor: context.colors.iconsActive!,
              border: Border.all(
                color: context.colors.fieldsHover!,
              ),
              picturePath: 'assets/icons/ic_lists.svg',
              label: AppLocalizations.of(context)!.createList,
              animationValue: controller.value,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (context) => const CreateListDialog(),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({
    super.key,
    required this.width,
    required this.bottomPaddingMul,
    required this.color,
    required this.hightlightColor,
    required this.iconColor,
    required this.picturePath,
    required this.onTap,
    this.border,
    required this.label,
    this.animationValue = 0,
  });

  final double width;
  final double bottomPaddingMul; //0.24
  final Color color; //backgroundDropAction
  final Color hightlightColor; //textsPrimary!.withOpacity(0.2)
  final Color iconColor; //iconsBackground
  final String picturePath; //assets/icons/ic_collection.svg
  final Border? border;
  final String label;
  final double animationValue;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: width * bottomPaddingMul - 54,
      left: 0,
      right: 0,
      child: Center(
        child: Opacity(
          opacity: animationValue,
          child: Column(
            children: [
              Transform.scale(
                scale: animationValue,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: border,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Material(
                      color: color,
                      child: InkWell(
                        highlightColor: hightlightColor,
                        onTap: onTap,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SvgPicture.asset(
                            picturePath,
                            colorFilter: ColorFilter.mode(
                              iconColor,
                              BlendMode.srcIn,
                            ),
                            width: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                label,
                style: context.textStyles.footNote!,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LayerCircle extends StatelessWidget {
  const LayerCircle({
    super.key,
    required this.width,
    required this.bottomPaddingMul,
    required this.radiusMul,
    this.scale = 1,
  });

  final double width;
  final double bottomPaddingMul;
  final double radiusMul;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -width * bottomPaddingMul,
      left: (-width * radiusMul + width) / 2,
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: width * radiusMul,
          height: width * radiusMul,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: context.colors.fieldsDefault!,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
