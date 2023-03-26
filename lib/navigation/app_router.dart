import 'package:auto_route/annotations.dart';
import 'package:poster_stock/features/auth/view/pages/login_page.dart';
import 'package:poster_stock/features/auth/view/pages/sign_up_page.dart';
import 'package:poster_stock/features/home/view/pages/home_page.dart';
import 'package:poster_stock/features/navigation_page/view/navigation_page.dart';

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
    AutoRoute(page: NavigationPage, path: 'navigation', children: [
      AutoRoute(page: HomePage, path: 'home'),
    ]),
  ],
)
class $AppRouter {}
