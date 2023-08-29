import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/common/state_holders/intl_state_holder.dart';
import 'package:poster_stock/features/edit_profile/repository/edit_profile_repository.dart';
import 'package:poster_stock/features/edit_profile/state_holder/avatar_state_holder.dart';
import 'package:poster_stock/features/edit_profile/state_holder/edit_profile_description_error_state_holder.dart';
import 'package:poster_stock/features/edit_profile/state_holder/edit_profile_description_state_holder.dart';
import 'package:poster_stock/features/edit_profile/state_holder/edit_profile_name_error.dart';
import 'package:poster_stock/features/edit_profile/state_holder/edit_profile_name_state_holder.dart';
import 'package:poster_stock/features/edit_profile/state_holder/edit_profile_username_error_state_holder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:poster_stock/features/edit_profile/state_holder/edit_profile_username_state_holder.dart';

final editProfileControllerProvider = Provider<EditProfileController>(
  (ref) => EditProfileController(
    editProfileUsernameErrorStateHolder:
        ref.watch(editProfileUsernameErrorStateHolder.notifier),
    editProfileNameErrorStateHolder:
        ref.watch(editProfileNameErrorStateHolder.notifier),
    editProfileDescriptionErrorSH:
        ref.watch(editProfileDescriptionErrorStateHolder.notifier),
    localizations: ref.watch(localizations),
    editProfileDescriptionSH: ref.watch(editProfileDescriptionStateHolder),
    editProfileNameStateHolder: ref.watch(editProfileNameStateHolder),
    editProfileUsernameStateHolder: ref.watch(editProfileUsernameStateHolder),
    editProfileAvatarStateHolder: ref.watch(avatarStateHolderProvider),
    avatarStateHolder: ref.watch(avatarStateHolderProvider.notifier),
  ),
);

class EditProfileController {
  final EditProfileUsernameErrorStateHolder editProfileUsernameErrorStateHolder;
  final EditProfileNameErrorStateHolder editProfileNameErrorStateHolder;
  final EditProfileDescriptionErrorStateHolder editProfileDescriptionErrorSH;
  final AvatarStateHolder avatarStateHolder;
  final String? editProfileUsernameStateHolder;
  final String? editProfileNameStateHolder;
  final String? editProfileDescriptionSH;
  final Uint8List? editProfileAvatarStateHolder;
  final AppLocalizations? localizations;
  final repository = EditProfileRepository();

  EditProfileController({
    required this.editProfileUsernameErrorStateHolder,
    required this.editProfileNameErrorStateHolder,
    required this.editProfileDescriptionErrorSH,
    required this.editProfileNameStateHolder,
    required this.editProfileUsernameStateHolder,
    required this.editProfileDescriptionSH,
    required this.editProfileAvatarStateHolder,
    required this.avatarStateHolder,
    required this.localizations,
  });

  void setWrongSymbolsErrorUsername() {
    editProfileUsernameErrorStateHolder
        .updateError(localizations!.invalidSymbols);
  }

  void removeUsernameError() {
    editProfileUsernameErrorStateHolder.clearError();
  }

  void setTooLongErrorUsername() {
    editProfileUsernameErrorStateHolder
        .updateError(localizations!.usernameCantExceed32);
  }

  void setTooShortErrorUsername() {
    editProfileUsernameErrorStateHolder
        .updateError(localizations!.usernameMinLength5);
  }

  void setTooLongErrorName() {
    editProfileNameErrorStateHolder
        .updateError(localizations!.nameCantExceed32);
  }

  void removeNameError() {
    editProfileNameErrorStateHolder.clearError();
  }

  void removeDescriptionError() {
    editProfileDescriptionErrorSH.updateError(false);
  }

  void clearAll() {
    removeUsernameError();
    removeNameError();
    removeDescriptionError();
    avatarStateHolder.removePhoto();
  }

  Future<void> save() async {
    await repository.save(
      name: editProfileNameStateHolder!,
      username: editProfileUsernameStateHolder!,
      description: editProfileDescriptionSH!,
      avatar: editProfileAvatarStateHolder,
    );
  }
}
