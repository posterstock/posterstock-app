import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/search/repository/search_repository.dart';
import 'package:poster_stock/features/search/state_holders/search_lists_state_holder.dart';
import 'package:poster_stock/features/search/state_holders/search_posts_state_holder.dart';
import 'package:poster_stock/features/search/state_holders/search_users_state_holder.dart';
import 'package:poster_stock/features/search/state_holders/search_value_state_holder.dart';

final searchControllerProvider = Provider<SearchController>(
  (ref) => SearchController(
    searchValueState: ref.watch(searchValueStateHolderProvider.notifier),
    searchUsersState: ref.watch(searchUsersStateHolderProvider.notifier),
    searchPostsState: ref.watch(searchPostsStateHolderProvider.notifier),
    searchListsState: ref.watch(searchListsStateHolderProvider.notifier),
  ),
);

class SearchController {
  final SearchValueStateHolder searchValueState;
  final SearchUsersStateHolder searchUsersState;
  final SearchPostsStateHolder searchPostsState;
  final SearchListsStateHolder searchListsState;
  final SearchRepository searchRepository = SearchRepository();

  SearchController({
    required this.searchValueState,
    required this.searchUsersState,
    required this.searchPostsState,
    required this.searchListsState,
  });

  String searchValue = '';
  bool gotAllUsers = false;
  bool gotAllPosts = false;
  bool gotAllLists = false;
  bool loadingUpdateUsers = false;
  bool loadingUpdatePosts = false;
  bool loadingUpdateLists = false;

  Future<void> startSearchUsers(String value) async {
    gotAllUsers = false;
    gotAllLists = false;
    gotAllPosts = false;
    searchValue = value;
    bool stop = false;
    await Future.delayed(const Duration(milliseconds: 500), () {
      if (searchValue != value) stop = true;
    });
    if (stop) return;
    print(value);
    searchValueState.updateState(value);
    searchUsersState.setState(null);
    searchPostsState.setState(null);
    searchListsState.setState(null);
    try {
      var users = await searchRepository.searchUsers(value);
      gotAllUsers = users.$2;
      searchUsersState.setState(
        users.$1,
      );
    } catch (e) {
      print(e);
    }
    try {
      var posts = await searchRepository.searchPosts(value);
      gotAllPosts = posts.$2;
      searchPostsState.setState(
        posts.$1,
      );
    } catch (e) {
      print(e);
    }
    try {
      var lists = await searchRepository.searchLists(value);
      gotAllLists = lists.$2;
      searchListsState.setState(
        lists.$1,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateSearchUsers() async {
    if (loadingUpdateUsers || gotAllUsers) return;
    loadingUpdateUsers = true;
    try {
      var users = await searchRepository.searchUsers(searchValue);
      gotAllUsers = users.$2;
      searchUsersState.updateState(
        users.$1,
      );
    } catch (e) {
      print(e);
    }
    loadingUpdateUsers = false;
  }

  Future<void> updateSearchPosts() async {
    if (loadingUpdatePosts || gotAllPosts) return;
    loadingUpdatePosts = true;
    try {
      var posts = await searchRepository.searchPosts(searchValue);
      gotAllPosts = posts.$2;
      searchPostsState.updateState(
        posts.$1,
      );
    } catch (e) {
      print(e);
    }
    loadingUpdatePosts = false;
  }

  Future<void> updateSearchLists() async {
    if (loadingUpdateLists || gotAllLists) return;
    loadingUpdateLists = true;
    try {
      var lists = await searchRepository.searchLists(searchValue);
      gotAllLists = lists.$2;
      searchListsState.updateState(
        lists.$1,
      );
    } catch (e) {
      print(e);
    }
    loadingUpdateLists = false;
  }
}
