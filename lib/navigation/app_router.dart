import 'package:auto_route/annotations.dart';
import 'package:poster_stock/features/auth/view/pages/sign_up_page.dart';

import '../features/auth/view/pages/auth_page.dart';

@CustomAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: AuthPage, initial: true),
    AutoRoute(page: SignUpPage),
  ],
)
class $AppRouter {}