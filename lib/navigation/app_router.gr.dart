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
import 'package:auto_route/auto_route.dart' as _i18;
import 'package:flutter/material.dart' as _i19;

import '../features/auth/view/pages/auth_page.dart' as _i1;
import '../features/auth/view/pages/login_page.dart' as _i3;
import '../features/auth/view/pages/sign_up_page.dart' as _i2;
import '../features/bookmarks/view/pages/bookmarks_page.dart' as _i13;
import '../features/edit_profile/view/view/pages/edit_profile_page.dart'
    as _i12;
import '../features/home/view/pages/home_page.dart' as _i15;
import '../features/list/view/list_page.dart' as _i6;
import '../features/navigation_page/view/navigation_page.dart' as _i4;
import '../features/notifications/view/pages/notifications_page.dart' as _i17;
import '../features/poster/view/pages/poster_page/poster_page.dart' as _i5;
import '../features/profile/view/pages/profile_page.dart' as _i7;
import '../features/search/view/pages/search_page.dart' as _i16;
import '../features/settings/view/screens/change_email_%20code_screen.dart'
    as _i11;
import '../features/settings/view/screens/change_email_screen.dart' as _i10;
import '../features/settings/view/screens/choose_language_page.dart' as _i9;
import '../features/settings/view/screens/settings_page.dart' as _i8;
import '../features/users_list/view/users_list_page.dart' as _i14;

class AppRouter extends _i18.RootStackRouter {
  AppRouter([_i19.GlobalKey<_i19.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i18.PageFactory> pagesMap = {
    AuthRoute.name: (routeData) {
      final args =
          routeData.argsAs<AuthRouteArgs>(orElse: () => const AuthRouteArgs());
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i1.AuthPage(key: args.key),
      );
    },
    SignUpRoute.name: (routeData) {
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.SignUpPage(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i3.LoginPage(),
      );
    },
    NavigationRoute.name: (routeData) {
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i4.NavigationPage(),
      );
    },
    PosterRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<PosterRouteArgs>(
          orElse: () => PosterRouteArgs(
                postId: pathParams.getInt(
                  'id',
                  0,
                ),
                username: pathParams.getString(
                  'username',
                  'profile',
                ),
              ));
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i5.PosterPage(
          postId: args.postId,
          username: args.username,
          key: args.key,
          likes: args.likes,
          liked: args.liked,
          comments: args.comments,
        ),
      );
    },
    ListRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ListRouteArgs>(
          orElse: () => ListRouteArgs(id: pathParams.getInt('id')));
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i6.ListPage(
          id: args.id,
          key: args.key,
        ),
      );
    },
    ProfileRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ProfileRouteArgs>(
          orElse: () => ProfileRouteArgs(
                  username: pathParams.getString(
                'username',
                'profile',
              )));
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i7.ProfilePage(
          username: args.username,
          key: args.key,
        ),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i8.SettingsPage(),
      );
    },
    ChooseLanguageRoute.name: (routeData) {
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i9.ChooseLanguagePage(),
      );
    },
    ChangeEmailScreen.name: (routeData) {
      final args = routeData.argsAs<ChangeEmailScreenArgs>(
          orElse: () => const ChangeEmailScreenArgs());
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i10.ChangeEmailScreen(key: args.key),
      );
    },
    ChangeEmailCodeScreen.name: (routeData) {
      final args = routeData.argsAs<ChangeEmailCodeScreenArgs>(
          orElse: () => const ChangeEmailCodeScreenArgs());
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i11.ChangeEmailCodeScreen(key: args.key),
      );
    },
    EditProfileRoute.name: (routeData) {
      final args = routeData.argsAs<EditProfileRouteArgs>(
          orElse: () => const EditProfileRouteArgs());
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i12.EditProfilePage(key: args.key),
      );
    },
    BookmarksRoute.name: (routeData) {
      final args = routeData.argsAs<BookmarksRouteArgs>(
          orElse: () => const BookmarksRouteArgs());
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i13.BookmarksPage(
          key: args.key,
          startIndex: args.startIndex,
        ),
      );
    },
    UsersListRoute.name: (routeData) {
      final args = routeData.argsAs<UsersListRouteArgs>(
          orElse: () => const UsersListRouteArgs());
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i14.UsersListPage(
          key: args.key,
          following: args.following,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i15.HomePage(),
      );
    },
    SearchRoute.name: (routeData) {
      final args = routeData.argsAs<SearchRouteArgs>(
          orElse: () => const SearchRouteArgs());
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i16.SearchPage(key: args.key),
      );
    },
    NotificationsRoute.name: (routeData) {
      return _i18.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i17.NotificationsPage(),
      );
    },
  };

  @override
  List<_i18.RouteConfig> get routes => [
        _i18.RouteConfig(
          '/#redirect',
          path: '/',
          redirectTo: 'auth',
          fullMatch: true,
        ),
        _i18.RouteConfig(
          AuthRoute.name,
          path: 'auth',
        ),
        _i18.RouteConfig(
          SignUpRoute.name,
          path: 'sign_up',
        ),
        _i18.RouteConfig(
          LoginRoute.name,
          path: 'login',
        ),
        _i18.RouteConfig(
          NavigationRoute.name,
          path: 'navigation',
          children: [
            _i18.RouteConfig(
              HomeRoute.name,
              path: 'home',
              parent: NavigationRoute.name,
            ),
            _i18.RouteConfig(
              SearchRoute.name,
              path: 'search',
              parent: NavigationRoute.name,
            ),
            _i18.RouteConfig(
              NotificationsRoute.name,
              path: 'notifications',
              parent: NavigationRoute.name,
            ),
            _i18.RouteConfig(
              ProfileRoute.name,
              path: ':username',
              parent: NavigationRoute.name,
            ),
          ],
        ),
        _i18.RouteConfig(
          PosterRoute.name,
          path: ':username/:id',
        ),
        _i18.RouteConfig(
          ListRoute.name,
          path: 'list/:id',
        ),
        _i18.RouteConfig(
          ProfileRoute.name,
          path: ':username',
        ),
        _i18.RouteConfig(
          SettingsRoute.name,
          path: 'settings',
        ),
        _i18.RouteConfig(
          ChooseLanguageRoute.name,
          path: 'language',
        ),
        _i18.RouteConfig(
          ChangeEmailScreen.name,
          path: 'change_email',
        ),
        _i18.RouteConfig(
          ChangeEmailCodeScreen.name,
          path: 'change_email_code',
        ),
        _i18.RouteConfig(
          EditProfileRoute.name,
          path: 'edit_profile',
        ),
        _i18.RouteConfig(
          BookmarksRoute.name,
          path: 'bookmarks',
        ),
        _i18.RouteConfig(
          UsersListRoute.name,
          path: 'users_list',
        ),
      ];
}

/// generated route for
/// [_i1.AuthPage]
class AuthRoute extends _i18.PageRouteInfo<AuthRouteArgs> {
  AuthRoute({_i19.Key? key})
      : super(
          AuthRoute.name,
          path: 'auth',
          args: AuthRouteArgs(key: key),
        );

  static const String name = 'AuthRoute';
}

class AuthRouteArgs {
  const AuthRouteArgs({this.key});

  final _i19.Key? key;

  @override
  String toString() {
    return 'AuthRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i2.SignUpPage]
class SignUpRoute extends _i18.PageRouteInfo<void> {
  const SignUpRoute()
      : super(
          SignUpRoute.name,
          path: 'sign_up',
        );

  static const String name = 'SignUpRoute';
}

/// generated route for
/// [_i3.LoginPage]
class LoginRoute extends _i18.PageRouteInfo<void> {
  const LoginRoute()
      : super(
          LoginRoute.name,
          path: 'login',
        );

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i4.NavigationPage]
class NavigationRoute extends _i18.PageRouteInfo<void> {
  const NavigationRoute({List<_i18.PageRouteInfo>? children})
      : super(
          NavigationRoute.name,
          path: 'navigation',
          initialChildren: children,
        );

  static const String name = 'NavigationRoute';
}

/// generated route for
/// [_i5.PosterPage]
class PosterRoute extends _i18.PageRouteInfo<PosterRouteArgs> {
  PosterRoute({
    int postId = 0,
    String username = 'profile',
    _i19.Key? key,
    int likes = 0,
    bool liked = false,
    int comments = 0,
  }) : super(
          PosterRoute.name,
          path: ':username/:id',
          args: PosterRouteArgs(
            postId: postId,
            username: username,
            key: key,
            likes: likes,
            liked: liked,
            comments: comments,
          ),
          rawPathParams: {
            'id': postId,
            'username': username,
          },
        );

  static const String name = 'PosterRoute';
}

class PosterRouteArgs {
  const PosterRouteArgs({
    this.postId = 0,
    this.username = 'profile',
    this.key,
    this.likes = 0,
    this.liked = false,
    this.comments = 0,
  });

  final int postId;

  final String username;

  final _i19.Key? key;

  final int likes;

  final bool liked;

  final int comments;

  @override
  String toString() {
    return 'PosterRouteArgs{postId: $postId, username: $username, key: $key, likes: $likes, liked: $liked, comments: $comments}';
  }
}

/// generated route for
/// [_i6.ListPage]
class ListRoute extends _i18.PageRouteInfo<ListRouteArgs> {
  ListRoute({
    required int id,
    _i19.Key? key,
  }) : super(
          ListRoute.name,
          path: 'list/:id',
          args: ListRouteArgs(
            id: id,
            key: key,
          ),
          rawPathParams: {'id': id},
        );

  static const String name = 'ListRoute';
}

class ListRouteArgs {
  const ListRouteArgs({
    required this.id,
    this.key,
  });

  final int id;

  final _i19.Key? key;

  @override
  String toString() {
    return 'ListRouteArgs{id: $id, key: $key}';
  }
}

/// generated route for
/// [_i7.ProfilePage]
class ProfileRoute extends _i18.PageRouteInfo<ProfileRouteArgs> {
  ProfileRoute({
    String username = 'profile',
    _i19.Key? key,
  }) : super(
          ProfileRoute.name,
          path: ':username',
          args: ProfileRouteArgs(
            username: username,
            key: key,
          ),
          rawPathParams: {'username': username},
        );

  static const String name = 'ProfileRoute';
}

class ProfileRouteArgs {
  const ProfileRouteArgs({
    this.username = 'profile',
    this.key,
  });

  final String username;

  final _i19.Key? key;

  @override
  String toString() {
    return 'ProfileRouteArgs{username: $username, key: $key}';
  }
}

/// generated route for
/// [_i8.SettingsPage]
class SettingsRoute extends _i18.PageRouteInfo<void> {
  const SettingsRoute()
      : super(
          SettingsRoute.name,
          path: 'settings',
        );

  static const String name = 'SettingsRoute';
}

/// generated route for
/// [_i9.ChooseLanguagePage]
class ChooseLanguageRoute extends _i18.PageRouteInfo<void> {
  const ChooseLanguageRoute()
      : super(
          ChooseLanguageRoute.name,
          path: 'language',
        );

  static const String name = 'ChooseLanguageRoute';
}

/// generated route for
/// [_i10.ChangeEmailScreen]
class ChangeEmailScreen extends _i18.PageRouteInfo<ChangeEmailScreenArgs> {
  ChangeEmailScreen({_i19.Key? key})
      : super(
          ChangeEmailScreen.name,
          path: 'change_email',
          args: ChangeEmailScreenArgs(key: key),
        );

  static const String name = 'ChangeEmailScreen';
}

class ChangeEmailScreenArgs {
  const ChangeEmailScreenArgs({this.key});

  final _i19.Key? key;

  @override
  String toString() {
    return 'ChangeEmailScreenArgs{key: $key}';
  }
}

/// generated route for
/// [_i11.ChangeEmailCodeScreen]
class ChangeEmailCodeScreen
    extends _i18.PageRouteInfo<ChangeEmailCodeScreenArgs> {
  ChangeEmailCodeScreen({_i19.Key? key})
      : super(
          ChangeEmailCodeScreen.name,
          path: 'change_email_code',
          args: ChangeEmailCodeScreenArgs(key: key),
        );

  static const String name = 'ChangeEmailCodeScreen';
}

class ChangeEmailCodeScreenArgs {
  const ChangeEmailCodeScreenArgs({this.key});

  final _i19.Key? key;

  @override
  String toString() {
    return 'ChangeEmailCodeScreenArgs{key: $key}';
  }
}

/// generated route for
/// [_i12.EditProfilePage]
class EditProfileRoute extends _i18.PageRouteInfo<EditProfileRouteArgs> {
  EditProfileRoute({_i19.Key? key})
      : super(
          EditProfileRoute.name,
          path: 'edit_profile',
          args: EditProfileRouteArgs(key: key),
        );

  static const String name = 'EditProfileRoute';
}

class EditProfileRouteArgs {
  const EditProfileRouteArgs({this.key});

  final _i19.Key? key;

  @override
  String toString() {
    return 'EditProfileRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i13.BookmarksPage]
class BookmarksRoute extends _i18.PageRouteInfo<BookmarksRouteArgs> {
  BookmarksRoute({
    _i19.Key? key,
    int startIndex = 0,
  }) : super(
          BookmarksRoute.name,
          path: 'bookmarks',
          args: BookmarksRouteArgs(
            key: key,
            startIndex: startIndex,
          ),
        );

  static const String name = 'BookmarksRoute';
}

class BookmarksRouteArgs {
  const BookmarksRouteArgs({
    this.key,
    this.startIndex = 0,
  });

  final _i19.Key? key;

  final int startIndex;

  @override
  String toString() {
    return 'BookmarksRouteArgs{key: $key, startIndex: $startIndex}';
  }
}

/// generated route for
/// [_i14.UsersListPage]
class UsersListRoute extends _i18.PageRouteInfo<UsersListRouteArgs> {
  UsersListRoute({
    _i19.Key? key,
    bool following = false,
  }) : super(
          UsersListRoute.name,
          path: 'users_list',
          args: UsersListRouteArgs(
            key: key,
            following: following,
          ),
        );

  static const String name = 'UsersListRoute';
}

class UsersListRouteArgs {
  const UsersListRouteArgs({
    this.key,
    this.following = false,
  });

  final _i19.Key? key;

  final bool following;

  @override
  String toString() {
    return 'UsersListRouteArgs{key: $key, following: $following}';
  }
}

/// generated route for
/// [_i15.HomePage]
class HomeRoute extends _i18.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: 'home',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i16.SearchPage]
class SearchRoute extends _i18.PageRouteInfo<SearchRouteArgs> {
  SearchRoute({_i19.Key? key})
      : super(
          SearchRoute.name,
          path: 'search',
          args: SearchRouteArgs(key: key),
        );

  static const String name = 'SearchRoute';
}

class SearchRouteArgs {
  const SearchRouteArgs({this.key});

  final _i19.Key? key;

  @override
  String toString() {
    return 'SearchRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i17.NotificationsPage]
class NotificationsRoute extends _i18.PageRouteInfo<void> {
  const NotificationsRoute()
      : super(
          NotificationsRoute.name,
          path: 'notifications',
        );

  static const String name = 'NotificationsRoute';
}
