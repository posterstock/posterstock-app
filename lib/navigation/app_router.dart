import 'package:auto_route/annotations.dart';
import 'package:poster_stock/features/auth/view/pages/login_page.dart';
import 'package:poster_stock/features/auth/view/pages/sign_up_page.dart';

import '../features/auth/view/pages/auth_page.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: AuthPage, initial: true),
    AutoRoute(page: SignUpPage),
    AutoRoute(page: LoginPage)
  ],
)
class $AppRouter {}