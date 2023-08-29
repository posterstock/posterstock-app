// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i18;
import 'package:flutter/cupertino.dart' as _i20;
import 'package:flutter/material.dart' as _i19;
import 'package:poster_stock/features/auth/view/pages/auth_page.dart' as _i1;
import 'package:poster_stock/features/auth/view/pages/login_page.dart' as _i9;
import 'package:poster_stock/features/auth/view/pages/sign_up_page.dart'
    as _i16;
import 'package:poster_stock/features/bookmarks/view/pages/bookmarks_page.dart'
    as _i2;
import 'package:poster_stock/features/edit_profile/view/pages/edit_profile_page.dart'
    as _i6;
import 'package:poster_stock/features/home/view/pages/home_page.dart' as _i7;
import 'package:poster_stock/features/list/view/list_page.dart' as _i8;
import 'package:poster_stock/features/navigation_page/view/navigation_page.dart'
    as _i10;
import 'package:poster_stock/features/notifications/view/pages/notifications_page.dart'
    as _i11;
import 'package:poster_stock/features/poster/view/pages/poster_page/poster_page.dart'
    as _i12;
import 'package:poster_stock/features/profile/view/pages/profile_page.dart'
    as _i13;
import 'package:poster_stock/features/search/view/pages/search_page.dart'
    as _i14;
import 'package:poster_stock/features/settings/view/screens/change_email_%20code_screen.dart'
    as _i3;
import 'package:poster_stock/features/settings/view/screens/change_email_screen.dart'
    as _i4;
import 'package:poster_stock/features/settings/view/screens/choose_language_page.dart'
    as _i5;
import 'package:poster_stock/features/settings/view/screens/settings_page.dart'
    as _i15;
import 'package:poster_stock/features/users_list/view/users_list_page.dart'
    as _i17;

abstract class $AppRouter extends _i18.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i18.PageFactory> pagesMap = {
    AuthRoute.name: (routeData) {
      final args =
          routeData.argsAs<AuthRouteArgs>(orElse: () => const AuthRouteArgs());
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.AuthPage(key: args.key),
      );
    },
    BookmarksRoute.name: (routeData) {
      final args = routeData.argsAs<BookmarksRouteArgs>(
          orElse: () => const BookmarksRouteArgs());
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.BookmarksPage(
          key: args.key,
          startIndex: args.startIndex,
        ),
      );
    },
    ChangeEmailCodeRoute.name: (routeData) {
      final args = routeData.argsAs<ChangeEmailCodeRouteArgs>(
          orElse: () => const ChangeEmailCodeRouteArgs());
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.ChangeEmailCodePage(key: args.key),
      );
    },
    ChangeEmailRoute.name: (routeData) {
      final args = routeData.argsAs<ChangeEmailRouteArgs>(
          orElse: () => const ChangeEmailRouteArgs());
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.ChangeEmailPage(key: args.key),
      );
    },
    ChooseLanguageRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.ChooseLanguagePage(),
      );
    },
    EditProfileRoute.name: (routeData) {
      final args = routeData.argsAs<EditProfileRouteArgs>(
          orElse: () => const EditProfileRouteArgs());
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i6.EditProfilePage(key: args.key),
      );
    },
    HomeRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.HomePage(),
      );
    },
    ListRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ListRouteArgs>(
          orElse: () => ListRouteArgs(id: pathParams.getInt('id')));
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i8.ListPage(
          id: args.id,
          key: args.key,
        ),
      );
    },
    LoginRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.LoginPage(),
      );
    },
    NavigationRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.NavigationPage(),
      );
    },
    NotificationsRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.NotificationsPage(),
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
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i12.PosterPage(
          postId: args.postId,
          username: args.username,
          key: args.key,
          likes: args.likes,
          liked: args.liked,
          comments: args.comments,
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
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i13.ProfilePage(
          username: args.username,
          key: args.key,
        ),
      );
    },
    SearchRoute.name: (routeData) {
      final args = routeData.argsAs<SearchRouteArgs>(
          orElse: () => const SearchRouteArgs());
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i14.SearchPage(key: args.key),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i15.SettingsPage(),
      );
    },
    SignUpRoute.name: (routeData) {
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i16.SignUpPage(),
      );
    },
    UsersListRoute.name: (routeData) {
      final args = routeData.argsAs<UsersListRouteArgs>();
      return _i18.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i17.UsersListPage(
          key: args.key,
          following: args.following,
          id: args.id,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.AuthPage]
class AuthRoute extends _i18.PageRouteInfo<AuthRouteArgs> {
  AuthRoute({
    _i19.Key? key,
    List<_i18.PageRouteInfo>? children,
  }) : super(
          AuthRoute.name,
          args: AuthRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'AuthRoute';

  static const _i18.PageInfo<AuthRouteArgs> page =
      _i18.PageInfo<AuthRouteArgs>(name);
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
/// [_i2.BookmarksPage]
class BookmarksRoute extends _i18.PageRouteInfo<BookmarksRouteArgs> {
  BookmarksRoute({
    _i19.Key? key,
    int startIndex = 0,
    List<_i18.PageRouteInfo>? children,
  }) : super(
          BookmarksRoute.name,
          args: BookmarksRouteArgs(
            key: key,
            startIndex: startIndex,
          ),
          initialChildren: children,
        );

  static const String name = 'BookmarksRoute';

  static const _i18.PageInfo<BookmarksRouteArgs> page =
      _i18.PageInfo<BookmarksRouteArgs>(name);
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
/// [_i3.ChangeEmailCodePage]
class ChangeEmailCodeRoute
    extends _i18.PageRouteInfo<ChangeEmailCodeRouteArgs> {
  ChangeEmailCodeRoute({
    _i20.Key? key,
    List<_i18.PageRouteInfo>? children,
  }) : super(
          ChangeEmailCodeRoute.name,
          args: ChangeEmailCodeRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ChangeEmailCodeRoute';

  static const _i18.PageInfo<ChangeEmailCodeRouteArgs> page =
      _i18.PageInfo<ChangeEmailCodeRouteArgs>(name);
}

class ChangeEmailCodeRouteArgs {
  const ChangeEmailCodeRouteArgs({this.key});

  final _i20.Key? key;

  @override
  String toString() {
    return 'ChangeEmailCodeRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i4.ChangeEmailPage]
class ChangeEmailRoute extends _i18.PageRouteInfo<ChangeEmailRouteArgs> {
  ChangeEmailRoute({
    _i20.Key? key,
    List<_i18.PageRouteInfo>? children,
  }) : super(
          ChangeEmailRoute.name,
          args: ChangeEmailRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ChangeEmailRoute';

  static const _i18.PageInfo<ChangeEmailRouteArgs> page =
      _i18.PageInfo<ChangeEmailRouteArgs>(name);
}

class ChangeEmailRouteArgs {
  const ChangeEmailRouteArgs({this.key});

  final _i20.Key? key;

  @override
  String toString() {
    return 'ChangeEmailRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i5.ChooseLanguagePage]
class ChooseLanguageRoute extends _i18.PageRouteInfo<void> {
  const ChooseLanguageRoute({List<_i18.PageRouteInfo>? children})
      : super(
          ChooseLanguageRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChooseLanguageRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i6.EditProfilePage]
class EditProfileRoute extends _i18.PageRouteInfo<EditProfileRouteArgs> {
  EditProfileRoute({
    _i20.Key? key,
    List<_i18.PageRouteInfo>? children,
  }) : super(
          EditProfileRoute.name,
          args: EditProfileRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'EditProfileRoute';

  static const _i18.PageInfo<EditProfileRouteArgs> page =
      _i18.PageInfo<EditProfileRouteArgs>(name);
}

class EditProfileRouteArgs {
  const EditProfileRouteArgs({this.key});

  final _i20.Key? key;

  @override
  String toString() {
    return 'EditProfileRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i7.HomePage]
class HomeRoute extends _i18.PageRouteInfo<void> {
  const HomeRoute({List<_i18.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i8.ListPage]
class ListRoute extends _i18.PageRouteInfo<ListRouteArgs> {
  ListRoute({
    required int id,
    _i19.Key? key,
    List<_i18.PageRouteInfo>? children,
  }) : super(
          ListRoute.name,
          args: ListRouteArgs(
            id: id,
            key: key,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'ListRoute';

  static const _i18.PageInfo<ListRouteArgs> page =
      _i18.PageInfo<ListRouteArgs>(name);
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
/// [_i9.LoginPage]
class LoginRoute extends _i18.PageRouteInfo<void> {
  const LoginRoute({List<_i18.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i10.NavigationPage]
class NavigationRoute extends _i18.PageRouteInfo<void> {
  const NavigationRoute({List<_i18.PageRouteInfo>? children})
      : super(
          NavigationRoute.name,
          initialChildren: children,
        );

  static const String name = 'NavigationRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i11.NotificationsPage]
class NotificationsRoute extends _i18.PageRouteInfo<void> {
  const NotificationsRoute({List<_i18.PageRouteInfo>? children})
      : super(
          NotificationsRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationsRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i12.PosterPage]
class PosterRoute extends _i18.PageRouteInfo<PosterRouteArgs> {
  PosterRoute({
    int postId = 0,
    String username = 'profile',
    _i19.Key? key,
    int likes = 0,
    bool liked = false,
    int comments = 0,
    List<_i18.PageRouteInfo>? children,
  }) : super(
          PosterRoute.name,
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
          initialChildren: children,
        );

  static const String name = 'PosterRoute';

  static const _i18.PageInfo<PosterRouteArgs> page =
      _i18.PageInfo<PosterRouteArgs>(name);
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
/// [_i13.ProfilePage]
class ProfileRoute extends _i18.PageRouteInfo<ProfileRouteArgs> {
  ProfileRoute({
    String username = 'profile',
    _i20.Key? key,
    List<_i18.PageRouteInfo>? children,
  }) : super(
          ProfileRoute.name,
          args: ProfileRouteArgs(
            username: username,
            key: key,
          ),
          rawPathParams: {'username': username},
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const _i18.PageInfo<ProfileRouteArgs> page =
      _i18.PageInfo<ProfileRouteArgs>(name);
}

class ProfileRouteArgs {
  const ProfileRouteArgs({
    this.username = 'profile',
    this.key,
  });

  final String username;

  final _i20.Key? key;

  @override
  String toString() {
    return 'ProfileRouteArgs{username: $username, key: $key}';
  }
}

/// generated route for
/// [_i14.SearchPage]
class SearchRoute extends _i18.PageRouteInfo<SearchRouteArgs> {
  SearchRoute({
    _i20.Key? key,
    List<_i18.PageRouteInfo>? children,
  }) : super(
          SearchRoute.name,
          args: SearchRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static const _i18.PageInfo<SearchRouteArgs> page =
      _i18.PageInfo<SearchRouteArgs>(name);
}

class SearchRouteArgs {
  const SearchRouteArgs({this.key});

  final _i20.Key? key;

  @override
  String toString() {
    return 'SearchRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i15.SettingsPage]
class SettingsRoute extends _i18.PageRouteInfo<void> {
  const SettingsRoute({List<_i18.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i16.SignUpPage]
class SignUpRoute extends _i18.PageRouteInfo<void> {
  const SignUpRoute({List<_i18.PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static const _i18.PageInfo<void> page = _i18.PageInfo<void>(name);
}

/// generated route for
/// [_i17.UsersListPage]
class UsersListRoute extends _i18.PageRouteInfo<UsersListRouteArgs> {
  UsersListRoute({
    _i20.Key? key,
    bool following = false,
    required int id,
    List<_i18.PageRouteInfo>? children,
  }) : super(
          UsersListRoute.name,
          args: UsersListRouteArgs(
            key: key,
            following: following,
            id: id,
          ),
          initialChildren: children,
        );

  static const String name = 'UsersListRoute';

  static const _i18.PageInfo<UsersListRouteArgs> page =
      _i18.PageInfo<UsersListRouteArgs>(name);
}

class UsersListRouteArgs {
  const UsersListRouteArgs({
    this.key,
    this.following = false,
    required this.id,
  });

  final _i20.Key? key;

  final bool following;

  final int id;

  @override
  String toString() {
    return 'UsersListRouteArgs{key: $key, following: $following, id: $id}';
  }
}
