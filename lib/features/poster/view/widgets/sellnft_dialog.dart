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
  final bool isManage;

  const SellNftDialog({
    Key? key,
    required this.nft,
    required this.onClose,
    required this.isManage,
  }) : super(key: key);

  @override
  ConsumerState<SellNftDialog> createState() => _SellNftDialogState();
}

class _SellNftDialogState extends ConsumerState<SellNftDialog> {
  final tonWallet = TonWalletService();
  bool isLoading = false;
  final TextEditingController priceController = TextEditingController();
  double fee = 0.1;
  double percentCreator = 10;
  double percentService = 2.5;
  StreamSubscription? walletSubscription;
  StreamSubscription? transactionSubscription;
  bool isTonWalletConnected = true;
  bool isForSale = false;

  @override
  void initState() {
    super.initState();
    start();
    priceController.addListener(() {
      setState(() {});
    });
    isForSale = widget.isManage;
    if (!isForSale) {
      priceController.text = widget.nft.price.toString();
    }
    transactionSubscription = tonWallet.transactionStream.listen((status) {
      Logger.e('status: $status');
      switch (status) {
        case TransactionStatus.success:
          setState(() => isLoading = false);
          widget.onClose();
          Navigator.pop(context);
          scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBars.build(
              context,
              null,
              context.txt.nft_sell_success,
            ),
          );
          break;
        case TransactionStatus.failed:
          setState(() => isLoading = false);
          scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBars.build(
              context,
              null,
              context.txt.nft_sell_error,
            ),
          );
          break;
        case TransactionStatus.cancelled:
          setState(() => isLoading = false);
          scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBars.build(
              context,
              null,
              context.txt.nft_sell_cancelled,
            ),
          );
          break;
        case TransactionStatus.pending:
          setState(() => isLoading = true);
          break;
      }
    });
  }

  Future start() async {
    setState(() => isLoading = true);
    try {
      await tonWallet.restoreConnection();
      isTonWalletConnected = tonWallet.isConnected;
      Logger.d('isTonWalletConnected: $isTonWalletConnected');
      if (!isTonWalletConnected) {
        setState(() => isLoading = false);
        return;
      }
      // TODO: добавить fee из nft
      // fee = widget.nft.fee;
      isTonWalletConnected = tonWallet.isConnected;
      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
      Logger.e('Error restoreConnection: $e');
    }
  }

  /// прослушивание подключения кошелька
  void subscribeToWallet() {
    walletSubscription = tonWallet.connectionStream.listen((address) {
      if (address.isNotEmpty) {
        isTonWalletConnected = true;
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBars.build(
            context,
            null,
            context.txt.nft_connect,
          ),
        );
        start();
      } else {
        isTonWalletConnected = false;
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBars.build(
            context,
            null,
            context.txt.nft_connect_error,
          ),
        );
      }
      setState(() {});
    });
  }

  /// ручное подключение кошелька
  Future<void> handleWalletConnection() async {
    bool isConnected = await tonWallet.connect();
    Logger.d('handleWalletConnection == $isConnected');
    if (!isConnected) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBars.build(
          context,
          null,
          context.txt.nft_connect_error,
        ),
      );
      return;
    } else {
      subscribeToWallet();
    }
  }

  @override
  void dispose() {
    transactionSubscription?.cancel();
    priceController.removeListener(() {});
    priceController.dispose();
    super.dispose();
  }

  Future<void> handleSellNft() async {
    if (priceController.text.isEmpty) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBars.build(context, null, context.txt.nft_price_empty),
      );
      return;
    }
    try {
      setState(() => isLoading = true);
      final price = double.parse(priceController.text);
      final priceInNano = BigInt.from(price * 1e9);
      await tonWallet.createNFTSale(
        nftAddress: widget.nft.nftAddress,
        ownerAddress: tonWallet.getWalletAddress(),
        royaltyAddress: widget.nft.creatorAddress,
        price: priceInNano,
        amount: BigInt.from(0.1 * 1e9),
        percentMarketplace: percentService,
        percentRoyalty: percentCreator,
        destination: widget.nft.destination,
      );

      setState(() => isLoading = false);
      widget.onClose();
      Navigator.pop(context);
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBars.build(
          context,
          null,
          context.txt.nft_sell_success,
        ),
      );
    } catch (e) {
      Logger.e('Error handleSellNft: $e');
      setState(() => isLoading = false);
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBars.build(
          context,
          null,
          context.txt.nft_sell_error,
        ),
      );
    }
  }

  Future<void> showRemoveFromSaleDialog() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
              height: 182,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: context.colors.backgroundsPrimary,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      context.txt.nft_remove_quest,
                      style: context.textStyles.callout,
                    ),
                  ),
                  const Gap(20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(
                          context, true); // Возвращаем true при нажатии
                    },
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: context.colors.textsError),
                        const Gap(8),
                        Text(
                          context.txt.nft_remove,
                          style: context.textStyles.callout!
                              .copyWith(color: context.colors.textsError),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    Logger.e('result: $result');
    if (result == true) {
      await tonWallet.createNFTUnSale(
        nftAddressContract: widget.nft.contractAdress,
      );
      widget.onClose();
      Navigator.pop(context);
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
          height: 390 + (isForSale || !isTonWalletConnected ? 50 : 0),
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
                mainAxisAlignment: !isForSale && isTonWalletConnected
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Gap(12),
                  Text(
                    isForSale ? 'Sell NFT' : 'Manage NFT',
                    style: context.textStyles.headline,
                  ),
                  if (!isForSale && isTonWalletConnected)
                    GestureDetector(
                      onTap: showRemoveFromSaleDialog,
                      child: SvgPicture.asset(
                        'assets/icons/ic_price_off.svg',
                        width: 22,
                        height: 22,
                        colorFilter: ColorFilter.mode(
                          context.colors.textsPrimary!,
                          BlendMode.srcIn,
                        ),
                      ),
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
                            enabled: isForSale,
                            decoration: const InputDecoration(
                              hintText: 'Item price',
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              color: context.colors
                                  .textsPrimary, // Установите основной цвет текста
                            ),
                          ),
                        ),
                        SvgPicture.asset(
                          'assets/icons/ton_bw.svg',
                          colorFilter: ColorFilter.mode(
                            context.colors.textsPrimary!,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                    lineText('Creator Fee', '$percentCreator%'),
                    lineText('Service Fee', '$percentService%'),
                    lineText(
                      context.txt.nft_receive,
                      calculateReceiveAmount().toStringAsFixed(2),
                      isIcon: true,
                    ),
                  ],
                ),
              ),
              if (isForSale && isTonWalletConnected) ...[
                const Gap(20),
                PaymentButton(
                  text: isForSale ? 'Put on Sale' : 'Save price',
                  isLoading: isLoading,
                  paymentAmount: double.tryParse(priceController.text) ?? 0,
                  onTap: handleSellNft,
                  isTon: false,
                  isTonConnect: priceController.text.isEmpty,
                ),
              ],
              if (!isTonWalletConnected) ...[
                const Gap(20),
                PaymentButton(
                  text: context.txt.nft_connect,
                  isLoading: isLoading,
                  paymentAmount: 0,
                  onTap: handleWalletConnection,
                  isTon: isTonWalletConnected,
                  isTonConnect: true,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  double calculateReceiveAmount() {
    double price = double.tryParse(priceController.text) ?? 0;
    double priceEnd =
        price - (price * percentCreator / 100) - (price * percentService / 100);
    return priceEnd;
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
                  child: SvgPicture.asset(
                    'assets/icons/ton_bw.svg',
                    colorFilter: ColorFilter.mode(
                      context.colors.textsPrimary!,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
