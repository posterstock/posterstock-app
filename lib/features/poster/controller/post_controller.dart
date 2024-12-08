import 'dart:convert';
import 'dart:math';

import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/common/constants/nft_adress.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/list/repository/list_repository.dart';
import 'package:poster_stock/features/poster/controller/convert_adress_ton.dart';
import 'package:poster_stock/features/poster/repository/post_repository.dart';
import 'package:poster_stock/features/poster/state_holder/comments_state_holder.dart';
import 'package:poster_stock/features/poster/state_holder/my_lists_state_holder.dart';
import 'package:poster_stock/features/poster/state_holder/poster_state_holder.dart';
import 'package:poster_stock/features/profile/repository/profile_repository.dart';
import 'package:poster_stock/features/profile/state_holders/my_profile_info_state_holder.dart';
import 'package:http/http.dart' as http;

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

    int index = 0;
    int allCount = 1;
    double price = 0;
    double priceReal = 0;
    String blocChain = 'Ton';
    String address = '';
    double serviceFee = 0;
    double royalty = 0;
    String nftAddress = '';
    String creatorAddress = '';
    String destination = '';
    Map<String, dynamic>? sale;
    if (resultNFTs.isNotEmpty) {
      nftAddress = resultNft.nft.nftAddress;
      Map<String, dynamic> result = resultNFTs.first;
      final isMyPoster = myProfileInfoStateHolder.currentState?.id != null &&
          myProfileInfoStateHolder.currentState!.id == resultNft.author.id;
      final nftAddressConverted =
          TonAddressConverter.friendlyToRaw(resultNft.nft.nftAddress);
      if (isMyPoster) {
        for (var item in resultNFTs) {
          if (nftAddressConverted == item['address']) {
            Logger.e('result = item ');
            result = item;
            break;
          }
        }
      } else {
        for (var item in resultNFTs) {
          Logger.e('item >>>>>>>>> ${item['sale']}');
          if (item['sale'] != null) {
            result = item;
            break;
          }
        }
      }

      if (result['collection'] != null &&
          result['collection']['address'] != null) {
        creatorAddress = result['collection']['address'];
      }
      allCount = resultNFTs.length;
      index = result['index'];
      sale = result['sale'];
      if (sale != null) {
        Logger.e('sale >>>>>>>>> $sale');
        nftAddress = result['address'];
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
          final tonApiEndpoint =
              Uri.parse('$blockChainUrl$address/methods/get_sale_data');
          Logger.e('tonApiEndpoint >>>>>>>>> $tonApiEndpoint');
          final response = await http.get(
            tonApiEndpoint,
            headers: {
              'Accept': 'application/json',
            },
          );

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            final marketFee = data['decoded']['market_fee'];
            final digits = marketFee.toString().length;
            serviceFee = marketFee / pow(10, digits + 1);
            royalty = data['decoded']['royalty_amount'] / pow(10, 11);
            Logger.e('serviceFee >>>>>>>>> $serviceFee $royalty');
          } else {
            Logger.e(
                'Ошибка при получении данных из TON API: ${response.statusCode}');
          }
        } catch (e) {
          Logger.e('Ошибка при получении serviceFee и royalty: $e');
        }
      }
      try {
        // Получаем serviceFee и royalty через GraphQL запрос
        final tonApiEndpointRoyaltyParams = Uri.parse(
            '$blockChainUrl${resultNft.nft.collection}/methods/royalty_params');
        Logger.e(
            'tonApiEndpointRoyaltyParams >>>>>>>>> $tonApiEndpointRoyaltyParams');
        final response = await http.get(
          tonApiEndpointRoyaltyParams,
          headers: {
            'Accept': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final decoded = data['decoded'];
          // Вычисляем royalty из numerator/denominator
          royalty = decoded['numerator'] / decoded['denominator'];
          destination = decoded['destination'];
          Logger.e('Royalty: $royalty, Destination: $destination');
        }
      } catch (e) {
        Logger.e(
            'Ошибка royalty_params при получении serviceFee и royalty: $e');
      }
    }
    resultNft = resultNft.copyWith(
        nft: resultNft.nft.copyWith(
            allCount: allCount,
            number: index > 0 ? ++index : index,
            price: price,
            blocChain: blocChain,
            priceReal: priceReal,
            address: address,
            serviceFee: serviceFee,
            royalty: royalty,
            nftAddress: nftAddress,
            isForSale: sale == null,
            creatorAddress: creatorAddress,
            contractAdress: address,
            destination: destination));
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
