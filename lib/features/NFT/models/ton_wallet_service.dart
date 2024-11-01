import 'package:darttonconnect/parsers/connect_event.dart';
import 'package:darttonconnect/provider/bridge_provider.dart';
import 'package:darttonconnect/ton_connect.dart';
import 'package:darttonconnect/models/wallet_app.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TonWalletService {
  static final TonWalletService _instance = TonWalletService._internal();
  factory TonWalletService() => _instance;

  late TonConnect _connector;
  bool get isConnected => _connector.connected;

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
        final balance = await getWalletBalance();
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
        Logger.e(
            'TonWalletService: Кошелек не подключен или аккаунт отсутствует');
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
        return true;
      }

      final universalLink = await _connector.connect(tonkeeperWallet);
      Logger.i('Universal Link: $universalLink');

      final Uri uri = Uri.parse(universalLink);
      if (await canLaunchUrl(uri)) {
        bool launched = await launchUrl(uri);
        if (!launched) {
          Logger.e('Не удалось запустить $universalLink');
          return false;
        }
        return true;
      } else {
        Logger.e('Не удалось запустить $universalLink');
        return false;
      }
    } catch (e) {
      Logger.e('Ошибка подключения к кошельку: $e');
      return false;
    }
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
  }) async {
    try {
      if (!isConnected) {
        Logger.e('Кошелек не подключен');
        return false;
      }

      final provider = _connector.provider;
      if (provider is BridgeProvider) {
        // Сначала закроем текущее подключение
        provider.closeConnection();

        // Затем восстановим его заново
        await provider.restoreConnection();
      }
      // Конвертируем сумму в наноТоны и преобразуем в целое число
      final amountInNano = (amount * 1e9).toInt().toString();

      // Получаем текущее время в секундах и добавляем час для validUntil
      final int validUntil =
          (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 3600;
      final networkId =
          _connector.account?.chain == CHAIN.testnet ? '-3' : '-239';

      final Map<String, dynamic> transaction = {
        'validUntil': validUntil,
        'network': CHAIN.mainnet.value,
        'messages': [
          {
            'type': 'transfer',
            'address': contractAddress,
            'amount': amountInNano,
          }
        ]
      };

      Logger.i('Подготовленная транзакция: $transaction');

      final result = await _connector.sendTransaction(transaction);
      Logger.i('Результат NFT транзакции: $result');

      if (result == null || result['boc'] == null) {
        Logger.e('Ошибка: пустой результат транзакции');
        return false;
      }
      return true;
    } catch (e, stackTrace) {
      Logger.e('Ошибка при отправке NFT транзакции: $e');
      Logger.e('Стек ошибки: $stackTrace');
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
