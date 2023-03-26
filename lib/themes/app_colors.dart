import 'package:flutter/material.dart';

class AppLightColors extends AppColors {
  const AppLightColors()
      : super(
          textsPrimary: const Color(0xFF212121),
          textsSecondary: const Color(0xFF858585),
          textsBackground: const Color(0xFFFAFAFA),
          textsDisabled: const Color(0xFFBDBDBD),
          textsAction: const Color(0xFF3390EC),
          textsError: const Color(0xFFF24822),
          iconsDefault: const Color(0xFF333333),
          iconsHover: const Color(0xFF212121),
          iconsActive: const Color(0xFF3390EC),
          iconsDisabled: const Color(0xFFBDBDBD),
          iconsBackground: const Color(0xFFFFFFFF),
          iconsFAB: const Color(0xFFFFFFFF),
          iconsLayer: const Color(0xFF9E9E9E),
          iconsAccent: const Color(0xFFFFA000),
          buttonsPrimary: const Color(0xFF3390EC),
          buttonsSecondary: const Color(0xFF212121),
          buttonsDisabled: const Color.fromRGBO(51, 144, 236, 0.04),
          buttonsError: const Color(0xFFF24822),
          buttonsHyperlink: const Color(0xFFE8F6FF),
          buttonsToolbarHover: const Color(0xFFF5F5F5),
          buttonsToolbarActive: const Color(0xFFFFFFFF),
          buttonsSizdebarActive: const Color(0xFF3390EC),
          backgroundsPrimary: const Color(0xFFFFFFFF),
          backgroundsSecondary: const Color(0xFFF9F9F9),
          backgroundsAction: const Color(0xFFFAFAFA),
          backgroundsDropdown: const Color(0xFF212121),
          backgroundsDropAction: const Color(0xFF3390EC),
          backgroundsDropDivider: const Color(0xFF424242),
          fieldsDefault: const Color(0xFFF2F2F2),
          fieldsHover: const Color(0xFFE0E0E0),
          fieldsActive: const Color(0xFF3390EC),
          slidersPrimary: const Color(0xFF3390EC),
          slidersSecondary: const Color(0xFF424242),
          slidersTrack: const Color(0xFFE0E0E0),
        );
}

class AppDarkColors extends AppColors {
  const AppDarkColors()
      : super(
    textsPrimary: const Color(0xFFFAFAFA),
    textsSecondary: const Color(0xFF757575),
    textsBackground: const Color(0xFFFAFAFA),
    textsDisabled: const Color(0xFF5C5C5C),
    textsAction: const Color(0xFFFAFAFA),
    textsError: const Color(0xFFF24822),
    iconsDefault: const Color(0xFFE4E4E4),
    iconsHover: const Color(0xFFF5F5F5),
    iconsActive: const Color(0xFFFFFFFF),
    iconsDisabled: const Color(0xFF616161),
    iconsBackground: const Color(0xFFFFFFFF),
    iconsFAB: const Color(0xFF212121),
    iconsLayer: const Color(0xFF9E9E9E),
    iconsAccent: const Color(0xFFFFA000),
    buttonsPrimary: const Color(0xFF3390EC),
    buttonsSecondary: const Color(0xFFCCCCCC),
    buttonsDisabled: const Color.fromRGBO(255, 255, 255, 0.04),
    buttonsError: const Color(0xFFF24822),
    buttonsHyperlink: const Color(0xFF424242),
    buttonsToolbarHover: const Color(0xFF424242),
    buttonsToolbarActive: const Color(0xFF212121),
    buttonsSizdebarActive: const Color(0xFF3390EC),
    backgroundsPrimary: const Color(0xFF212121),
    backgroundsSecondary: const Color(0xFF131415),
    backgroundsAction: const Color(0xFF131415),
    backgroundsDropdown: const Color(0xFF292929),
    backgroundsDropAction: const Color(0xFF3390EC),
    backgroundsDropDivider: const Color(0xFF424242),
    fieldsDefault: const Color(0xFF2E2E2E),
    fieldsHover: const Color(0xFF616161),
    fieldsActive: const Color(0xFFFFFFFF),
    slidersPrimary: const Color(0xFF3390EC),
    slidersSecondary: const Color(0xFF424242),
    slidersTrack: const Color(0xFFE0E0E0),
  );
}

class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.textsPrimary,
    required this.textsSecondary,
    required this.textsBackground,
    required this.textsDisabled,
    required this.textsAction,
    required this.textsError,
    required this.iconsDefault,
    required this.iconsHover,
    required this.iconsActive,
    required this.iconsDisabled,
    required this.iconsBackground,
    required this.iconsFAB,
    required this.iconsLayer,
    required this.iconsAccent,
    required this.buttonsPrimary,
    required this.buttonsSecondary,
    required this.buttonsDisabled,
    required this.buttonsError,
    required this.buttonsHyperlink,
    required this.buttonsToolbarHover,
    required this.buttonsToolbarActive,
    required this.buttonsSizdebarActive,
    required this.backgroundsPrimary,
    required this.backgroundsSecondary,
    required this.backgroundsAction,
    required this.backgroundsDropdown,
    required this.backgroundsDropAction,
    required this.backgroundsDropDivider,
    required this.fieldsDefault,
    required this.fieldsHover,
    required this.fieldsActive,
    required this.slidersPrimary,
    required this.slidersSecondary,
    required this.slidersTrack,
  });

  final Color? textsPrimary;
  final Color? textsSecondary;
  final Color? textsBackground;
  final Color? textsDisabled;
  final Color? textsAction;
  final Color? textsError;
  final Color? iconsDefault;
  final Color? iconsHover;
  final Color? iconsActive;
  final Color? iconsDisabled;
  final Color? iconsBackground;
  final Color? iconsFAB;
  final Color? iconsLayer;
  final Color? iconsAccent;
  final Color? buttonsPrimary;
  final Color? buttonsSecondary;
  final Color? buttonsDisabled;
  final Color? buttonsError;
  final Color? buttonsHyperlink;
  final Color? buttonsToolbarHover;
  final Color? buttonsToolbarActive;
  final Color? buttonsSizdebarActive;
  final Color? backgroundsPrimary;
  final Color? backgroundsSecondary;
  final Color? backgroundsAction;
  final Color? backgroundsDropdown;
  final Color? backgroundsDropAction;
  final Color? backgroundsDropDivider;
  final Color? fieldsDefault;
  final Color? fieldsHover;
  final Color? fieldsActive;
  final Color? slidersPrimary;
  final Color? slidersSecondary;
  final Color? slidersTrack;

  @override
  ThemeExtension<AppColors> copyWith({
    final Color? textsPrimary,
    final Color? textsSecondary,
    final Color? textsBackground,
    final Color? textsDisabled,
    final Color? textsAction,
    final Color? textsError,
    final Color? iconsDefault,
    final Color? iconsHover,
    final Color? iconsActive,
    final Color? iconsDisabled,
    final Color? iconsBackground,
    final Color? iconsFAB,
    final Color? iconsLayer,
    final Color? iconsAccent,
    final Color? buttonsPrimary,
    final Color? buttonsSecondary,
    final Color? buttonsDisabled,
    final Color? buttonsError,
    final Color? buttonsHyperlink,
    final Color? buttonsToolbarHover,
    final Color? buttonsToolbarActive,
    final Color? buttonsSizdebarActive,
    final Color? backgroundsPrimary,
    final Color? backgroundsSecondary,
    final Color? backgroundsAction,
    final Color? backgroundsDropdown,
    final Color? backgroundsDropAction,
    final Color? backgroundsDropDivider,
    final Color? fieldsDefault,
    final Color? fieldsHover,
    final Color? fieldsActive,
    final Color? slidersPrimary,
    final Color? slidersSecondary,
    final Color? slidersTrack,
  }) {
    return AppColors(
      textsPrimary: textsPrimary ?? this.textsPrimary,
      textsSecondary: textsSecondary ?? this.textsSecondary,
      textsBackground: textsBackground ?? this.textsBackground,
      textsDisabled: textsDisabled ?? this.textsDisabled,
      textsAction: textsAction ?? this.textsAction,
      textsError: textsError ?? this.textsError,
      iconsDefault: iconsDefault ?? this.iconsDefault,
      iconsHover: iconsHover ?? this.iconsHover,
      iconsActive: iconsActive ?? this.iconsActive,
      iconsDisabled: iconsDisabled ?? this.iconsDisabled,
      iconsBackground: iconsBackground ?? this.iconsBackground,
      iconsFAB: iconsFAB ?? this.iconsFAB,
      iconsLayer: iconsLayer ?? this.iconsLayer,
      iconsAccent: iconsAccent ?? this.iconsAccent,
      buttonsPrimary: buttonsPrimary ?? this.buttonsPrimary,
      buttonsSecondary: buttonsSecondary ?? this.buttonsSecondary,
      buttonsDisabled: buttonsDisabled ?? this.buttonsDisabled,
      buttonsError: buttonsError ?? this.buttonsError,
      buttonsHyperlink: buttonsHyperlink ?? this.buttonsHyperlink,
      buttonsToolbarHover: buttonsToolbarHover ?? this.buttonsToolbarHover,
      buttonsToolbarActive: buttonsToolbarActive ?? this.buttonsToolbarActive,
      buttonsSizdebarActive:
          buttonsSizdebarActive ?? this.buttonsSizdebarActive,
      backgroundsPrimary: backgroundsPrimary ?? this.backgroundsPrimary,
      backgroundsSecondary: backgroundsSecondary ?? this.backgroundsSecondary,
      backgroundsAction: backgroundsAction ?? this.backgroundsAction,
      backgroundsDropdown: backgroundsDropdown ?? this.backgroundsDropdown,
      backgroundsDropAction:
          backgroundsDropAction ?? this.backgroundsDropAction,
      backgroundsDropDivider:
          backgroundsDropDivider ?? this.backgroundsDropDivider,
      fieldsDefault: fieldsDefault ?? this.fieldsDefault,
      fieldsHover: fieldsHover ?? this.fieldsHover,
      fieldsActive: fieldsActive ?? this.fieldsActive,
      slidersPrimary: slidersPrimary ?? this.slidersPrimary,
      slidersSecondary: slidersSecondary ?? this.slidersSecondary,
      slidersTrack: slidersTrack ?? this.slidersTrack,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      textsPrimary: Color.lerp(textsPrimary, other.textsPrimary, t),
      textsSecondary: Color.lerp(textsSecondary, other.textsSecondary, t),
      textsBackground: Color.lerp(textsBackground, other.textsBackground, t),
      textsDisabled: Color.lerp(textsDisabled, other.textsDisabled, t),
      textsAction: Color.lerp(textsAction, other.textsAction, t),
      textsError: Color.lerp(textsError, other.textsError, t),
      iconsDefault: Color.lerp(iconsDefault, other.iconsDefault, t),
      iconsHover: Color.lerp(iconsHover, other.iconsHover, t),
      iconsActive: Color.lerp(iconsActive, other.iconsActive, t),
      iconsDisabled: Color.lerp(iconsDisabled, other.iconsDisabled, t),
      iconsBackground: Color.lerp(iconsBackground, other.iconsBackground, t),
      iconsFAB: Color.lerp(iconsFAB, other.iconsFAB, t),
      iconsLayer: Color.lerp(iconsLayer, other.iconsLayer, t),
      iconsAccent: Color.lerp(iconsAccent, other.iconsAccent, t),
      buttonsPrimary: Color.lerp(buttonsPrimary, other.buttonsPrimary, t),
      buttonsSecondary: Color.lerp(buttonsSecondary, other.buttonsSecondary, t),
      buttonsDisabled: Color.lerp(buttonsDisabled, other.buttonsDisabled, t),
      buttonsError: Color.lerp(buttonsError, other.buttonsError, t),
      buttonsHyperlink: Color.lerp(buttonsHyperlink, other.buttonsHyperlink, t),
      buttonsToolbarHover:
          Color.lerp(buttonsToolbarHover, other.buttonsToolbarHover, t),
      buttonsToolbarActive:
          Color.lerp(buttonsToolbarActive, other.buttonsToolbarActive, t),
      buttonsSizdebarActive:
          Color.lerp(buttonsSizdebarActive, other.buttonsSizdebarActive, t),
      backgroundsPrimary:
          Color.lerp(backgroundsPrimary, other.backgroundsPrimary, t),
      backgroundsSecondary:
          Color.lerp(backgroundsSecondary, other.backgroundsSecondary, t),
      backgroundsAction:
          Color.lerp(backgroundsAction, other.backgroundsAction, t),
      backgroundsDropdown:
          Color.lerp(backgroundsDropdown, other.backgroundsDropdown, t),
      backgroundsDropAction:
          Color.lerp(backgroundsDropAction, other.backgroundsDropAction, t),
      backgroundsDropDivider:
          Color.lerp(backgroundsDropDivider, other.backgroundsDropDivider, t),
      fieldsDefault: Color.lerp(fieldsDefault, other.fieldsDefault, t),
      fieldsHover: Color.lerp(fieldsHover, other.fieldsHover, t),
      fieldsActive: Color.lerp(fieldsActive, other.fieldsActive, t),
      slidersPrimary: Color.lerp(slidersPrimary, other.slidersPrimary, t),
      slidersSecondary: Color.lerp(slidersSecondary, other.slidersSecondary, t),
      slidersTrack: Color.lerp(slidersTrack, other.slidersTrack, t),
    );
  }
}
