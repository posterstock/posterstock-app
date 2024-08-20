import 'package:flutter/material.dart';
import 'package:poster_stock/features/settings/state_holders/change_wallet_state_holder.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QRViewExample extends ConsumerWidget {
  const QRViewExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Сканирование QR-кода'),
      ),
      body: QRView(
        key: GlobalKey(debugLabel: 'QR'),
        onQRViewCreated: (controller) {
          controller.scannedDataStream.listen((scanData) {
            ref
                .read(changeWalletStateHolderProvider.notifier)
                .setWallet(scanData.code ?? '');
          });
        },
      ),
    );
  }
}
