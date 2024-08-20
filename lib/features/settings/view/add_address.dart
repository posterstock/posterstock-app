import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:gap/gap.dart';
import 'package:poster_stock/common/widgets/app_text_button.dart';

import 'package:poster_stock/themes/build_context_extension.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class AddAddress extends StatefulWidget {
  final String address;
  const AddAddress({super.key, required this.address});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final formKey = GlobalKey<FormState>();
  final walletAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    walletAddressController.text = widget.address;
  }

  @override
  void dispose() {
    walletAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> scanQRCode(BuildContext context) async {
      String scannedCode = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text('Сканирование QR-кода'),
            ),
            body: QRView(
              key: GlobalKey(debugLabel: 'QR'),
              onQRViewCreated: (QRViewController controller) {
                controller.scannedDataStream.listen((scanData) {
                  controller.pauseCamera();
                  Navigator.pop(context, scanData.code);
                });
              },
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
          ),
        ),
      );

      // ignore: unnecessary_null_comparison
      if (scannedCode != null) {
        walletAddressController.text = scannedCode;
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Введите адрес кошелька или отсканируйте QR-код',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: context.colors.textsAction,
            ),
          ),
          const Gap(25),
          Form(
            key: formKey,
            child: TextFormField(
              controller: walletAddressController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите адрес кошелька';
                }
                if (value.length != 24) {
                  return 'Адрес кошелька должен содержать ровно 24 символов (буквы и цифры)';
                }
                if (!RegExp(r'^[a-zA-Z0-9]{24}$').hasMatch(value)) {
                  return 'Введите корректный адрес кошелька TON';
                }

                // Регулярное выражение для адреса TON

                return null;
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Z0-9]')), // Разрешаем только буквы и цифры
                LengthLimitingTextInputFormatter(24),
              ],
              decoration: InputDecoration(
                labelText: 'Адрес кошелька',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: () {
                    scanQRCode(context);
                  },
                ),
              ),
            ),
          ),
          const Gap(30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppTextButton(
                onTap: () {
                  Navigator.pop(context);
                },
                text: context.txt.cancel,
              ),
              const Gap(35),
              AppTextButton(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    Logger.i('Wallets: ${walletAddressController.text}');
                    Navigator.pop(context, walletAddressController.text);
                  }
                },
                text: context.txt.add,
              ),
            ],
          ),
          Gap(35 + MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
