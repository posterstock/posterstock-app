import 'dart:convert';
import 'dart:math';

import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/list/repository/list_repository.dart';
import 'package:poster_stock/features/poster/repository/post_repository.dart';
import 'package:poster_stock/features/poster/state_holder/comments_state_holder.dart';
import 'package:poster_stock/features/poster/state_holder/my_lists_state_holder.dart';
import 'package:poster_stock/features/poster/state_holder/poster_state_holder.dart';
import 'package:poster_stock/features/profile/repository/profile_repository.dart';
import 'package:poster_stock/features/profile/state_holders/my_profile_info_state_holder.dart';
import 'package:http/http.dart' as http;
import 'package:tonutils/tonutils.dart' as ton;

final postControllerProvider = Provider<PostController>(
  (ref) => PostController(
    commentsStateHolder: ref.watch(commentsStateHolderProvider.notifier),
    posterStateHolder: ref.watch(posterStateHolderProvider.notifier),
    myProfileInfoStateHolder:
        ref.watch(myProfileInfoStateHolderProvider.notifier),
    myListsStateHolder: ref.watch(myListsStateHolderProvider.notifier),
  ),
);

class PostController {
  final CommentsStateHolder commentsStateHolder;
  final PosterStateHolder posterStateHolder;
  final MyProfileInfoStateHolder myProfileInfoStateHolder;
  final MyListsStateHolder myListsStateHolder;
  final ListRepository listRepository = ListRepository();
  final profileRepo = ProfileRepository();
  final postRepository = PostRepository();
  final cachedPostRepository = CachedPostRepository();
  bool loadingComments = false;
  bool loadingPost = false;

  PostController({
    required this.commentsStateHolder,
    required this.posterStateHolder,
    required this.myProfileInfoStateHolder,
    required this.myListsStateHolder,
  });

  Future<void> clear() async {
    commentsStateHolder.clearComments();
    posterStateHolder.clear();
  }

  Future<void> postComment(final int id, final String text) async {
    final result = await postRepository.postComment(id, text);
    await commentsStateHolder.updateMoreComments([result]);
  }

  Future<void> deleteComment(final int postId, final int id) async {
    await postRepository.deleteComment(postId, id);
    commentsStateHolder.deleteComment(id);
  }

  Future<void> postCommentList(final int id, final String text) async {
    final result = await postRepository.postCommentList(id, text);
    await commentsStateHolder.updateMoreComments([result]);
  }

  Future<void> updateComments(final int id) async {
    if (loadingComments) return;
    loadingComments = true;

    var result = await cachedPostRepository.getComments(id);
    if (result != null) {
      await commentsStateHolder.updateComments(result);
      loadingComments = false;
    }

    result = await postRepository.getComments(id);
    cachedPostRepository.cacheComments(id, result);
    await commentsStateHolder.updateComments(result);
    loadingComments = false;
  }

  Future<void> getPost(final int id) async {
    if (loadingPost) return;
    loadingPost = true;
    var resultNft = await cachedPostRepository.getPost(id);
    if (resultNft != null) {
      resultNft = await _prepareData(resultNft, cached: true);
      await posterStateHolder.updateState(resultNft);
      loadingPost = false;
    }

    resultNft = await postRepository.getPost(id);
    final List<Map<String, dynamic>> resultNFTs =
        await postRepository.getNFT(resultNft.nft.collection);

    int index = 1;
    int allCount = 1;
    double price = 0;
    double priceReal = 0;
    String blocChain = 'Ton';
    String address = '';
    double serviceFee = 0;
    double royalty = 0;
    String nftAddress = '';

    if (resultNFTs.isNotEmpty) {
      Map<String, dynamic> result = resultNFTs.first;

      for (var item in resultNFTs) {
        Logger.i('item >>>>>>>>> $item');
        Logger.i('sale >>>>>>>>> ${item['sale']}');
        if (item['sale'] != null) {
          result = item;
          nftAddress = item['address'];
          break;
        }
      }
      allCount = resultNFTs.length;
      index = result['index'];
      Map<String, dynamic>? sale = result['sale'];
      if (sale != null) {
        Logger.i('sale >>>>>>>>> $sale');
        address = sale['address'];
        int temp = int.parse(sale['price']['value']);
        price = temp / pow(10, 9);
        blocChain = sale['price']['token_name'];
        final response = await http.get(
            Uri.parse('https://tonapi.io/v2/rates?tokens=ton&currencies=usd'));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          double usdRate = data['rates']['TON']['prices']['USD'];
          priceReal = price * usdRate; // Применяем курс к цене
        } else {
          Logger.e('Ошибка при получении курса: ${response.statusCode}');
        }

        try {
          // Получаем serviceFee и royalty через GraphQL запрос
          var graphqlEndpoint = Uri.parse('https://api.getgems.io/graphql');
          graphqlEndpoint = Uri.parse('https://api.testnet.getgems.io/graphql');

          final formattedAddress = ton
              .address(address)
              .toString(isTestOnly: true, isUrlSafe: true, isBounceable: true);

          Logger.e('Formatted address: $formattedAddress');

          const query = '''
    query NftFixPriceSaleCalculateFee(\$nftAddress: String!) {
      nftFixPriceSaleCalculateFee(nftAddress: \$nftAddress) {
        marketplaceFee
        royaltyPercent
      }
    }
  ''';
          Logger.i('query >>>>>>>>> $query');
          final response = await http.post(
            graphqlEndpoint,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'query': query,
              'variables': {
                'nftAddress': resultNft.nft.collection,
                'first': null,
              },
            }),
          );
          Logger.e('response >>>>>>>>> ${response.body}');
          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            serviceFee = data['data']['nftFixPriceSaleCalculateFee']
                    ['marketplaceFee'] ??
                0.0;
            royalty = data['data']['nftFixPriceSaleCalculateFee']
                    ['royaltyPercent'] ??
                0.0;
          } else {
            Logger.e(
                'Ошибка при получении serviceFee и royalty: ${response.statusCode}');
          }
        } catch (e) {
          Logger.e('Ошибка при получении serviceFee и royalty: $e');
        }
      }
    }
    Logger.i('serviceFee >>>>>>>>> $serviceFee');
    Logger.i('royalty >>>>>>>>> $royalty');
    resultNft = resultNft.copyWith(
        nft: resultNft.nft.copyWith(
      allCount: allCount,
      number: ++index,
      price: price,
      blocChain: blocChain,
      priceReal: priceReal,
      address: address,
      serviceFee: serviceFee,
      royalty: royalty,
      nftAddress: nftAddress,
    ));
    cachedPostRepository.cachePost(id, resultNft);
    cachedPostRepository.cachePost(id, resultNft);
    resultNft = await _prepareData(resultNft);
    await posterStateHolder.updateState(resultNft);
    loadingPost = false;
  }

  Future<PostMovieModel> _prepareData(PostMovieModel result,
      {bool cached = false}) async {
    var splitted = result.tmdbLink!.split('/');
    if (splitted.last.isEmpty) splitted.removeLast();
    int tmdbId = result.mediaId ?? int.parse(splitted.last);
    bool? hasInCollection = await cachedPostRepository.getInCollection(tmdbId);
    if (!cached || hasInCollection == null) {
      hasInCollection = await postRepository.getInCollection(tmdbId);
      cachedPostRepository.cacheCollection(tmdbId, hasInCollection);
    }
    return result.copyWith(hasInCollection: hasInCollection);
  }

  Future<void> deletePost(final int id) async {
    await postRepository.deletePost(id);
  }

  Future<void> addPosterToList(int listId, int postId) async {
    final list = await listRepository.getPost(listId);
    await postRepository.addPosterToList(list, postId);
  }

  Future<void> getMyLists() async {
    final result = await profileRepo
        .getProfileLists(myProfileInfoStateHolder.currentState!.id);
    myListsStateHolder.updateLists(result);
  }

  Future<void> setBookmarked(int id, bool bookmarked) async {
    await posterStateHolder.updateBookmarked(bookmarked);
    postRepository.setBookmarked(id, bookmarked);
  }
}
