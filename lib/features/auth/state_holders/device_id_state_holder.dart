import 'package:flutter_riverpod/flutter_riverpod.dart';

final deviceIdStateHolderProvider =
StateNotifierProvider<DeviceIdStateHolder, String>(
      (ref) => DeviceIdStateHolder(''),
);

class DeviceIdStateHolder extends StateNotifier<String> {
  DeviceIdStateHolder(String code) : super(code);

  void updateState(String code) {
    state = code;
  }

  void clearState() {
    state = '';
  }
}
