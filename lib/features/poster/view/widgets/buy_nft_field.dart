import 'dart:async';

import 'package:darttonconnect/exceptions.dart';
import 'package:darttonconnect/models/wallet_app.dart';
import 'package:darttonconnect/parsers/connect_event.dart';
import 'package:darttonconnect/parsers/send_transaction.dart';
import 'package:darttonconnect/provider/bridge_provider.dart';
import 'package:darttonconnect/storage/default_storage.dart';
import 'package:darttonconnect/storage/interface.dart';
import 'package:darttonconnect/ton_connect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:poster_stock/common/widgets/app_text_button.dart';
import 'package:poster_stock/features/home/models/nft.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:poster_stock/features/poster/view/widgets/buynft_dialog.dart';
import 'package:poster_stock/features/settings/state_holders/change_wallet_state_holder.dart';
import 'package:poster_stock/themes/build_context_extension.dart';
import 'package:url_launcher/url_launcher.dart';

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
                bool isShow = await showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (context) => BuyNftDialog(nft: widget.post.nft),
                );
                return;
                // final TonConnect connector =
                //     TonConnect('https://posterstock.com/tonconnect_ps.json');
                NftForPoster nft = widget.post.nft;
                int amount = ((nft.price + 0.1) * 1e9).toInt();
                final transaction = {
                  // "valid_until": 0,
                  "messages": [
                    {
                      "type": "transfer",
                      "address": nft.address,
                      "amount": amount.toString(),
                    }
                  ]
                };
                try {
                  const Map<String, dynamic> walletConnectionSource = {
                    "app_name": "tonkeeper",
                    "name": "Tonkeeper",
                    "image": "https://tonkeeper.com/assets/tonconnect-icon.png",
                    "tondns": "tonkeeper.ton",
                    "about_url": "https://tonkeeper.com",
                    "universal_url": "https://app.tonkeeper.com/ton-connect",
                    "deepLink": "tonkeeper-tc://",
                    "bridge": [
                      {"type": "sse", "url": "https://bridge.tonapi.io/bridge"},
                      {"type": "js", "key": "tonkeeper"}
                    ],
                    "platforms": [
                      "ios",
                      "android",
                      "chrome",
                      "firefox",
                      "macos"
                    ]
                  };
                  WalletApp walletApp = WalletApp(
                    aboutUrl: walletConnectionSource['about_url'],
                    bridgeUrl: walletConnectionSource['bridge'][0]['url'],
                    image: walletConnectionSource['image'],
                    name: walletConnectionSource['name'],
                    universalUrl: walletConnectionSource['universal_url'],
                  );

                  if (connector != null && !connector!.connected) {
                    final universalLink = await connector!.connect(walletApp);
                    Logger.i('universalLink >>>>>>>>>>>> $universalLink}');
                    final Uri uri = Uri.parse(universalLink);
                    if (await canLaunchUrl(uri)) {
                      bool launched = await launchUrl(uri);
                      if (!launched) {
                        Logger.e('Не удалось запустить $universalLink');
                      }
                    } else {
                      Logger.e('Не удалось запустить $universalLink');
                    }
                    // bool isConnected = await waitForConnection(60);
                    // if (isConnected) {
                    //   Logger.i('sendTransaction1 $provider');
                    //   // await connector!.sendTransaction(transaction);
                    //   Map<String, dynamic> response = await provider!
                    //       .sendRequest(SendTransactionParser()
                    //           .convertToRpcRequest(transaction));
                    //   Logger.e('response >>>>>>>>>>>> $response');
                    // } else {
                    //   Logger.e(
                    //       'Не удалось установить соединение в течение 60 секунд');
                    // }
                  } else {
                    final st = await connector!.sendTransaction(transaction);
                    Logger.e('connector sendTransaction >>>>>>>>>>>> $st}');
                    // provider = BridgeProvider(storage,
                    //     wallet: walletInfo as WalletApp?);
                    // provider!.listen(walletEventsListener);
                    // Logger.i('sendTransaction2 $provider');
                    // Map<String, dynamic> response = await provider!.sendRequest(
                    //     SendTransactionParser()
                    //         .convertToRpcRequest(transaction));
                    // Logger.e('response >>>>>>>>>>>> $response');
                  }
                } catch (e) {
                  if (e is UserRejectsError) {
                    Logger.i(
                        'You rejected the transaction. Please confirm it to send to the blockchain');
                  } else {
                    Logger.e('Ошибка при отправке транзакции2 $e');
                  }
                }
              },
              text: context.txt.buy,
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
