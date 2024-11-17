import 'package:tonutils/tonutils.dart';
import 'package:flutter_easylogger/flutter_logger.dart';

class TonAddressConverter {
  /// Конвертирует адрес из пользовательского формата (friendly) в raw формат
  static String friendlyToRaw(String friendlyAddress) {
    try {
      final address = InternalAddress.parse(friendlyAddress);
      return address.toRawString();
    } catch (e) {
      Logger.e('Ошибка при конвертации friendly адреса в raw: $e');
      return friendlyAddress;
    }
  }

  /// Конвертирует адрес из raw формата в пользовательский формат (friendly)
  static String rawToFriendly(String rawAddress) {
    try {
      final address = InternalAddress.parseRaw(rawAddress);
      return address.toString(isBounceable: true, isTestOnly: false);
    } catch (e) {
      Logger.e('Ошибка при конвертации raw адреса в friendly: $e');
      return rawAddress;
    }
  }

  /// Проверяет валидность TON адреса
  static bool isValidAddress(String address) {
    try {
      InternalAddress.parse(address);
      return true;
    } catch (e) {
      return false;
    }
  }
}
