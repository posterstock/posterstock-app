import 'dart:typed_data';

import 'package:poster_stock/features/edit_profile/api/edit_profile_api.dart';

class EditProfileRepository {
  final service = EditProfileApi();

  Future<void> save({
    required String name,
    required String username,
    String? description,
    Uint8List? avatar,
  }) async {
    await service.save(
      name: name,
      username: username,
      description: description,
      avatar: avatar,
    );
  }
}
