import 'dart:async';

import 'package:darttonconnect/exceptions.dart';
import 'package:darttonconnect/models/wallet_app.dart';
import 'package:darttonconnect/provider/bridge_provider.dart';
import 'package:darttonconnect/storage/default_storage.dart';
import 'package:darttonconnect/storage/interface.dart';
import 'package:darttonconnect/ton_connect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:poster_stock/common/widgets/app_text_button.dart';
import 'package:poster_stock/features/NFT/models/wallet_state.dart';
import 'package:poster_stock/features/home/models/nft.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
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

  void handleWalletStatusChange(dynamic walletInfo) {
    if (walletInfo != null) {
      Logger.i('walletInfo >>>>>>>>>>>> $walletInfo');
      // setState(() {});
    } else {
      Logger.i('Кошелек отключен');
    }
  }

  void walletEventsListener(Map<String, dynamic> data) {
    Logger.i('walletEventsListener >>>>>>>>>>>> $data');
  }

  @override
  Widget build(BuildContext context) {
    WalletState wallet = ref.watch(changeWalletStateHolderProvider);

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
                // final TonConnect connector =
                //     TonConnect('https://posterstock.com/tonconnect_ps.json');
                NftForPoster nft = widget.post.nft;
                int amount = ((nft.price + 0.1) * 1e9).toInt();
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

                  BridgeProvider provider =
                      BridgeProvider(storage, wallet: walletApp);

                  provider.listen(walletEventsListener);
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
                } catch (e) {
                  if (e is UserRejectsError) {
                    Logger.i(
                        'You rejected the transaction. Please confirm it to send to the blockchain');
                  } else {
                    Logger.e('Ошибка при отправке транзакции $e');
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
