// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:poster_stock/common/widgets/app_snack_bar.dart';
import 'package:poster_stock/features/NFT/models/ton_wallet_service.dart';
import 'package:poster_stock/features/home/models/nft.dart';
import 'package:poster_stock/features/home/view/widgets/text_or_container.dart';
import 'package:poster_stock/features/poster/view/widgets/button_wide.dart';
import 'package:poster_stock/main.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class BuyNftDialog extends ConsumerStatefulWidget {
  final NftForPoster nft;
  const BuyNftDialog({Key? key, required this.nft}) : super(key: key);

  @override
  ConsumerState<BuyNftDialog> createState() => _CreatePosterDialogState();
}

class _CreatePosterDialogState extends ConsumerState<BuyNftDialog> {
  final tonWallet = TonWalletService();
  bool isLoading = false;
  double price = 0;
  double fee = 0.3;
  double paymentAmount = 0;
  int percentCreator = 10;
  int percentService = 5;
  StreamSubscription? walletSubscription;
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    price = widget.nft.price;
    fee = widget.nft.fee;
    double creatorRoyalty = (price * percentCreator) / 100;
    paymentAmount = price + fee + creatorRoyalty;
    restoreWalletConnection();
  }

  @override
  void dispose() {
    walletSubscription?.cancel();
    super.dispose();
  }

  Future<void> restoreWalletConnection() async {
    await tonWallet.restoreConnection();
    if (!tonWallet.isConnected) {
      subscribeToWallet();
    }
    isConnected = tonWallet.isConnected;
    setState(() {});
  }

  void subscribeToWallet() {
    walletSubscription = tonWallet.connectionStream.listen((address) {
      setState(() {
        isLoading = false;
      });
      if (address.isNotEmpty) {
        isConnected = true;
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBars.build(
            context,
            null,
            "Ошибка подключения кошелька",
          ),
        );
      } else {
        isConnected = false;
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBars.build(
            context,
            null,
            "Ошибка подключения кошелька",
          ),
        );
      }
      setState(() {});
    });
  }

  Future<void> handleWalletConnection() async {
    setState(() => isLoading = true);
    await tonWallet.connect();
  }

  Future<void> handleBuyNft() async {
    try {
      setState(() => isLoading = true);
      await tonWallet.sendNftTransaction(
        contractAddress: widget.nft.address,
        amount: paymentAmount,
      );
    } catch (e) {
      // Добавьте обработку ошибок
      Logger.e('Error handleBuyNft: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          height: isConnected ? 430 : 500,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: context.colors.backgroundsPrimary,
          ),
          child: Column(
            children: [
              const Gap(12),
              Container(
                height: 4,
                width: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.0),
                  color: context.colors.fieldsDefault,
                ),
              ),
              const Gap(18),
              Text(
                context.txt.buy,
                style: context.textStyles.headline,
              ),
              const Gap(18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 227,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: nftGradientBoxBorder(),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    lineText('NFT Price', price.toString(), isIcon: true),
                    lineText('Creator Royalties', '$percentCreator%'),
                    lineText('Service Fee', '$percentService%'),
                    lineText('Network Fee', '$fee',
                        subText: 'The rest will be returned to your wallet',
                        isIcon: true),
                  ],
                ),
              ),
              const Gap(18),
              if (!isConnected)
                PaymentButton(
                  text: context.txt.connect,
                  isLoading: isLoading,
                  paymentAmount: paymentAmount,
                  onTap: handleWalletConnection,
                  isTon: false,
                ),
              if (!isConnected) const Gap(18),
              PaymentButton(
                text: 'Pay ${paymentAmount.toStringAsFixed(2)}',
                isLoading: isLoading,
                paymentAmount: paymentAmount,
                onTap: (isLoading || !isConnected) ? null : handleBuyNft,
                isTon: true,
                isTonConnect: !isConnected,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Line text with icon and subtext
  Widget lineText(
    String text,
    String value, {
    String subText = '',
    bool isIcon = false,
  }) {
    return Container(
      height: 56,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: context.colors.fieldsDefault!,
            width: subText.isNotEmpty ? 0.5 : 0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text,
                  style: context.textStyles.callout!
                      .copyWith(color: context.colors.textsPrimary)),
              if (subText.isNotEmpty) const Gap(4),
              if (subText.isNotEmpty)
                Text(subText,
                    style: context.textStyles.caption1!
                        .copyWith(color: context.colors.textsSecondary)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(value,
                  style: context.textStyles.callout!
                      .copyWith(color: context.colors.textsPrimary)),
              if (isIcon) const Gap(4),
              if (isIcon)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: SvgPicture.asset('assets/icons/ton_bw.svg'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
