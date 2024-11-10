import 'dart:async';

import 'package:darttonconnect/parsers/connect_event.dart';
import 'package:darttonconnect/provider/bridge_provider.dart';
import 'package:darttonconnect/ton_connect.dart';
import 'package:darttonconnect/models/wallet_app.dart';
import 'package:poster_stock/features/poster/data/post_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TonWalletService {
  static final TonWalletService _instance = TonWalletService._internal();
  factory TonWalletService() => _instance;
  final _connectionStreamController = StreamController<String>.broadcast();
  Stream<String> get connectionStream => _connectionStreamController.stream;

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
            Logger.i('message >>>>>>>>> $message');
            if (message['event'] == 'connect') {
              // Успешное подключение
              final address = _connector.account?.address ?? '';
              _connectionStreamController.add(address);
            } else if (message['event'] == 'connect_error') {
              // Ошибка подключения
              final errorMessage = message['payload']['message'] as String?;
              Logger.e('Ошибка подключения: $errorMessage');
              _connectionStreamController.add('');
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
            Logger.i('Transaction message >>>>>>>>> $message');
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
}

// Добавьте enum для статусов транзакции
enum TransactionStatus { success, failed, pending }
