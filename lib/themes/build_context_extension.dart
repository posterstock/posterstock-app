import 'package:flutter/material.dart';
import 'package:poster_stock/themes/app_text_styles.dart';

import 'app_colors.dart';

extension ThemePicker on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
  AppTextStyles get textStyles => Theme.of(this).extension<AppTextStyles>()!;
}
