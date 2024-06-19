// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i19;
import 'package:flutter/cupertino.dart' as _i21;
import 'package:flutter/foundation.dart' as _i20;
import 'package:flutter/material.dart' as _i22;
import 'package:poster_stock/features/account/account_page.dart' as _i1;
import 'package:poster_stock/features/auth/view/pages/auth_page.dart' as _i2;
import 'package:poster_stock/features/auth/view/pages/login_page.dart' as _i10;
import 'package:poster_stock/features/auth/view/pages/sign_up_page.dart'
    as _i16;
import 'package:poster_stock/features/bookmarks/view/pages/bookmarks_page.dart'
    as _i3;
import 'package:poster_stock/features/edit_profile/view/pages/edit_profile_page.dart'
    as _i7;
import 'package:poster_stock/features/home/view/pages/home_page.dart' as _i8;
import 'package:poster_stock/features/list/view/list_page.dart' as _i9;
import 'package:poster_stock/features/navigation_page/view/navigation_page.dart'
    as _i11;
import 'package:poster_stock/features/notifications/view/pages/notifications_page.dart'
    as _i12;
import 'package:poster_stock/features/poster/view/pages/poster_page/poster_page.dart'
    as _i13;
import 'package:poster_stock/features/search/view/pages/search_page.dart'
    as _i14;
import 'package:poster_stock/features/settings/view/screens/change_email_code_screen.dart'
    as _i4;
import 'package:poster_stock/features/settings/view/screens/change_email_screen.dart'
    as _i5;
import 'package:poster_stock/features/settings/view/screens/choose_language_page.dart'
    as _i6;
import 'package:poster_stock/features/settings/view/screens/settings_page.dart'
    as _i15;
import 'package:poster_stock/features/user/user_page.dart' as _i17;
import 'package:poster_stock/features/users_list/view/users_list_page.dart'
    as _i18;

abstract class $AppRouter extends _i19.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i19.PageFactory> pagesMap = {
    AccountRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.AccountPage(),
      );
    },
    AuthRoute.name: (routeData) {
      final args =
          routeData.argsAs<AuthRouteArgs>(orElse: () => const AuthRouteArgs());
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.AuthPage(key: args.key),
      );
    },
    BookmarksRoute.name: (routeData) {
      final args = routeData.argsAs<BookmarksRouteArgs>();
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.BookmarksPage(
          key: args.key,
          id: args.id,
          mediaId: args.mediaId,
          tmdbLink: args.tmdbLink,
        ),
      );
    },
    ChangeEmailCodeRoute.name: (routeData) {
      final args = routeData.argsAs<ChangeEmailCodeRouteArgs>(
          orElse: () => const ChangeEmailCodeRouteArgs());
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.ChangeEmailCodePage(key: args.key),
      );
    },
    ChangeEmailRoute.name: (routeData) {
      final args = routeData.argsAs<ChangeEmailRouteArgs>(
          orElse: () => const ChangeEmailRouteArgs());
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.ChangeEmailPage(key: args.key),
      );
    },
    ChooseLanguageRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.ChooseLanguagePage(),
      );
    },
    EditProfileRoute.name: (routeData) {
      final args = routeData.argsAs<EditProfileRouteArgs>(
          orElse: () => const EditProfileRouteArgs());
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i7.EditProfilePage(key: args.key),
      );
    },
    HomeRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.HomePage(),
      );
    },
    ListRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ListRouteArgs>(
          orElse: () => ListRouteArgs(
                id: pathParams.getInt('id'),
                type: pathParams.getInt(
                  'type',
                  -1,
                ),
              ));
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i9.ListPage(
          id: args.id,
          type: args.type,
          key: args.key,
        ),
      );
    },
    LoginRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.LoginPage(),
      );
    },
    NavigationRoute.name: (routeData) {
      final args = routeData.argsAs<NavigationRouteArgs>(
          orElse: () => const NavigationRouteArgs());
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i11.NavigationPage(key: args.key),
      );
    },
    NotificationsRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.NotificationsPage(),
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
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i13.PosterPage(
          postId: args.postId,
          username: args.username,
          key: args.key,
          likes: args.likes,
          liked: args.liked,
          comments: args.comments,
        ),
      );
    },
    SearchRoute.name: (routeData) {
      final args = routeData.argsAs<SearchRouteArgs>(
          orElse: () => const SearchRouteArgs());
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i14.SearchPage(key: args.key),
      );
    },
    SettingsRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i15.SettingsPage(),
      );
    },
    SignUpRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i16.SignUpPage(),
      );
    },
    UserRoute.name: (routeData) {
      final args = routeData.argsAs<UserRouteArgs>();
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i17.UserPage(
          args: args.args,
          key: args.key,
        ),
      );
    },
    UserRouteId.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<UserRouteIdArgs>(
          orElse: () => UserRouteIdArgs(id: pathParams.getInt('id')));
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i17.UserPageId(
          id: args.id,
          key: args.key,
        ),
      );
    },
    UserRouteNamed.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<UserRouteNamedArgs>(
          orElse: () =>
              UserRouteNamedArgs(username: pathParams.getString('username')));
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i17.UserPageNamed(
          username: args.username,
          key: args.key,
        ),
      );
    },
    UsersListRoute.name: (routeData) {
      final args = routeData.argsAs<UsersListRouteArgs>();
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i18.UsersListPage(
          key: args.key,
          following: args.following,
          id: args.id,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.AccountPage]
class AccountRoute extends _i19.PageRouteInfo<void> {
  const AccountRoute({List<_i19.PageRouteInfo>? children})
      : super(
          AccountRoute.name,
          initialChildren: children,
        );

  static const String name = 'AccountRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i2.AuthPage]
class AuthRoute extends _i19.PageRouteInfo<AuthRouteArgs> {
  AuthRoute({
    _i20.Key? key,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          AuthRoute.name,
          args: AuthRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'AuthRoute';

  static const _i19.PageInfo<AuthRouteArgs> page =
      _i19.PageInfo<AuthRouteArgs>(name);
}

class AuthRouteArgs {
  const AuthRouteArgs({this.key});

  final _i20.Key? key;

  @override
  String toString() {
    return 'AuthRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i3.BookmarksPage]
class BookmarksRoute extends _i19.PageRouteInfo<BookmarksRouteArgs> {
  BookmarksRoute({
    _i21.Key? key,
    required int id,
    required int mediaId,
    required String tmdbLink,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          BookmarksRoute.name,
          args: BookmarksRouteArgs(
            key: key,
            id: id,
            mediaId: mediaId,
            tmdbLink: tmdbLink,
          ),
          initialChildren: children,
        );

  static const String name = 'BookmarksRoute';

  static const _i19.PageInfo<BookmarksRouteArgs> page =
      _i19.PageInfo<BookmarksRouteArgs>(name);
}

class BookmarksRouteArgs {
  const BookmarksRouteArgs({
    this.key,
    required this.id,
    required this.mediaId,
    required this.tmdbLink,
  });

  final _i21.Key? key;

  final int id;

  final int mediaId;

  final String tmdbLink;

  @override
  String toString() {
    return 'BookmarksRouteArgs{key: $key, id: $id, mediaId: $mediaId, tmdbLink: $tmdbLink}';
  }
}

/// generated route for
/// [_i4.ChangeEmailCodePage]
class ChangeEmailCodeRoute
    extends _i19.PageRouteInfo<ChangeEmailCodeRouteArgs> {
  ChangeEmailCodeRoute({
    _i21.Key? key,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          ChangeEmailCodeRoute.name,
          args: ChangeEmailCodeRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ChangeEmailCodeRoute';

  static const _i19.PageInfo<ChangeEmailCodeRouteArgs> page =
      _i19.PageInfo<ChangeEmailCodeRouteArgs>(name);
}

class ChangeEmailCodeRouteArgs {
  const ChangeEmailCodeRouteArgs({this.key});

  final _i21.Key? key;

  @override
  String toString() {
    return 'ChangeEmailCodeRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i5.ChangeEmailPage]
class ChangeEmailRoute extends _i19.PageRouteInfo<ChangeEmailRouteArgs> {
  ChangeEmailRoute({
    _i21.Key? key,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          ChangeEmailRoute.name,
          args: ChangeEmailRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'ChangeEmailRoute';

  static const _i19.PageInfo<ChangeEmailRouteArgs> page =
      _i19.PageInfo<ChangeEmailRouteArgs>(name);
}

class ChangeEmailRouteArgs {
  const ChangeEmailRouteArgs({this.key});

  final _i21.Key? key;

  @override
  String toString() {
    return 'ChangeEmailRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i6.ChooseLanguagePage]
class ChooseLanguageRoute extends _i19.PageRouteInfo<void> {
  const ChooseLanguageRoute({List<_i19.PageRouteInfo>? children})
      : super(
          ChooseLanguageRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChooseLanguageRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i7.EditProfilePage]
class EditProfileRoute extends _i19.PageRouteInfo<EditProfileRouteArgs> {
  EditProfileRoute({
    _i21.Key? key,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          EditProfileRoute.name,
          args: EditProfileRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'EditProfileRoute';

  static const _i19.PageInfo<EditProfileRouteArgs> page =
      _i19.PageInfo<EditProfileRouteArgs>(name);
}

class EditProfileRouteArgs {
  const EditProfileRouteArgs({this.key});

  final _i21.Key? key;

  @override
  String toString() {
    return 'EditProfileRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i8.HomePage]
class HomeRoute extends _i19.PageRouteInfo<void> {
  const HomeRoute({List<_i19.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i9.ListPage]
class ListRoute extends _i19.PageRouteInfo<ListRouteArgs> {
  ListRoute({
    required int id,
    int type = -1,
    _i22.Key? key,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          ListRoute.name,
          args: ListRouteArgs(
            id: id,
            type: type,
            key: key,
          ),
          rawPathParams: {
            'id': id,
            'type': type,
          },
          initialChildren: children,
        );

  static const String name = 'ListRoute';

  static const _i19.PageInfo<ListRouteArgs> page =
      _i19.PageInfo<ListRouteArgs>(name);
}

class ListRouteArgs {
  const ListRouteArgs({
    required this.id,
    this.type = -1,
    this.key,
  });

  final int id;

  final int type;

  final _i22.Key? key;

  @override
  String toString() {
    return 'ListRouteArgs{id: $id, type: $type, key: $key}';
  }
}

/// generated route for
/// [_i10.LoginPage]
class LoginRoute extends _i19.PageRouteInfo<void> {
  const LoginRoute({List<_i19.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i11.NavigationPage]
class NavigationRoute extends _i19.PageRouteInfo<NavigationRouteArgs> {
  NavigationRoute({
    _i22.Key? key,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          NavigationRoute.name,
          args: NavigationRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'NavigationRoute';

  static const _i19.PageInfo<NavigationRouteArgs> page =
      _i19.PageInfo<NavigationRouteArgs>(name);
}

class NavigationRouteArgs {
  const NavigationRouteArgs({this.key});

  final _i22.Key? key;

  @override
  String toString() {
    return 'NavigationRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i12.NotificationsPage]
class NotificationsRoute extends _i19.PageRouteInfo<void> {
  const NotificationsRoute({List<_i19.PageRouteInfo>? children})
      : super(
          NotificationsRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationsRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i13.PosterPage]
class PosterRoute extends _i19.PageRouteInfo<PosterRouteArgs> {
  PosterRoute({
    int postId = 0,
    String username = 'profile',
    _i21.Key? key,
    int likes = 0,
    bool liked = false,
    int comments = 0,
    List<_i19.PageRouteInfo>? children,
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

  static const _i19.PageInfo<PosterRouteArgs> page =
      _i19.PageInfo<PosterRouteArgs>(name);
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

  final _i21.Key? key;

  final int likes;

  final bool liked;

  final int comments;

  @override
  String toString() {
    return 'PosterRouteArgs{postId: $postId, username: $username, key: $key, likes: $likes, liked: $liked, comments: $comments}';
  }
}

/// generated route for
/// [_i14.SearchPage]
class SearchRoute extends _i19.PageRouteInfo<SearchRouteArgs> {
  SearchRoute({
    _i21.Key? key,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          SearchRoute.name,
          args: SearchRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static const _i19.PageInfo<SearchRouteArgs> page =
      _i19.PageInfo<SearchRouteArgs>(name);
}

class SearchRouteArgs {
  const SearchRouteArgs({this.key});

  final _i21.Key? key;

  @override
  String toString() {
    return 'SearchRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i15.SettingsPage]
class SettingsRoute extends _i19.PageRouteInfo<void> {
  const SettingsRoute({List<_i19.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i16.SignUpPage]
class SignUpRoute extends _i19.PageRouteInfo<void> {
  const SignUpRoute({List<_i19.PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i17.UserPage]
class UserRoute extends _i19.PageRouteInfo<UserRouteArgs> {
  UserRoute({
    required _i17.UserArgs args,
    _i21.Key? key,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          UserRoute.name,
          args: UserRouteArgs(
            args: args,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'UserRoute';

  static const _i19.PageInfo<UserRouteArgs> page =
      _i19.PageInfo<UserRouteArgs>(name);
}

class UserRouteArgs {
  const UserRouteArgs({
    required this.args,
    this.key,
  });

  final _i17.UserArgs args;

  final _i21.Key? key;

  @override
  String toString() {
    return 'UserRouteArgs{args: $args, key: $key}';
  }
}

/// generated route for
/// [_i17.UserPageId]
class UserRouteId extends _i19.PageRouteInfo<UserRouteIdArgs> {
  UserRouteId({
    required int id,
    _i21.Key? key,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          UserRouteId.name,
          args: UserRouteIdArgs(
            id: id,
            key: key,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'UserRouteId';

  static const _i19.PageInfo<UserRouteIdArgs> page =
      _i19.PageInfo<UserRouteIdArgs>(name);
}

class UserRouteIdArgs {
  const UserRouteIdArgs({
    required this.id,
    this.key,
  });

  final int id;

  final _i21.Key? key;

  @override
  String toString() {
    return 'UserRouteIdArgs{id: $id, key: $key}';
  }
}

/// generated route for
/// [_i17.UserPageNamed]
class UserRouteNamed extends _i19.PageRouteInfo<UserRouteNamedArgs> {
  UserRouteNamed({
    required String username,
    _i21.Key? key,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          UserRouteNamed.name,
          args: UserRouteNamedArgs(
            username: username,
            key: key,
          ),
          rawPathParams: {'username': username},
          initialChildren: children,
        );

  static const String name = 'UserRouteNamed';

  static const _i19.PageInfo<UserRouteNamedArgs> page =
      _i19.PageInfo<UserRouteNamedArgs>(name);
}

class UserRouteNamedArgs {
  const UserRouteNamedArgs({
    required this.username,
    this.key,
  });

  final String username;

  final _i21.Key? key;

  @override
  String toString() {
    return 'UserRouteNamedArgs{username: $username, key: $key}';
  }
}

/// generated route for
/// [_i18.UsersListPage]
class UsersListRoute extends _i19.PageRouteInfo<UsersListRouteArgs> {
  UsersListRoute({
    _i21.Key? key,
    bool following = false,
    required int id,
    List<_i19.PageRouteInfo>? children,
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

  static const _i19.PageInfo<UsersListRouteArgs> page =
      _i19.PageInfo<UsersListRouteArgs>(name);
}

class UsersListRouteArgs {
  const UsersListRouteArgs({
    this.key,
    this.following = false,
    required this.id,
  });

  final _i21.Key? key;

  final bool following;

  final int id;

  @override
  String toString() {
    return 'UsersListRouteArgs{key: $key, following: $following, id: $id}';
  }
}
