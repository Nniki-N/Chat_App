import 'package:flutter/material.dart';

abstract class AppThemeColors {
  LinearGradient get primaryGradient => const LinearGradient(
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
        colors: [
          Color(0xff007665),
          Color(0xff55A99D),
        ],
      );

  Color get firstPrimaryColor => const Color(0xff007665);
  Color get secondPrimaryColor => const Color(0xff55A99D);

  Color get backgroundColor;
  Color get mainColor;

  Color get secondTextColor;
  Color get chatItemTextColor;

  // messages colors
  Color get myMessageTextColor;
  Color get messageTextColor;
  Color get sendMessageFieldBackgroundColor;
  Color get sendMessageFieldHintTextColor;
  Color get myMessageBackgroundColor;
  Color get messageBackgroundColor;

  // dividers colors
  Color get popUpDividerColor;
  Color get settingsDividerColor;

  // setting elements colors
  Color get settingsFieldHintTextColor;
  Color get settingsUserLoginTextColor;
  Color get settingsItemBackgroundColor;
  Color get settingsItemContentColor;

  // borders colors
  Color get textFieldBorderColor;
  Color get searchFieldBorderColor;
  Color get bottomMenuBorderColor;
  Color get chatHeaderBorderColor;

  Color get errorColor;
}

class DarkThemeColors extends AppThemeColors {
  @override
  Color get backgroundColor => const Color(0xff171717);
  @override
  Color get mainColor => const Color(0xffffffff);

  @override
  Color get secondTextColor => const Color(0xff8E8E8E);
  @override
  Color get chatItemTextColor => const Color(0xffBABABA);

  // messages colors
  @override
  Color get myMessageTextColor => const Color(0xff007665);
  @override
  Color get messageTextColor => const Color(0xffE7E7E7);
  @override
  Color get sendMessageFieldBackgroundColor => const Color(0xff242424);
  @override
  Color get sendMessageFieldHintTextColor => const Color(0xff929292);
  @override
  Color get myMessageBackgroundColor => const Color(0xffD0ECE8);
  @override
  Color get messageBackgroundColor => const Color(0xff3D3D3D);

  // dividers colors
  @override
  Color get popUpDividerColor => const Color(0xFF2E2E2E);
  @override
  Color get settingsDividerColor => const Color(0xFF3D3D3D);

  // setting elements colors
  @override
  Color get settingsFieldHintTextColor => const Color(0xff7D7979);
  @override
  Color get settingsUserLoginTextColor => const Color(0xff515151);
  @override
  Color get settingsItemBackgroundColor => const Color(0xff212121);
  @override
  Color get settingsItemContentColor => const Color(0xffffffff);

  // borders colors
  @override
  Color get searchFieldBorderColor => const Color(0xff7D7979);
  @override
  Color get textFieldBorderColor => const Color(0xff7D7979);
  @override
  Color get bottomMenuBorderColor => const Color(0xff515151);
  @override
  Color get chatHeaderBorderColor => const Color(0xff515151);

  @override
  Color get errorColor => Colors.red;
}

class LightThemeColors extends AppThemeColors {
  @override
  Color get backgroundColor => const Color(0xffffffff);
  @override
  Color get mainColor => const Color(0xff000000);

  @override
  Color get secondTextColor => const Color(0xff8E8E8E);
  @override
  Color get chatItemTextColor => const Color(0xffACACAC);

  // messages colors
  @override
  Color get myMessageTextColor => const Color(0xff007665);
  @override
  Color get messageTextColor => const Color(0xff383737);
  @override
  Color get sendMessageFieldBackgroundColor => const Color(0xffE4E4E4);
  @override
  Color get sendMessageFieldHintTextColor => const Color(0xff929292);
  @override
  Color get myMessageBackgroundColor => const Color(0xffD0ECE8);
  @override
  Color get messageBackgroundColor => const Color(0xffE9E9E9);

  // dividers colors
  @override
  Color get popUpDividerColor => const Color(0xffC9C9C9);
  @override
  Color get settingsDividerColor => const Color(0xFFD1D1D1);

  // seting elements colors
  @override
  Color get settingsFieldHintTextColor => const Color(0xffC9C9C9);
  @override
  Color get settingsUserLoginTextColor => const Color(0xff7E7E7E);
  @override
  Color get settingsItemBackgroundColor => const Color(0xFFF1F1F1);
  @override
  Color get settingsItemContentColor => const Color(0xff000000);

  // borders colors
  @override
  Color get searchFieldBorderColor => const Color(0xffC9C9C9);
  @override
  Color get textFieldBorderColor => const Color(0xff9C9C9C);
  @override
  Color get bottomMenuBorderColor => const Color(0xffD9D9D9);
  @override
  Color get chatHeaderBorderColor => const Color(0xffD9D9D9);

  @override
  Color get errorColor => Colors.red;
}
