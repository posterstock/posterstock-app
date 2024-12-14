import 'dart:async';

import 'package:darttonconnect/exceptions.dart';
import 'package:darttonconnect/parsers/connect_event.dart';
import 'package:darttonconnect/provider/bridge_provider.dart';
import 'package:darttonconnect/storage/default_storage.dart';
import 'package:darttonconnect/storage/interface.dart';
import 'package:darttonconnect/ton_connect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:poster_stock/common/widgets/app_text_button.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/poster/controller/post_controller.dart';
import 'package:poster_stock/features/poster/view/widgets/buynft_dialog.dart';
import 'package:poster_stock/features/poster/view/widgets/sellnft_dialog.dart';
import 'package:poster_stock/features/settings/state_holders/change_wallet_state_holder.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class BuyNftField extends ConsumerStatefulWidget {
  final PostMovieModel post;

  const BuyNftField({
    super.key,
    required this.post,
  });

  @override
  BuyNftFieldState createState() => BuyNftFieldState();
}

class BuyNftFieldState extends ConsumerState<BuyNftField> {
  TonConnect? connector;
  StreamSubscription? subscription;
  IStorage storage = DefaultStorage();
  BridgeProvider? provider;
  WalletInfo? walletInfo;

  List<void Function(dynamic value)> statusChangeSubscriptions = [];
  List<void Function(dynamic value)> statusChangeErrorSubscriptions = [];

  @override
  void initState() {
    super.initState();
    ref.read(changeWalletStateHolderProvider.notifier).loadFromLocal();
    connector = TonConnect('https://posterstock.com/tonconnect_ps.json');
    connector!.onStatusChange(handleWalletStatusChange);
    resetLastEventId();
  }

  Future<void> resetLastEventId() async {
    try {
      await storage.removeItem(key: 'lastWalletEventId');
    } catch (e) {
      Logger.e(
          'Ошибка при сбросе идентификатора последнего события кошелька: $e');
    }
    await storage.setItem(key: 'lastWalletEventId', value: '0');
  }

  void walletEventsListener(Map<String, dynamic> data) {
    if (data['event'] == 'connect') {
      _onWalletConnected(data['payload']);
    } else if (data['event'] == 'connect_error') {
      _onWalletConnectError(data['payload']);
    } else if (data['event'] == 'disconnect') {
      _onWalletDisconnected();
    }
  }

  void _onWalletConnected(dynamic payload) {
    walletInfo = ConnectEventParser.parseResponse(payload);
    for (var listener in statusChangeSubscriptions) {
      listener(walletInfo);
    }
  }

  void _onWalletConnectError(dynamic payload) {
    Logger.e('connect error $payload');
    dynamic error = ConnectEventParser.parseError(payload);
    for (var listener in statusChangeErrorSubscriptions) {
      listener(error);
    }

    if (error is ManifestNotFoundError || error is ManifestContentError) {
      Logger.e(error);
      throw error;
    }
  }

  void _onWalletDisconnected() {
    walletInfo = null;
    for (var listener in statusChangeSubscriptions) {
      listener(null);
    }
  }

  void handleWalletStatusChange(dynamic walletInfo) {
    if (walletInfo != null) {
      walletInfo = walletInfo;
      provider = BridgeProvider(storage, wallet: walletInfo);
      provider!.listen(walletEventsListener);
    } else {
      Logger.i('Кошелек отключен');
    }
  }

  Future<bool> waitForConnection(int timeoutSeconds) async {
    final Completer<bool> completer = Completer<bool>();

    // Установка таймера
    Timer(Duration(seconds: timeoutSeconds), () {
      if (!completer.isCompleted) completer.complete(false);
    });

    // Проверка соединения каждую секунду
    while (!connector!.connected) {
      await Future.delayed(const Duration(seconds: 1));
      if (connector!.connected) {
        completer.complete(true);
        break;
      }
    }

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    // WalletState wallet = ref.watch(changeWalletStateHolderProvider);

    Logger.i('post ${widget.post.nft.toJson()}');
    return Column(
      children: [
        const Gap(15),
        const CustomDivider(),
        const Gap(17),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Transform.translate(
                      offset: const Offset(0, 1),
                      child: Text(
                        widget.post.nft.price.toStringAsFixed(3),
                        style: context.textStyles.title2!.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: context.colors.buttonsSecondary,
                          height: 1,
                        ),
                      ),
                    ),
                    const Gap(5),
                    Text(
                      widget.post.nft.blocChain,
                      style: context.textStyles.subheadlineBold!.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: context.colors.buttonsSecondary,
                      ),
                    ),
                    const Gap(5),
                    Text(
                      '\$${widget.post.nft.priceReal.toStringAsFixed(2)}',
                      style: context.textStyles.subheadline!.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: context.colors.textsDisabled),
                    ),
                  ],
                ),
                Text(
                  '+  ${widget.post.nft.fee} ${widget.post.nft.blocChain} network fee',
                  style: context.textStyles.subheadline!.copyWith(
                    color: context.colors.textsSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            AppTextButton(
              onTap: () async {
                await showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (context) {
                    if (widget.post.nft.isOwnerSale) {
                      return SellNftDialog(
                        nft: widget.post.nft,
                        onClose: () => ref
                            .read(postControllerProvider)
                            .getPost(widget.post.id),
                      );
                    } else {
                      return BuyNftDialog(
                        nft: widget.post.nft,
                        onClose: () => ref
                            .read(postControllerProvider)
                            .getPost(widget.post.id),
                      );
                    }
                  },
                );
                return;
              },
              text: widget.post.nft.isOwnerSale
                  ? context.txt.nft_manage
                  : context.txt.nft_buy,
            ),
          ],
        ),
      ],
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          height: 0.5,
          thickness: 0.5,
          color: context.colors.fieldsDefault,
        ),
      ],
    );
  }
}
