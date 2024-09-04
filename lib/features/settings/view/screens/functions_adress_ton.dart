import 'dart:convert';
import 'dart:typed_data';
import 'package:tonutils/tonutils.dart';

/// класс для работы с адресами
class Address {
  static const int bounceableTag = 0x11;
  static const int nonBounceableTag = 0x51;
  static const int testFlag = 0x80;
}

/// класс для создания адреса TON
class InternalAddress extends Address {
  final Uint8List hash;
  final BigInt workChain;

  InternalAddress(this.workChain, this.hash);

  @override
  String toString(
      {bool isUrlSafe = true,
      bool isBounceable = false,
      bool isTestOnly = false}) {
    var tag = isBounceable ? Address.bounceableTag : Address.nonBounceableTag;
    if (isTestOnly) {
      tag |= Address.testFlag;
    }

    final addr = Uint8List(34);
    addr[0] = tag;
    addr[1] = workChain.toInt();
    addr.setAll(2, hash);

    final addrWithChecksum = Uint8List(36);
    addrWithChecksum.setAll(0, addr);
    addrWithChecksum.setAll(34, Crc16.ofUint8List(addr));

    if (isUrlSafe) {
      return base64Url.encode(addrWithChecksum).replaceAll('=', '');
    } else {
      return base64.encode(addrWithChecksum);
    }
  }
}

/// функция для создания адреса TON из строки имени кошелька
String getAddressTon(String hexString) {
  BigInt workChainId = BigInt.zero;
  if (hexString.startsWith("0:")) {
    workChainId = BigInt.parse(hexString.substring(0, hexString.indexOf(':')));
    hexString = hexString.substring(hexString.indexOf(':') + 1);
  }
  Uint8List hash = Uint8List.fromList(List.generate(hexString.length ~/ 2,
      (i) => int.parse(hexString.substring(i * 2, i * 2 + 2), radix: 16)));
  InternalAddress address = InternalAddress(workChainId, hash);
  return address.toString();
}
