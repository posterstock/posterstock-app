import 'dart:async';

import 'package:darttonconnect/parsers/connect_event.dart';
import 'package:darttonconnect/provider/bridge_provider.dart';
import 'package:darttonconnect/ton_connect.dart';
import 'package:darttonconnect/models/wallet_app.dart';
import 'package:poster_stock/common/constants/nft_adress.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tonutils/tonutils.dart';

class TonWalletService {
  static final TonWalletService _instance = TonWalletService._internal();
  factory TonWalletService() => _instance;
  final _connectionStreamController = StreamController<String>.broadcast();
  Stream<String> get connectionStream => _connectionStreamController.stream;
  String get addressWallet => _connector.account?.address ?? '';

  late TonConnect _connector;
  bool get isConnected => _connector.connected;
  double get getBalance => balance;
  double balance = 0;
  final _transactionStreamController =
      StreamController<TransactionStatus>.broadcast();
  Stream<TransactionStatus> get transactionStream =>
      _transactionStreamController.stream;

  // Конфигурация Tonkeeper
  static const Map<String, dynamic> tonkeeperConfig = {
    "app_name": "tonkeeper",
    "name": "Tonkeeper",
    "image": "https://tonkeeper.com/assets/tonconnect-icon.png",
    "about_url": "https://tonkeeper.com",
    "universal_url": "https://app.tonkeeper.com/ton-connect",
    "bridge": [
      {"type": "sse", "url": "https://bridge.tonapi.io/bridge"},
    ],
  };

  TonWalletService._internal() {
    _connector = TonConnect(
      'https://posterstock.com/tonconnect_ps.json',
      // Добавляем параметры для тестовой сети
    );
    _setupTransactionListener();
  }

  void _setupTransactionListener() {
    final provider = _connector.provider;
    if (provider is BridgeProvider) {
      provider.listen((message) {
        Logger.i('Transaction event received: $message');

        if (message.containsKey('error')) {
          final error = message['error'];
          Logger.e('Transaction error: ${error['message']}');
          _transactionStreamController.add(TransactionStatus.failed);
          return;
        }

        if (message.containsKey('event')) {
          switch (message['event']) {
            case 'transaction':
              Logger.i('Transaction successful');
              _transactionStreamController.add(TransactionStatus.success);
              break;
            case 'transaction_error':
              final payload = message['payload'];
              Logger.e('Transaction error: ${payload?['message']}');
              _transactionStreamController.add(TransactionStatus.failed);
              break;
            default:
              Logger.i('Other event: ${message['event']}');
          }
        }
      });
    }
  }

  WalletApp get tonkeeperWallet => WalletApp(
        aboutUrl: tonkeeperConfig['about_url'],
        bridgeUrl: tonkeeperConfig['bridge'][0]['url'],
        image: tonkeeperConfig['image'],
        name: tonkeeperConfig['name'],
        universalUrl: tonkeeperConfig['universal_url'],
      );

  Future<void> init() async {
    try {
      // Если есть активное подключение, сначала отключаемся
      if (isConnected) {
        await disconnect();
      }

      // Если есть активный провайдер, закрываем соединение
      final provider = _connector.provider;
      if (provider is BridgeProvider) {
        provider.closeConnection();
      }

      // Пересоздаем connector
      _connector = TonConnect(
        'https://posterstock.com/tonconnect_ps.json',
      );

      Logger.i('TonWalletService успешно реинициализирован');
    } catch (e, stackTrace) {
      Logger.e('Ошибка при реинициализации TonWalletService: $e');
      Logger.e('Стек ошибки: $stackTrace');
      // Пересоздаем connector даже в случае ошибки
      _connector = TonConnect(
        'https://posterstock.com/tonconnect_ps.json',
      );
    }
  }

  Future<bool> restoreConnection() async {
    try {
      final restored = await _connector.restoreConnection();
      if (_connector.connected && _connector.account != null) {
        Logger.i('Адрес кошелька: ${_connector.account?.address}');
        await Future.delayed(const Duration(seconds: 2));
        // Получаем баланс
        balance = await getWalletBalance();
        Logger.i('Баланс кошелька: $balance TON');
      }

      return restored;
    } catch (e, stackTrace) {
      Logger.e('Ошибка восстановления подключения: $e');
      Logger.e('Стек ошибки: $stackTrace');
      return false;
    }
  }

  /// Получение адреса подключенного кошелька
  String getWalletAddress() {
    try {
      if (!isConnected || _connector.account == null) {
        return '';
      }

      final address = _connector.account?.address;
      if (address == null) {
        Logger.e('Не удалось получить адрес кошелька');
        return '';
      }

      Logger.i('Получен адрес кошелька: $address');
      return address;
    } catch (e, stackTrace) {
      Logger.e('Ошибка получения адреса кошелька: $e');
      Logger.e('Стек ошибки: $stackTrace');
      return '';
    }
  }

  Future<bool> connect() async {
    try {
      if (isConnected) {
        _connectionStreamController.add(getWalletAddress());
        return true;
      }

      final universalLink = await _connector.connect(tonkeeperWallet);
      Logger.i('Universal Link: $universalLink');

      final Uri uri = Uri.parse(universalLink);
      if (await canLaunchUrl(uri)) {
        bool launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (!launched) {
          Logger.e('Не удалось запустить $universalLink');
          _connectionStreamController.add('');
          return false;
        }
        // Добавляем слушатель событий перед подключением
        final provider = _connector.provider;
        if (provider is BridgeProvider) {
          provider.listen((message) {
            if (message['event'] == 'connect') {
              // Успешное подключение
              final address = _connector.account?.address ?? '';
              _connectionStreamController.add(address);
              return true;
            } else if (message['event'] == 'connect_error') {
              // Ошибка подключения
              final errorMessage = message['payload']['message'] as String?;
              Logger.e('Ошибка подключения: $errorMessage');
              _connectionStreamController.add('');
              return false;
            }
          });
        }
        return true;
      } else {
        Logger.e('Не удалось запустить $universalLink');
        _connectionStreamController.add('');
        return false;
      }
    } catch (e) {
      Logger.e('Ошибка подключения к кошельку: $e');
      _connectionStreamController.add('');
      return false;
    }
  }

  void dispose() {
    _connectionStreamController.close();
  }

  Future<void> disconnect() async {
    if (isConnected) {
      await _connector.disconnect();
    }
  }

  /// Отправка транзакции на NFT
  Future<bool> sendNftTransaction({
    required String contractAddress,
    required double amount,
    required String nftAddress,
  }) async {
    try {
      if (!isConnected) {
        _transactionStreamController.add(TransactionStatus.failed);
        Logger.e('Кошелек не подключен');
        return false;
      }

      final amountInNano = (amount * 1e9).toInt().toString();
      final tonkeeperUrl =
          'https://app.tonkeeper.com/transfer/$contractAddress?amount=$amountInNano';

      _transactionStreamController.add(TransactionStatus.pending);

      final uri = Uri.parse(tonkeeperUrl);
      if (await canLaunchUrl(uri)) {
        bool launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );

        if (!launched) {
          _transactionStreamController.add(TransactionStatus.failed);
          return false;
        }

        // Добавляем слушатель событий для транзакции
        final provider = _connector.provider;
        if (provider is BridgeProvider) {
          provider.listen((message) {
            if (message['event'] == 'transaction') {
              try {
                _transactionStreamController.add(TransactionStatus.success);
              } catch (e) {
                Logger.e('Ошибка при вызове nftSell: $e');
                _transactionStreamController.add(TransactionStatus.failed);
              }
            } else if (message['event'] == 'transaction_error') {
              final errorMessage = message['payload']['message'] as String?;
              Logger.e('Ошибка транзакции: $errorMessage');
              _transactionStreamController.add(TransactionStatus.failed);
            }
          });
        }
        return true;
      }

      _transactionStreamController.add(TransactionStatus.failed);
      return false;
    } catch (e) {
      _transactionStreamController.add(TransactionStatus.failed);
      Logger.e('Ошибка при отправке NFT транзакции: $e');
      return false;
    }
  }

  Future<double> getWalletBalance() async {
    try {
      if (!_connector.connected || _connector.account == null) {
        Logger.e('Кошелек не подключен или аккаунт отсутствует');
        return 0;
      }

      String? address = _connector.account?.address;

      if (address == null) {
        Logger.e('Не удалось получить адрес кошелька');
        return 0;
      }

      // Определяем сеть из коннектора
      final isTestnet = _connector.wallet?.account?.chain == CHAIN.testnet;
      final baseUrl = isTestnet
          ? 'https://testnet.toncenter.com/api/v2'
          : 'https://toncenter.com/api/v2';

      final url = '$baseUrl/getAddressBalance?address=$address';
      Logger.i('Сеть: ${isTestnet ? 'testnet' : 'mainnet'}');

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['ok'] && data['result'] != null) {
          final balance = BigInt.parse(data['result'].toString());
          final balanceInTon = balance.toDouble() / 1e9;
          Logger.i('Вычисленный баланс: $balanceInTon TON');
          return balanceInTon;
        }
      }

      Logger.e('Неуспешный статус ответа: ${response.statusCode}');
      return 0;
    } catch (e, stackTrace) {
      Logger.e('Ошибка получения баланса: $e');
      Logger.e('Стек ошибки: $stackTrace');
      return 0;
    }
  }

  /// Создание транзакции для снятия с продажи NFT
  Future<bool> createNFTUnSale({
    required String nftAddressContract,
  }) async {
    String lastEventId = '0';
    try {
      final temp = await _connector.storage.getItem(key: 'last_event_id');
      Logger.i('temp: $temp');
      lastEventId = temp ?? '0';
    } catch (e) {
      Logger.e('Ошибка в getItem: $e');
    }
    try {
      // Создаем тело транзакции для снятия с продажи
      final unsaleBody = beginCell()
          .storeUint(BigInt.from(3), 32)
          .storeUint(BigInt.zero, 64)
          .endCell();

      final transaction = {
        'validUntil': DateTime.now().millisecondsSinceEpoch + 300000,
        'network': -3,
        'id': lastEventId,
        'messages': [
          {
            'address': nftAddressContract,
            'amount': '100000000', // 0.1 TON для газа
            'payload': base64Encode(unsaleBody.toBoc()),
          }
        ]
      };

      final result = await _connector.sendTransaction(transaction);
      Logger.i('Transaction result: $result');
      await Future.delayed(const Duration(seconds: 2));
      final uri = Uri.parse(tonkeeperUrl);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      }
      return true;
    } catch (e) {
      Logger.e('Ошибка в createNFTUnSale: $e');
      return false;
    }
  }

  /// Создание транзакции для продажи NFT
  Future<bool> createNFTSale({
    required String nftAddress,
    required String ownerAddress,
    required String creatorAddress,
    required BigInt price,
    required BigInt amount,
    required double percentMarketplace,
    required double percentRoyalty,
    required String destination,
  }) async {
    const tonkeeperUrl = 'https://app.tonkeeper.com/';

    String lastEventId = '0';
    try {
      final temp = await _connector.storage.getItem(key: 'last_event_id');
      Logger.i('temp: $temp');
      lastEventId = temp ?? '0';
    } catch (e) {
      Logger.e('Ошибка в getItem: $e');
    }
    try {
      const kNftFixPriceSaleV3R3CodeBoc =
          'te6ccgECDwEAA5MAART/APSkE/S88sgLAQIBYgIDAgLNBAUCASANDgL30A6GmBgLjYSS+CcH0gGHaiaGmAaY/9IH0gfSB9AGppj+mfmBg4KYVjgGAASpiFaY+F7xDhgEoYBWmfxwjFsxsLcxsrZBZjgsk5mW8oBfEV4ADJL4dwEuuk4QEWQIEV3RXgAJFZ2Ngp5OOC2HGBFWAA+WjKFkEINjYQQF1AYHAdFmCEAX14QBSYKBSML7y4cIk0PpA+gD6QPoAMFOSoSGhUIehFqBSkCH6RFtwgBDIywVQA88WAfoCy2rJcfsAJcIAJddJwgKwjhtQRSH6RFtwgBDIywVQA88WAfoCy2rJcfsAECOSNDTiWoMAGQwMWyy1DDQ0wchgCCw8tGVIsMAjhSBAlj4I1NBobwE+CMCoLkTsPLRlpEy4gHUMAH7AATwU8fHBbCOXRNfAzI3Nzc3BPoA+gD6ADBTIaEhocEB8tGYBdD6QPoA+kD6ADAwyDICzxZY+gIBzxZQBPoCyXAgEEgQNxBFEDQIyMsAF8sfUAXPFlADzxYBzxYB+gLMyx/LP8ntVOCz4wIwMTcowAPjAijAAOMCCMACCAkKCwCGNTs7U3THBZJfC+BRc8cF8uH0ghAFE42RGLry4fX6QDAQSBA3VTIIyMsAF8sfUAXPFlADzxYBzxYB+gLMyx/LP8ntVADiODmCEAX14QAYvvLhyVNGxwVRUscFFbHy4cpwIIIQX8w9FCGAEMjLBSjPFiH6Astqyx8Vyz8nzxYnzxYUygAj+gITygDJgwb7AHFwVBcAXjMQNBAjCMjLABfLH1AFzxZQA88WAc8WAfoCzMsfyz/J7VQAGDY3EDhHZRRDMHDwBQAgmFVEECQQI/AF4F8KhA/y8ADsIfpEW3CAEMjLBVADzxYB+gLLaslx+wBwIIIQX8w9FMjLH1Iwyz8kzxZQBM8WE8oAggnJw4D6AhLKAMlxgBjIywUnzxZw+gLLaswl+kRbyYMG+wBxVWD4IwEIyMsAF8sfUAXPFlADzxYBzxYB+gLMyx/LP8ntVACHvOFnaiaGmAaY/9IH0gfSB9AGppj+mfmC3ofSB9AH0gfQAYKaFQkNDggPlozJP9Ii2TfSItkf0iLcEIIySsKAVgAKrAQAgb7l72omhpgGmP/SB9IH0gfQBqaY/pn5gBaH0gfQB9IH0AGCmxUJDQ4ID5aM0U/SItlH0iLZH9Ii2F4ACFiBqqiU';
      final kNftFixPriceSaleV3R3CodeCell =
          Cell.fromBoc(base64Decode(kNftFixPriceSaleV3R3CodeBoc))[0];

      final Address royaltyAddress = InternalAddress.parse(
          '0QCA_mh61MASkQMJUYgq11SQB1YkxAPIdPwgfbrPsCqOJLYF');

      final feesData = beginCell()
          .storeAddress(royaltyAddress)
          .storeCoins(price ~/ BigInt.from(100) * BigInt.from(5))
          .storeAddress(InternalAddress.parse(creatorAddress))
          .storeCoins(price ~/ BigInt.from(100) * BigInt.from(5))
          .endCell();
      final saleData = beginCell()
          .storeBit(0)
          .storeUint(
              BigInt.from(DateTime.now().millisecondsSinceEpoch ~/ 1000), 32)
          .storeAddress(InternalAddress.parse(destination))
          .storeAddress(InternalAddress.parse(nftAddress))
          .storeAddress(InternalAddress.parse(_connector.account?.address))
          .storeCoins(price)
          .storeRef(feesData)
          .storeUint(BigInt.from(0), 32)
          .storeUint(BigInt.from(0), 64)
          .endCell();

      final stateInit = StateInit(
          null,
          null,
          kNftFixPriceSaleV3R3CodeCell, // code
          saleData, // data
          null);

      final stateInitCell =
          beginCell().store(storeStateInit(stateInit)).endCell();

      // Создаем saleBody
      final saleBody = beginCell()
          .storeUint(price, 64) // Цена продажи
          .storeAddress(royaltyAddress)
          .storeUint(BigInt.from(percentRoyalty * 100), 16)
          .storeUint(BigInt.from(percentMarketplace * 100), 16)
          .endCell();

      final transferNftBody = beginCell()
          .storeUint(BigInt.parse('0x5fcc3d14'), 32)
          .storeUint(BigInt.zero, 64)
          .storeAddress(InternalAddress.parse(destinationAddress))
          .storeAddress(InternalAddress.parse(_connector.account?.address))
          .storeBit(0)
          .storeCoins(BigInt.parse('200000000'))
          .storeBit(0)
          .storeUint(BigInt.parse('0x0fe0ede'), 31)
          .storeRef(stateInitCell)
          .storeRef(saleBody)
          .endCell();

      final transaction = {
        'validUntil': DateTime.now().millisecondsSinceEpoch + 300000,
        'network': -3,
        'id': lastEventId,
        'messages': [
          {
            'address': nftAddress,
            'amount': '300000000', // 0.3 TON для газа
            'payload': base64Encode(transferNftBody.toBoc()),
          }
        ]
      };

      final result = await _connector.sendTransaction(transaction);
      Logger.i('Transaction result: $result');
      await Future.delayed(const Duration(seconds: 2));
      final uri = Uri.parse(tonkeeperUrl);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      }
      return true;
    } catch (e) {
      Logger.e('Error in createNFTSale: $e');
      _transactionStreamController.add(TransactionStatus.failed);
      return false;
    }
  }
}

// Добавьте enum для статусов транзакции
enum TransactionStatus { success, failed, pending, cancelled }
