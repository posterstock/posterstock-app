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
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:flutter/material.dart' as _i10;

import '../features/auth/view/pages/auth_page.dart' as _i1;
import '../features/auth/view/pages/login_page.dart' as _i3;
import '../features/auth/view/pages/sign_up_page.dart' as _i2;
import '../features/home/view/pages/home_page.dart' as _i5;
import '../features/navigation_page/view/navigation_page.dart' as _i4;
import '../features/notifications/view/pages/notifications_page.dart' as _i7;
import '../features/profile/view/pages/profile_page.dart' as _i8;
import '../features/search/view/pages/search_page.dart' as _i6;

class AppRouter extends _i9.RootStackRouter {
  AppRouter([_i10.GlobalKey<_i10.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i9.PageFactory> pagesMap = {
    AuthRoute.name: (routeData) {
      final args =
          routeData.argsAs<AuthRouteArgs>(orElse: () => const AuthRouteArgs());
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i1.AuthPage(key: args.key),
      );
    },
    SignUpRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.SignUpPage(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i3.LoginPage(),
      );
    },
    NavigationRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i4.NavigationPage(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i5.HomePage(),
      );
    },
    SearchRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i6.SearchPage(),
      );
    },
    NotificationsRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i7.NotificationsPage(),
      );
    },
    ProfileRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i8.ProfilePage(),
      );
    },
  };

  @override
  List<_i9.RouteConfig> get routes => [
        _i9.RouteConfig(
          '/#redirect',
          path: '/',
          redirectTo: 'auth',
          fullMatch: true,
        ),
        _i9.RouteConfig(
          AuthRoute.name,
          path: 'auth',
        ),
        _i9.RouteConfig(
          SignUpRoute.name,
          path: 'sign_up',
        ),
        _i9.RouteConfig(
          LoginRoute.name,
          path: 'login',
        ),
        _i9.RouteConfig(
          NavigationRoute.name,
          path: 'navigation',
          children: [
            _i9.RouteConfig(
              HomeRoute.name,
              path: 'home',
              parent: NavigationRoute.name,
            ),
            _i9.RouteConfig(
              SearchRoute.name,
              path: 'search',
              parent: NavigationRoute.name,
            ),
            _i9.RouteConfig(
              NotificationsRoute.name,
              path: 'notifications',
              parent: NavigationRoute.name,
            ),
            _i9.RouteConfig(
              ProfileRoute.name,
              path: 'profile',
              parent: NavigationRoute.name,
            ),
          ],
        ),
      ];
}

/// generated route for
/// [_i1.AuthPage]
class AuthRoute extends _i9.PageRouteInfo<AuthRouteArgs> {
  AuthRoute({_i10.Key? key})
      : super(
          AuthRoute.name,
          path: 'auth',
          args: AuthRouteArgs(key: key),
        );

  static const String name = 'AuthRoute';
}

class AuthRouteArgs {
  const AuthRouteArgs({this.key});

  final _i10.Key? key;

  @override
  String toString() {
    return 'AuthRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i2.SignUpPage]
class SignUpRoute extends _i9.PageRouteInfo<void> {
  const SignUpRoute()
      : super(
          SignUpRoute.name,
          path: 'sign_up',
        );

  static const String name = 'SignUpRoute';
}

/// generated route for
/// [_i3.LoginPage]
class LoginRoute extends _i9.PageRouteInfo<void> {
  const LoginRoute()
      : super(
          LoginRoute.name,
          path: 'login',
        );

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i4.NavigationPage]
class NavigationRoute extends _i9.PageRouteInfo<void> {
  const NavigationRoute({List<_i9.PageRouteInfo>? children})
      : super(
          NavigationRoute.name,
          path: 'navigation',
          initialChildren: children,
        );

  static const String name = 'NavigationRoute';
}

/// generated route for
/// [_i5.HomePage]
class HomeRoute extends _i9.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: 'home',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i6.SearchPage]
class SearchRoute extends _i9.PageRouteInfo<void> {
  const SearchRoute()
      : super(
          SearchRoute.name,
          path: 'search',
        );

  static const String name = 'SearchRoute';
}

/// generated route for
/// [_i7.NotificationsPage]
class NotificationsRoute extends _i9.PageRouteInfo<void> {
  const NotificationsRoute()
      : super(
          NotificationsRoute.name,
          path: 'notifications',
        );

  static const String name = 'NotificationsRoute';
}

/// generated route for
/// [_i8.ProfilePage]
class ProfileRoute extends _i9.PageRouteInfo<void> {
  const ProfileRoute()
      : super(
          ProfileRoute.name,
          path: 'profile',
        );

  static const String name = 'ProfileRoute';
}
