import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_stock/common/state_holders/intl_state_holder.dart';
import 'package:poster_stock/features/edit_profile/view/state_holders/edit_profile_name_error.dart';
import 'package:poster_stock/features/edit_profile/view/state_holders/edit_profile_username_state_holder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final editProfileControllerProvider = Provider<EditProfileController>(
  (ref) => EditProfileController(
    editProfileUsernameStateHolder:
        ref.watch(editProfileUsernameStateHolder.notifier),
    editProfileNameStateHolder: ref.watch(editProfileNameStateHolder.notifier),
    localizations: ref.watch(localizations),
  ),
);

class EditProfileController {
  final EditProfileUsernameStateHolder editProfileUsernameStateHolder;
  final EditProfileNameStateHolder editProfileNameStateHolder;
  final AppLocalizations? localizations;

  EditProfileController({
    required this.editProfileUsernameStateHolder,
    required this.editProfileNameStateHolder,
    required this.localizations,
  });

  void setWrongSymbolsErrorUsername() {
    editProfileUsernameStateHolder.updateError(localizations!.invalidSymbols);
  }

  void removeUsernameError() {
    editProfileUsernameStateHolder.clearError();
  }

  void setTooLongErrorUsername() {
    editProfileUsernameStateHolder
        .updateError(localizations!.usernameCantExceed32);
  }

  void setTooShortErrorUsername() {
    editProfileUsernameStateHolder
        .updateError(localizations!.usernameMinLength5);
  }

  void setTooLongErrorName() {
    editProfileNameStateHolder
        .updateError(localizations!.nameCantExceed32);
  }
}
