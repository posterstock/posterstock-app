// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class SellNftDialog extends ConsumerStatefulWidget {
  final NftForPoster nft;
  final VoidCallback onClose;

  const SellNftDialog({
    Key? key,
    required this.nft,
    required this.onClose,
  }) : super(key: key);

  @override
  ConsumerState<SellNftDialog> createState() => _SellNftDialogState();
}

class _SellNftDialogState extends ConsumerState<SellNftDialog> {
  final tonWallet = TonWalletService();
  bool isLoading = false;
  final TextEditingController priceController = TextEditingController();
  double fee = 0.1;
  int percentCreator = 0;
  int percentService = 0;
  StreamSubscription? walletSubscription;
  bool isTonWalletConnected = true;

  @override
  void initState() {
    super.initState();
    start();
    percentCreator = (widget.nft.royalty * 100).toInt();
    percentService = (widget.nft.serviceFee * 100).toInt();
    priceController.addListener(() {
      setState(() {});
    });
  }

  Future start() async {
    setState(() => isLoading = true);
    await tonWallet.restoreConnection();
    isTonWalletConnected = tonWallet.isConnected;
    if (!isTonWalletConnected) {
      return;
    }
    // TODO: добавить fee из nft
    // fee = widget.nft.fee;
    percentCreator = (widget.nft.royalty * 100).toInt();
    percentService = (widget.nft.serviceFee * 100).toInt();
    isTonWalletConnected = tonWallet.isConnected;
    setState(() => isLoading = false);
    // Подписываемся на статус транзакции
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

  @override
  void dispose() {
    priceController.removeListener(() {});
    priceController.dispose();
    super.dispose();
  }

  Future<void> handleSellNft() async {
    try {
      setState(() => isLoading = true);

      // TODO: Implement sell NFT logic here
      // await tonWallet.sellNFT(...);

      setState(() => isLoading = false);
      widget.onClose();
      Navigator.pop(context);

      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBars.build(context, null, "NFT выставлен на продажу"),
      );
    } catch (e) {
      Logger.e('Error handleSellNft: $e');
      setState(() => isLoading = false);
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBars.build(context, null, "Ошибка при выставлении NFT на продажу"),
      );
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
          height: 440,
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
              const Gap(22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Gap(12),
                  Text(
                    'Sell NFT',
                    style: context.textStyles.headline,
                  ),
                  SvgPicture.asset(
                    'assets/icons/ic_price_off.svg',
                    width: 22,
                    height: 22,
                  ),
                ],
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: priceController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9.]')),
                            ],
                            decoration: const InputDecoration(
                              hintText: 'Item price',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SvgPicture.asset(
                          'assets/icons/ton_bw.svg',
                          colorFilter: ColorFilter.mode(
                            context.colors.textsDisabled!,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                    lineText('Creator Fee', '$percentCreator%'),
                    lineText('Service Fee', '$percentService%'),
                    lineText(
                      'You Receive',
                      calculateReceiveAmount().toStringAsFixed(2),
                      isIcon: true,
                    ),
                  ],
                ),
              ),
              const Gap(20),
              PaymentButton(
                text: 'Put on Sale',
                isLoading: isLoading,
                paymentAmount: double.tryParse(priceController.text) ?? 0,
                onTap: handleSellNft,
                isTon: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  double calculateReceiveAmount() {
    double price = double.tryParse(priceController.text) ?? 0;
    return price -
        (price * widget.nft.royalty) -
        (price * widget.nft.serviceFee);
  }

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
              Text(
                text,
                style: context.textStyles.callout!
                    .copyWith(color: context.colors.textsPrimary),
              ),
              if (subText.isNotEmpty) const Gap(4),
              if (subText.isNotEmpty)
                Text(
                  subText,
                  style: context.textStyles.caption1!
                      .copyWith(color: context.colors.textsSecondary),
                ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                value,
                style: context.textStyles.callout!
                    .copyWith(color: context.colors.textsPrimary),
              ),
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
