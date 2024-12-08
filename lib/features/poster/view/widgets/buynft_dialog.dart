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
import 'package:poster_stock/features/poster/data/post_service.dart';
import 'package:poster_stock/features/poster/view/widgets/button_wide.dart';
import 'package:poster_stock/main.dart';
import 'package:poster_stock/themes/build_context_extension.dart';

class BuyNftDialog extends ConsumerStatefulWidget {
  final NftForPoster nft;
  final VoidCallback onClose;
  const BuyNftDialog({
    Key? key,
    required this.nft,
    required this.onClose,
  }) : super(key: key);

  @override
  ConsumerState<BuyNftDialog> createState() => _CreatePosterDialogState();
}

class _CreatePosterDialogState extends ConsumerState<BuyNftDialog> {
  final tonWallet = TonWalletService();
  bool isLoading = false;
  double price = 0;
  double fee = 0.1;
  double paymentAmount = 0;
  int percentCreator = 0;
  int percentService = 0;
  StreamSubscription? walletSubscription;
  bool isTonWalletConnected = true;
  double balance = 0;
  bool isBalanceEnough = false;

  @override
  void initState() {
    super.initState();
    start();
  }

  @override
  void dispose() {
    walletSubscription?.cancel();
    super.dispose();
  }

  Future start() async {
    setState(() => isLoading = true);
    await tonWallet.restoreConnection();
    isTonWalletConnected = tonWallet.isConnected;
    if (!isTonWalletConnected) {
      return;
    }
    price = widget.nft.price;
    // TODO: добавить fee из nft
    // fee = widget.nft.fee;
    percentCreator = (widget.nft.royalty * 100).toInt();
    percentService = (widget.nft.serviceFee * 100).toInt();
    paymentAmount = price +
        (price * widget.nft.royalty) +
        (price * widget.nft.serviceFee) +
        fee;
    balance = tonWallet.getBalance;
    isBalanceEnough = balance < paymentAmount;
    isTonWalletConnected = tonWallet.isConnected;
    setState(() => isLoading = false);
    // Подписываемся на статус транзакции
    walletSubscription = tonWallet.transactionStream.listen((status) {
      if (!mounted) return; // Проверяем, что виджет все еще в дереве
      setState(() {
        switch (status) {
          case TransactionStatus.success:
            setState(() => isLoading = false);
            widget.onClose();
            Navigator.pop(context);
            scaffoldMessengerKey.currentState?.showSnackBar(
              SnackBars.build(context, null, "NFT куплен"),
            );
            break;
          case TransactionStatus.failed:
            setState(() => isLoading = false);
            scaffoldMessengerKey.currentState?.showSnackBar(
              SnackBars.build(context, null, "Ошибка при покупке NFT"),
            );
            break;
          case TransactionStatus.cancelled:
            setState(() => isLoading = false);
            scaffoldMessengerKey.currentState?.showSnackBar(
              SnackBars.build(context, null, "Транзакция отменена"),
            );
            break;
          case TransactionStatus.pending:
            setState(() => isLoading = true);
            break;
        }
      });
    });
  }

  void subscribeToWallet() {
    walletSubscription = tonWallet.connectionStream.listen((address) {
      setState(() {
        isLoading = false;
      });
      if (address.isNotEmpty) {
        isTonWalletConnected = true;
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBars.build(
            context,
            null,
            "Ошибка подключения кошелька",
          ),
        );
      } else {
        isTonWalletConnected = false;
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
    // try {
    //   final postService = PostService();
    //   await postService.nftSell(widget.nft.nftAddress);
    // } catch (e) {
    //   Logger.e('Error handleBuyNft: $e');
    // }
    try {
      setState(() => isLoading = true);
      // Отменяем предыдущую подписку, если она существует
      walletSubscription?.cancel();

      // Создаем новую подписку перед отправкой транзакции
      walletSubscription = tonWallet.transactionStream.listen((status) {
        if (!mounted) return;
        setState(() {
          switch (status) {
            case TransactionStatus.success:
              setState(() => isLoading = false);
              widget.onClose();
              Navigator.pop(context);
              scaffoldMessengerKey.currentState?.showSnackBar(
                SnackBars.build(context, null, "NFT куплен"),
              );
              break;
            case TransactionStatus.failed:
              setState(() => isLoading = false);
              scaffoldMessengerKey.currentState?.showSnackBar(
                SnackBars.build(context, null, "Ошибка при покупке NFT"),
              );
              break;
            case TransactionStatus.cancelled:
              setState(() => isLoading = false);
              scaffoldMessengerKey.currentState?.showSnackBar(
                SnackBars.build(context, null, "Транзакция отменена"),
              );
              break;
            case TransactionStatus.pending:
              setState(() => isLoading = true);
              break;
          }
        });
      });

      // Отправляем транзакцию
      await tonWallet.sendNftTransaction(
        nftAddress: widget.nft.nftAddress,
        amount: paymentAmount,
        contractAddress: widget.nft.contractAdress,
      );
      await Future.delayed(const Duration(seconds: 20), () async {
        try {
          final postService = PostService();
          await postService.nftSell(
              nftAddress: widget.nft.nftAddress,
              buyerAddress: tonWallet.addressWallet);
        } catch (e) {
          Logger.e('Error postService.nftSell: $e');
        }
      });

      setState(() => isLoading = false);
      widget.onClose(); // Вызываем callback
      Navigator.pop(context);
    } catch (e) {
      Logger.e('Error handleBuyNft: $e');
      setState(() => isLoading = false);
      widget.onClose(); // Вызываем callback
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = isTonWalletConnected ? 500 : 440;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          height: height,
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
                context.txt.nft_buy,
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
              const Gap(20),
              if (isTonWalletConnected) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isBalanceEnough
                          ? 'Не хватает средств на вашем счету'
                          : 'Ваш баланс',
                      style: context.textStyles.caption1!
                          .copyWith(color: context.colors.textsPrimary),
                    ),
                    Text(
                      ' ${balance.toStringAsFixed(2)}',
                      style: context.textStyles.caption1!.copyWith(
                          color: isBalanceEnough
                              ? context.colors.textsError
                              : context.colors.textsAction),
                    ),
                    const Gap(1),
                    SvgPicture.asset(
                      'assets/icons/ton_bw.svg',
                      width: 8,
                      colorFilter: ColorFilter.mode(
                        isBalanceEnough
                            ? context.colors.textsError!
                            : context.colors.textsAction!,
                        BlendMode.srcIn,
                      ),
                    )
                  ],
                ),
                const Gap(20),
              ],
              PaymentButton(
                text: isTonWalletConnected
                    ? 'Pay ${paymentAmount.toStringAsFixed(2)}'
                    : context.txt.nft_connect,
                isLoading: isLoading,
                paymentAmount: paymentAmount,
                onTap: (isLoading || !isTonWalletConnected)
                    ? handleWalletConnection
                    : handleBuyNft,
                isTon: isTonWalletConnected,
                isTonConnect: !isTonWalletConnected || isBalanceEnough,
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
