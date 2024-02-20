import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: AuthRoute.page,
          initial: true,
          path: '/auth',
          children: [
            AutoRoute(page: SignUpRoute.page, path: 'sign_up'),
            AutoRoute(page: LoginRoute.page, path: 'login'),
          ],
        ),
        AutoRoute(
          page: NavigationRoute.page,
          path: '/',
          children: [
            AutoRoute(page: HomeRoute.page, path: 'home'),
            AutoRoute(page: SearchRoute.page, path: 'search'),
            AutoRoute(page: NotificationsRoute.page, path: 'notifications'),
            // AutoRoute(page: ProfileRoute.page, path: 'profile'),
            AutoRoute(page: AccountRoute.page, path: 'account'),
          ],
        ),
        AutoRoute(page: SettingsRoute.page, path: '/settings'),
        AutoRoute(page: ChooseLanguageRoute.page, path: '/language'),
        AutoRoute(page: ChangeEmailRoute.page, path: '/change_email'),
        AutoRoute(page: ChangeEmailCodeRoute.page, path: '/change_email_code'),
        AutoRoute(page: EditProfileRoute.page, path: '/edit_profile'),
        AutoRoute(page: BookmarksRoute.page, path: '/bookmarks'),
        AutoRoute(page: UsersListRoute.page, path: '/users_list'),
        AutoRoute(page: ListRoute.page, path: '/lists/:id'),
        RedirectRoute(path: '/list/:id', redirectTo: '/lists/:id'),
        AutoRoute(page: UserRoute.page),
        CustomRoute(
          page: PosterRoute.page,
          path: '/:username/:id',
          opaque: false,
          customRouteBuilder: <PageRoute>(BuildContext context, Widget child,
              AutoRoutePage<PageRoute> page) {
            return PageRouteBuilder(
              opaque: false,
              fullscreenDialog: page.fullscreenDialog,
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return Stack(
                  children: <Widget>[
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    )
                  ],
                );
              },
              settings: page,
              pageBuilder: (_, __, ___) => child,
            );
          },
        ),
      ];
}
