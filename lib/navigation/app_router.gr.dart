// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i15;
import 'package:flutter/material.dart' as _i16;

import '../features/auth/view/pages/auth_page.dart' as _i1;
import '../features/auth/view/pages/login_page.dart' as _i3;
import '../features/auth/view/pages/sign_up_page.dart' as _i2;
import '../features/collection/view/collection_page.dart' as _i6;
import '../features/home/models/multiple_post_model.dart' as _i18;
import '../features/home/models/post_movie_model.dart' as _i17;
import '../features/home/view/pages/home_page.dart' as _i12;
import '../features/navigation_page/view/navigation_page.dart' as _i4;
import '../features/notifications/view/pages/notifications_page.dart' as _i14;
import '../features/poster/view/pages/poster_page/poster_page.dart' as _i5;
import '../features/profile/models/user_details_model.dart' as _i19;
import '../features/profile/view/pages/profile_page.dart' as _i7;
import '../features/search/view/pages/search_page.dart' as _i13;
import '../features/settings/view/screens/change_email_%20code_screen.dart'
    as _i11;
import '../features/settings/view/screens/change_email_screen.dart' as _i10;
import '../features/settings/view/screens/choose_language_page.dart' as _i9;
import '../features/settings/view/screens/settings_page.dart' as _i8;

class AppRouter extends _i15.RootStackRouter {
  AppRouter([_i16.GlobalKey<_i16.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i15.PageFactory> pagesMap = {
    AuthRoute.name: (routeData) {
      final args =
          routeData.argsAs<AuthRouteArgs>(orElse: () => const AuthRouteArgs());
      return _i15.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i1.AuthPage(key: args.key),
      );
    },
    SignUpRoute.name: (routeData) {
      return _i15.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.SignUpPage(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i15.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i3.LoginPage(),
      );
    },
    NavigationRoute.name: (routeData) {
      return _i15.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i4.NavigationPage(),
      );
    },
    PosterRoute.name: (routeData) {
      final args = routeData.argsAs<PosterRouteArgs>();
      return _i15.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i5.PosterPage(
          key: args.key,
          post: args.post,
        ),
      );
    },
    CollectionRoute.name: (routeData) {
      final args = routeData.argsAs<CollectionRouteArgs>();
      return _i15.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i6.CollectionPage(
          key: args.key,
          post: args.post,
        ),
      );
    },
    ProfileRoute.name: (routeData) {
      final args = routeData.argsAs<ProfileRouteArgs>(
          orElse: () => const ProfileRouteArgs());
      return _i15.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i7.ProfilePage(
          key: args.key,
          user: args.user,
        ),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i15.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i8.SettingsPage(),
      );
    },
    ChooseLanguageRoute.name: (routeData) {
      return _i15.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i9.ChooseLanguagePage(),
      );
    },
    ChangeEmailScreen.name: (routeData) {
      final args = routeData.argsAs<ChangeEmailScreenArgs>(
          orElse: () => const ChangeEmailScreenArgs());
      return _i15.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i10.ChangeEmailScreen(key: args.key),
      );
    },
    ChangeEmailCodeScreen.name: (routeData) {
      final args = routeData.argsAs<ChangeEmailCodeScreenArgs>(
          orElse: () => const ChangeEmailCodeScreenArgs());
      return _i15.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i11.ChangeEmailCodeScreen(key: args.key),
      );
    },
    HomeRoute.name: (routeData) {
      return _i15.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i12.HomePage(),
      );
    },
    SearchRoute.name: (routeData) {
      final args = routeData.argsAs<SearchRouteArgs>(
          orElse: () => const SearchRouteArgs());
      return _i15.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i13.SearchPage(key: args.key),
      );
    },
    NotificationsRoute.name: (routeData) {
      return _i15.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i14.NotificationsPage(),
      );
    },
  };

  @override
  List<_i15.RouteConfig> get routes => [
        _i15.RouteConfig(
          '/#redirect',
          path: '/',
          redirectTo: 'auth',
          fullMatch: true,
        ),
        _i15.RouteConfig(
          AuthRoute.name,
          path: 'auth',
        ),
        _i15.RouteConfig(
          SignUpRoute.name,
          path: 'sign_up',
        ),
        _i15.RouteConfig(
          LoginRoute.name,
          path: 'login',
        ),
        _i15.RouteConfig(
          NavigationRoute.name,
          path: 'navigation',
          children: [
            _i15.RouteConfig(
              HomeRoute.name,
              path: 'home',
              parent: NavigationRoute.name,
            ),
            _i15.RouteConfig(
              SearchRoute.name,
              path: 'search',
              parent: NavigationRoute.name,
            ),
            _i15.RouteConfig(
              NotificationsRoute.name,
              path: 'notifications',
              parent: NavigationRoute.name,
            ),
            _i15.RouteConfig(
              ProfileRoute.name,
              path: 'profile',
              parent: NavigationRoute.name,
            ),
          ],
        ),
        _i15.RouteConfig(
          PosterRoute.name,
          path: 'poster',
        ),
        _i15.RouteConfig(
          CollectionRoute.name,
          path: 'collection',
        ),
        _i15.RouteConfig(
          ProfileRoute.name,
          path: 'profile',
        ),
        _i15.RouteConfig(
          SettingsRoute.name,
          path: 'settings',
        ),
        _i15.RouteConfig(
          ChooseLanguageRoute.name,
          path: 'language',
        ),
        _i15.RouteConfig(
          ChangeEmailScreen.name,
          path: 'change_email',
        ),
        _i15.RouteConfig(
          ChangeEmailCodeScreen.name,
          path: 'change_email_code',
        ),
      ];
}

/// generated route for
/// [_i1.AuthPage]
class AuthRoute extends _i15.PageRouteInfo<AuthRouteArgs> {
  AuthRoute({_i16.Key? key})
      : super(
          AuthRoute.name,
          path: 'auth',
          args: AuthRouteArgs(key: key),
        );

  static const String name = 'AuthRoute';
}

class AuthRouteArgs {
  const AuthRouteArgs({this.key});

  final _i16.Key? key;

  @override
  String toString() {
    return 'AuthRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i2.SignUpPage]
class SignUpRoute extends _i15.PageRouteInfo<void> {
  const SignUpRoute()
      : super(
          SignUpRoute.name,
          path: 'sign_up',
        );

  static const String name = 'SignUpRoute';
}

/// generated route for
/// [_i3.LoginPage]
class LoginRoute extends _i15.PageRouteInfo<void> {
  const LoginRoute()
      : super(
          LoginRoute.name,
          path: 'login',
        );

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i4.NavigationPage]
class NavigationRoute extends _i15.PageRouteInfo<void> {
  const NavigationRoute({List<_i15.PageRouteInfo>? children})
      : super(
          NavigationRoute.name,
          path: 'navigation',
          initialChildren: children,
        );

  static const String name = 'NavigationRoute';
}

/// generated route for
/// [_i5.PosterPage]
class PosterRoute extends _i15.PageRouteInfo<PosterRouteArgs> {
  PosterRoute({
    _i16.Key? key,
    required _i17.PostMovieModel post,
  }) : super(
          PosterRoute.name,
          path: 'poster',
          args: PosterRouteArgs(
            key: key,
            post: post,
          ),
        );

  static const String name = 'PosterRoute';
}

class PosterRouteArgs {
  const PosterRouteArgs({
    this.key,
    required this.post,
  });

  final _i16.Key? key;

  final _i17.PostMovieModel post;

  @override
  String toString() {
    return 'PosterRouteArgs{key: $key, post: $post}';
  }
}

/// generated route for
/// [_i6.CollectionPage]
class CollectionRoute extends _i15.PageRouteInfo<CollectionRouteArgs> {
  CollectionRoute({
    _i16.Key? key,
    required _i18.MultiplePostModel post,
  }) : super(
          CollectionRoute.name,
          path: 'collection',
          args: CollectionRouteArgs(
            key: key,
            post: post,
          ),
        );

  static const String name = 'CollectionRoute';
}

class CollectionRouteArgs {
  const CollectionRouteArgs({
    this.key,
    required this.post,
  });

  final _i16.Key? key;

  final _i18.MultiplePostModel post;

  @override
  String toString() {
    return 'CollectionRouteArgs{key: $key, post: $post}';
  }
}

/// generated route for
/// [_i7.ProfilePage]
class ProfileRoute extends _i15.PageRouteInfo<ProfileRouteArgs> {
  ProfileRoute({
    _i16.Key? key,
    _i19.UserDetailsModel? user,
  }) : super(
          ProfileRoute.name,
          path: 'profile',
          args: ProfileRouteArgs(
            key: key,
            user: user,
          ),
        );

  static const String name = 'ProfileRoute';
}

class ProfileRouteArgs {
  const ProfileRouteArgs({
    this.key,
    this.user,
  });

  final _i16.Key? key;

  final _i19.UserDetailsModel? user;

  @override
  String toString() {
    return 'ProfileRouteArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [_i8.SettingsPage]
class SettingsRoute extends _i15.PageRouteInfo<void> {
  const SettingsRoute()
      : super(
          SettingsRoute.name,
          path: 'settings',
        );

  static const String name = 'SettingsRoute';
}

/// generated route for
/// [_i9.ChooseLanguagePage]
class ChooseLanguageRoute extends _i15.PageRouteInfo<void> {
  const ChooseLanguageRoute()
      : super(
          ChooseLanguageRoute.name,
          path: 'language',
        );

  static const String name = 'ChooseLanguageRoute';
}

/// generated route for
/// [_i10.ChangeEmailScreen]
class ChangeEmailScreen extends _i15.PageRouteInfo<ChangeEmailScreenArgs> {
  ChangeEmailScreen({_i16.Key? key})
      : super(
          ChangeEmailScreen.name,
          path: 'change_email',
          args: ChangeEmailScreenArgs(key: key),
        );

  static const String name = 'ChangeEmailScreen';
}

class ChangeEmailScreenArgs {
  const ChangeEmailScreenArgs({this.key});

  final _i16.Key? key;

  @override
  String toString() {
    return 'ChangeEmailScreenArgs{key: $key}';
  }
}

/// generated route for
/// [_i11.ChangeEmailCodeScreen]
class ChangeEmailCodeScreen
    extends _i15.PageRouteInfo<ChangeEmailCodeScreenArgs> {
  ChangeEmailCodeScreen({_i16.Key? key})
      : super(
          ChangeEmailCodeScreen.name,
          path: 'change_email_code',
          args: ChangeEmailCodeScreenArgs(key: key),
        );

  static const String name = 'ChangeEmailCodeScreen';
}

class ChangeEmailCodeScreenArgs {
  const ChangeEmailCodeScreenArgs({this.key});

  final _i16.Key? key;

  @override
  String toString() {
    return 'ChangeEmailCodeScreenArgs{key: $key}';
  }
}

/// generated route for
/// [_i12.HomePage]
class HomeRoute extends _i15.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: 'home',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i13.SearchPage]
class SearchRoute extends _i15.PageRouteInfo<SearchRouteArgs> {
  SearchRoute({_i16.Key? key})
      : super(
          SearchRoute.name,
          path: 'search',
          args: SearchRouteArgs(key: key),
        );

  static const String name = 'SearchRoute';
}

class SearchRouteArgs {
  const SearchRouteArgs({this.key});

  final _i16.Key? key;

  @override
  String toString() {
    return 'SearchRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i14.NotificationsPage]
class NotificationsRoute extends _i15.PageRouteInfo<void> {
  const NotificationsRoute()
      : super(
          NotificationsRoute.name,
          path: 'notifications',
        );

  static const String name = 'NotificationsRoute';
}
