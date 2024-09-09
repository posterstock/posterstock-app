import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poster_stock/common/data/token_keeper.dart';
import 'package:poster_stock/common/state_holders/router_state_holder.dart';
import 'package:poster_stock/common/widgets/app_snack_bar.dart';
import 'package:poster_stock/common/widgets/custom_scaffold.dart';
import 'package:poster_stock/features/navigation_page/controller/menu_controller.dart';
import 'package:poster_stock/features/navigation_page/state_holder/menu_state_holder.dart';
import 'package:poster_stock/features/navigation_page/state_holder/previous_page_state_holder.dart';
import 'package:poster_stock/features/navigation_page/view/widgets/bottom_nav_bar.dart';
import 'package:poster_stock/features/notifications/state_holders/notifications_count_state_holder.dart';
import 'package:poster_stock/features/poster/state_holder/page_transition_controller_state_holder.dart';
import 'package:poster_stock/features/poster_dialog/controller/create_poster_controller.dart';
import 'package:poster_stock/features/poster_dialog/view/poster_dialog.dart';
import 'package:poster_stock/features/profile/controllers/profile_controller.dart';
import 'package:poster_stock/main.dart';
import 'package:poster_stock/navigation/app_router.gr.dart';
import 'package:poster_stock/themes/build_context_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey navigationKey = GlobalKey();

@RoutePage()
class NavigationPage extends ConsumerWidget {
  NavigationPage({Key? key}) : super(key: navigationKey);

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future(() async {
      ref.read(profileControllerApiProvider).getUserInfo(null, context);
      final prefs = await SharedPreferences.getInstance();
      int count = prefs.getInt('notification_count') ?? 0;
      ref
          .read(notificationsCountStateHolderProvider.notifier)
          .updateState(count);
    });
    var rtr = ref.watch(router);
    rtr?.addListener(() {
      if (TokenKeeper.token == null) {
        if (rtr.topRoute.path == '/') {
          rtr.replaceNamed(
            '/auth',
          );
        }
      }
    });
    Future(() {
      if (TokenKeeper.token == null) {
        rtr?.replaceNamed(
          '/auth',
        );
        scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBars.build(context, null, "Authentication error"));
      }
    });
    final pageTransitionController =
        ref.watch(pageTransitionControllerStateHolder);

    if (pageTransitionController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return AnimatedBuilder(
      animation: pageTransitionController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            -MediaQuery.of(context).size.width * 0.3 +
                pageTransitionController.value *
                    MediaQuery.of(context).size.width *
                    0.3,
            0,
          ),
          child: child,
        );
      },
      child: AutoTabsRouter.pageView(
        physics: const NeverScrollableScrollPhysics(),
        routes: const [
          PageRouteInfo(HomeRoute.name),
          AccountRoute(),
        ],
        builder: (context, child, _) {
          return WillPopScope(
            onWillPop: () async {
              final pages = ref.watch(previousPageStateHolderProvider);
              if (pages.isEmpty) return true;
              ref.read(menuControllerProvider).backToPage(context, ref);
              return false;
            },
            child: Stack(
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
                      bottom: 55 + MediaQuery.of(context).padding.bottom,
                    ),
                    child: const Material(
                      color: Colors.transparent,
                      child: MenuWidget(),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
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
            // LayerCircle(
            //   width: width,
            //   bottomPaddingMul: 1.56,
            //   radiusMul: 1.8,
            //   scale: controller.value,
            // ),
            LayerCircle(
              width: width,
              bottomPaddingMul: 2.1,
              radiusMul: 2.4,
              scale: controller.value,
            ),
            LayerCircle(
              width: width,
              bottomPaddingMul: 2.5,
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
              bottomPaddingMul: 0.29,
              color: context.colors.backgroundsPrimary!,
              hightlightColor: context.colors.textsPrimary!.withOpacity(0.2),
              iconColor: context.colors.iconsActive!,
              border: Border.all(
                color: context.colors.fieldsHover!,
              ),
              picturePath: 'assets/icons/ic_bookmarks.svg',
              label: AppLocalizations.of(context)!.watchlistAdd_bookmark,
              animationValue: controller.value,
              onTap: () {
                showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16.0)),
                  ),
                  context: context,
                  // backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  useSafeArea: true,
                  // enableDrag: true,
                  builder: (context) => const PosterDialog(
                    bookmark: true,
                  ),
                ).whenComplete(() {
                  ref.read(createPosterControllerProvider).choosePoster(null);
                  ref.read(createPosterControllerProvider).chooseMovie(null);
                  ref.read(createPosterControllerProvider).updateSearch('');
                });
              },
            ),
            MenuButton(
              width: width,
              bottomPaddingMul: 0.595,
              color: context.colors.backgroundsPrimary!,
              hightlightColor: context.colors.textsPrimary!.withOpacity(0.2),
              iconColor: context.colors.iconsActive!,
              border: Border.all(
                color: context.colors.fieldsHover!,
              ),
              picturePath: 'assets/icons/ic_collection.svg',
              label: context.txt.search_add_poster_title,
              animationValue: controller.value,
              onTap: () {
                showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16.0)),
                  ),
                  context: context,
                  // backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  useSafeArea: true,
                  // enableDrag: true,
                  builder: (context) => const PosterDialog(),
                ).whenComplete(() {
                  ref.read(createPosterControllerProvider).choosePoster(null);
                  ref.read(createPosterControllerProvider).chooseMovie(null);
                  ref.read(createPosterControllerProvider).updateSearch('');
                });
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
                            width: 28.0,
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
