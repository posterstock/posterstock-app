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
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i5;

import '../features/auth/view/pages/auth_page.dart' as _i1;
import '../features/auth/view/pages/login_page.dart' as _i3;
import '../features/auth/view/pages/sign_up_page.dart' as _i2;

class AppRouter extends _i4.RootStackRouter {
  AppRouter([_i5.GlobalKey<_i5.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    AuthRoute.name: (routeData) {
      final args =
          routeData.argsAs<AuthRouteArgs>(orElse: () => const AuthRouteArgs());
      return _i4.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i1.AuthPage(key: args.key),
      );
    },
    SignUpRoute.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.SignUpPage(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i3.LoginPage(),
      );
    },
  };

  @override
  List<_i4.RouteConfig> get routes => [
        _i4.RouteConfig(
          AuthRoute.name,
          path: '/',
        ),
        _i4.RouteConfig(
          SignUpRoute.name,
          path: '/sign-up-page',
        ),
        _i4.RouteConfig(
          LoginRoute.name,
          path: '/login-page',
        ),
      ];
}

/// generated route for
/// [_i1.AuthPage]
class AuthRoute extends _i4.PageRouteInfo<AuthRouteArgs> {
  AuthRoute({_i5.Key? key})
      : super(
          AuthRoute.name,
          path: '/',
          args: AuthRouteArgs(key: key),
        );

  static const String name = 'AuthRoute';
}

class AuthRouteArgs {
  const AuthRouteArgs({this.key});

  final _i5.Key? key;

  @override
  String toString() {
    return 'AuthRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i2.SignUpPage]
class SignUpRoute extends _i4.PageRouteInfo<void> {
  const SignUpRoute()
      : super(
          SignUpRoute.name,
          path: '/sign-up-page',
        );

  static const String name = 'SignUpRoute';
}

/// generated route for
/// [_i3.LoginPage]
class LoginRoute extends _i4.PageRouteInfo<void> {
  const LoginRoute()
      : super(
          LoginRoute.name,
          path: '/login-page',
        );

  static const String name = 'LoginRoute';
}
