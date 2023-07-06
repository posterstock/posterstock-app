import 'package:auto_route/annotations.dart';
import 'package:poster_stock/features/auth/view/pages/login_page.dart';
import 'package:poster_stock/features/auth/view/pages/sign_up_page.dart';
import 'package:poster_stock/features/bookmarks/view/pages/bookmarks_page.dart';
import 'package:poster_stock/features/edit_profile/view/view/pages/edit_profile_page.dart';
import 'package:poster_stock/features/home/view/pages/home_page.dart';
import 'package:poster_stock/features/navigation_page/view/navigation_page.dart';
import 'package:poster_stock/features/notifications/view/pages/notifications_page.dart';
import 'package:poster_stock/features/poster/view/pages/poster_page/poster_page.dart';
import 'package:poster_stock/features/profile/view/pages/profile_page.dart';
import 'package:poster_stock/features/search/view/pages/search_page.dart';
import 'package:poster_stock/features/settings/view/screens/change_email_%20code_screen.dart';
import 'package:poster_stock/features/settings/view/screens/change_email_screen.dart';
import 'package:poster_stock/features/settings/view/screens/choose_language_page.dart';
import 'package:poster_stock/features/settings/view/screens/settings_page.dart';

import '../features/auth/view/pages/auth_page.dart';
import '../features/list/view/list_page.dart';

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
    AutoRoute(page: ListPage, path: 'collection'),
    AutoRoute(page: ProfilePage, path: 'profile'),
    AutoRoute(page: SettingsPage, path: 'settings'),
    AutoRoute(page: ChooseLanguagePage, path: 'language'),
    AutoRoute(page: ChangeEmailScreen, path: 'change_email'),
    AutoRoute(page: ChangeEmailCodeScreen, path: 'change_email_code'),
    AutoRoute(page: EditProfilePage, path: 'edit_profile'),
    AutoRoute(page: BookmarksPage, path: 'bookmarks'),
  ],
)
class $AppRouter {}
