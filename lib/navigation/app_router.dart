import 'package:auto_route/auto_route.dart';
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
            AutoRoute(page: ProfileRoute.page, path: 'profile'),
          ],
        ),
    AutoRoute(page: ProfileRoute.page, path: '/:username'),
    AutoRoute(page: PosterRoute.page, path: '/:username/:id'),
    AutoRoute(page: ListRoute.page, path: '/list/:id'),
    AutoRoute(page: SettingsRoute.page, path: '/settings'),
    AutoRoute(page: ChooseLanguageRoute.page, path: '/language'),
    AutoRoute(page: ChangeEmailRoute.page, path: '/change_email'),
    AutoRoute(
        page: ChangeEmailCodeRoute.page, path: '/change_email_code'),
    AutoRoute(page: EditProfileRoute.page, path: '/edit_profile'),
    AutoRoute(page: BookmarksRoute.page, path: '/bookmarks'),
    AutoRoute(page: UsersListRoute.page, path: '/users_list'),
      ];
}
/*
@AutoRouterConfig(
  replaceInRouteName: 'Route.page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      page: AuthRoute.page,
      initial: true,
      path: 'auth',
    ),
    AutoRoute(page: SignUpRoute.page, path: 'sign_up'),
    AutoRoute(page: LoginRoute.page, path: 'login'),
    AutoRoute(
      page: NavigationRoute.page,
      path: 'navigation',
      children: [
        AutoRoute(page: HomeRoute.page, path: 'home'),
        AutoRoute(page: SearchRoute.page, path: 'search'),
        AutoRoute(page: NotificationsRoute.page, path: 'notifications'),
        AutoRoute(page: ProfileRoute.page, path: ':username'),
      ],
    ),
    AutoRoute(
      page: PosterRoute.page,
      path: ':username/:id',
    ),
    AutoRoute(page: ListRoute.page, path: 'list/:id'),
    AutoRoute(page: ProfileRoute.page, path: ':username'),
    AutoRoute(page: SettingsRoute.page, path: 'settings'),
    AutoRoute(page: ChooseLanguageRoute.page, path: 'language'),
    AutoRoute(page: ChangeEmailScreen, path: 'change_email'),
    AutoRoute(page: ChangeEmailCodeScreen, path: 'change_email_code'),
    AutoRoute(page: EditProfileRoute.page, path: 'edit_profile'),
    AutoRoute(page: BookmarksRoute.page, path: 'bookmarks'),
    AutoRoute(page: UsersListRoute.page, path: 'users_list'),
  ],
)
class $AppRouter {}
*/
