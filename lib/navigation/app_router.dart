import 'package:auto_route/annotations.dart';
import 'package:poster_stock/features/auth/view/pages/login_page.dart';
import 'package:poster_stock/features/auth/view/pages/sign_up_page.dart';
import 'package:poster_stock/features/home/view/pages/home_page.dart';
import 'package:poster_stock/features/navigation_page/view/navigation_page.dart';
import 'package:poster_stock/features/notifications/view/pages/notifications_page.dart';
import 'package:poster_stock/features/poster/view/pages/poster_page/poster_page.dart';
import 'package:poster_stock/features/profile/view/pages/profile_page.dart';
import 'package:poster_stock/features/search/view/pages/search_page.dart';

import '../features/auth/view/pages/auth_page.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      page: AuthPage,
      initial: true,
      path: 'auth',
    ),
    AutoRoute(page: SignUpPage, path: 'sign_up'),
    AutoRoute(page: LoginPage, path: 'login'),
    AutoRoute(
      page: NavigationPage,
      path: 'navigation',
      children: [
        AutoRoute(page: HomePage, path: 'home'),
        AutoRoute(page: SearchPage, path: 'search'),
        AutoRoute(page: NotificationsPage, path: 'notifications'),
        AutoRoute(page: ProfilePage, path: 'profile'),
      ],
    ),
    AutoRoute(page: PosterPage, path: 'poster'),
    AutoRoute(page: ProfilePage, path: 'profile'),
  ],
)
class $AppRouter {}
