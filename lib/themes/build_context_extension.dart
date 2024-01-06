import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:poster_stock/themes/app_text_styles.dart';

import 'app_colors.dart';

extension ThemePicker on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;

  AppTextStyles get textStyles => Theme.of(this).extension<AppTextStyles>()!;

  //TODO: replace by whole app code AppLocalizations.of(context)!
  AppLocalizations get txt => AppLocalizations.of(this)!;
}
