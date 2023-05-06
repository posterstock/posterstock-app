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
import 'package:auto_route/auto_route.dart' as _i11;
import 'package:flutter/material.dart' as _i12;

import '../features/auth/view/pages/auth_page.dart' as _i1;
import '../features/auth/view/pages/login_page.dart' as _i3;
import '../features/auth/view/pages/sign_up_page.dart' as _i2;
import '../features/collection/view/collection_page.dart' as _i6;
import '../features/home/models/multiple_post_model.dart' as _i14;
import '../features/home/models/post_movie_model.dart' as _i13;
import '../features/home/view/pages/home_page.dart' as _i8;
import '../features/navigation_page/view/navigation_page.dart' as _i4;
import '../features/notifications/view/pages/notifications_page.dart' as _i10;
import '../features/poster/view/pages/poster_page/poster_page.dart' as _i5;
import '../features/profile/models/user_details_model.dart' as _i15;
import '../features/profile/view/pages/profile_page.dart' as _i7;
import '../features/search/view/pages/search_page.dart' as _i9;

class AppRouter extends _i11.RootStackRouter {
  AppRouter([_i12.GlobalKey<_i12.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i11.PageFactory> pagesMap = {
    AuthRoute.name: (routeData) {
      final args =
          routeData.argsAs<AuthRouteArgs>(orElse: () => const AuthRouteArgs());
      return _i11.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i1.AuthPage(key: args.key),
      );
    },
    SignUpRoute.name: (routeData) {
      return _i11.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.SignUpPage(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i11.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i3.LoginPage(),
      );
    },
    NavigationRoute.name: (routeData) {
      return _i11.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i4.NavigationPage(),
      );
    },
    PosterRoute.name: (routeData) {
      final args = routeData.argsAs<PosterRouteArgs>();
      return _i11.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i5.PosterPage(
          key: args.key,
          post: args.post,
        ),
      );
    },
    CollectionRoute.name: (routeData) {
      final args = routeData.argsAs<CollectionRouteArgs>();
      return _i11.MaterialPageX<dynamic>(
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
      return _i11.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i7.ProfilePage(
          key: args.key,
          user: args.user,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return _i11.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i8.HomePage(),
      );
    },
    SearchRoute.name: (routeData) {
      final args = routeData.argsAs<SearchRouteArgs>(
          orElse: () => const SearchRouteArgs());
      return _i11.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i9.SearchPage(key: args.key),
      );
    },
    NotificationsRoute.name: (routeData) {
      return _i11.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i10.NotificationsPage(),
      );
    },
  };

  @override
  List<_i11.RouteConfig> get routes => [
        _i11.RouteConfig(
          '/#redirect',
          path: '/',
          redirectTo: 'auth',
          fullMatch: true,
        ),
        _i11.RouteConfig(
          AuthRoute.name,
          path: 'auth',
        ),
        _i11.RouteConfig(
          SignUpRoute.name,
          path: 'sign_up',
        ),
        _i11.RouteConfig(
          LoginRoute.name,
          path: 'login',
        ),
        _i11.RouteConfig(
          NavigationRoute.name,
          path: 'navigation',
          children: [
            _i11.RouteConfig(
              HomeRoute.name,
              path: 'home',
              parent: NavigationRoute.name,
            ),
            _i11.RouteConfig(
              SearchRoute.name,
              path: 'search',
              parent: NavigationRoute.name,
            ),
            _i11.RouteConfig(
              NotificationsRoute.name,
              path: 'notifications',
              parent: NavigationRoute.name,
            ),
            _i11.RouteConfig(
              ProfileRoute.name,
              path: 'profile',
              parent: NavigationRoute.name,
            ),
          ],
        ),
        _i11.RouteConfig(
          PosterRoute.name,
          path: 'poster',
        ),
        _i11.RouteConfig(
          CollectionRoute.name,
          path: 'collection',
        ),
        _i11.RouteConfig(
          ProfileRoute.name,
          path: 'profile',
        ),
      ];
}

/// generated route for
/// [_i1.AuthPage]
class AuthRoute extends _i11.PageRouteInfo<AuthRouteArgs> {
  AuthRoute({_i12.Key? key})
      : super(
          AuthRoute.name,
          path: 'auth',
          args: AuthRouteArgs(key: key),
        );

  static const String name = 'AuthRoute';
}

class AuthRouteArgs {
  const AuthRouteArgs({this.key});

  final _i12.Key? key;

  @override
  String toString() {
    return 'AuthRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i2.SignUpPage]
class SignUpRoute extends _i11.PageRouteInfo<void> {
  const SignUpRoute()
      : super(
          SignUpRoute.name,
          path: 'sign_up',
        );

  static const String name = 'SignUpRoute';
}

/// generated route for
/// [_i3.LoginPage]
class LoginRoute extends _i11.PageRouteInfo<void> {
  const LoginRoute()
      : super(
          LoginRoute.name,
          path: 'login',
        );

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i4.NavigationPage]
class NavigationRoute extends _i11.PageRouteInfo<void> {
  const NavigationRoute({List<_i11.PageRouteInfo>? children})
      : super(
          NavigationRoute.name,
          path: 'navigation',
          initialChildren: children,
        );

  static const String name = 'NavigationRoute';
}

/// generated route for
/// [_i5.PosterPage]
class PosterRoute extends _i11.PageRouteInfo<PosterRouteArgs> {
  PosterRoute({
    _i12.Key? key,
    required _i13.PostMovieModel post,
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

  final _i12.Key? key;

  final _i13.PostMovieModel post;

  @override
  String toString() {
    return 'PosterRouteArgs{key: $key, post: $post}';
  }
}

/// generated route for
/// [_i6.CollectionPage]
class CollectionRoute extends _i11.PageRouteInfo<CollectionRouteArgs> {
  CollectionRoute({
    _i12.Key? key,
    required _i14.MultiplePostModel post,
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

  final _i12.Key? key;

  final _i14.MultiplePostModel post;

  @override
  String toString() {
    return 'CollectionRouteArgs{key: $key, post: $post}';
  }
}

/// generated route for
/// [_i7.ProfilePage]
class ProfileRoute extends _i11.PageRouteInfo<ProfileRouteArgs> {
  ProfileRoute({
    _i12.Key? key,
    _i15.UserDetailsModel? user,
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

  final _i12.Key? key;

  final _i15.UserDetailsModel? user;

  @override
  String toString() {
    return 'ProfileRouteArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [_i8.HomePage]
class HomeRoute extends _i11.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: 'home',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i9.SearchPage]
class SearchRoute extends _i11.PageRouteInfo<SearchRouteArgs> {
  SearchRoute({_i12.Key? key})
      : super(
          SearchRoute.name,
          path: 'search',
          args: SearchRouteArgs(key: key),
        );

  static const String name = 'SearchRoute';
}

class SearchRouteArgs {
  const SearchRouteArgs({this.key});

  final _i12.Key? key;

  @override
  String toString() {
    return 'SearchRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i10.NotificationsPage]
class NotificationsRoute extends _i11.PageRouteInfo<void> {
  const NotificationsRoute()
      : super(
          NotificationsRoute.name,
          path: 'notifications',
        );

  static const String name = 'NotificationsRoute';
}
