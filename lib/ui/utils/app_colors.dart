import 'package:flutter/material.dart';

abstract class AppThemeColors {
  Color get backgroundColor;

  Color get borderColor;

  Color get firstPrimaryColor;
  Color get secondPrimaryColor;

  LinearGradient get primaryGradient;

  Color get inactiveInputColor;
  Color get titleTextColor;
  Color get secondTextColor;

  Color get myMessageTextColor;
  Color get messageTextColor;
  Color get unreadMessageTextColor;
  Color get sendMessageFieldBackgroundColor;
  Color get sendMessageFieldHintTextColor;

  Color get myMessageBackgroundColor;
  Color get messageBackgroundColor;
}

class DarkThemeColors extends AppThemeColors {
  @override
  Color get backgroundColor => const Color(0xff171717);

  @override
  Color get borderColor => const Color(0xff515151);

  @override
  Color get firstPrimaryColor => const Color(0xff007665);
  @override
  Color get secondPrimaryColor => const Color(0xff55A99D);

  @override
  LinearGradient get primaryGradient => const LinearGradient(
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
        colors: [
          Color(0xff007665),
          Color(0xff55A99D),
        ],
      );

  @override
  Color get inactiveInputColor => const Color(0xff7D7979);
  @override
  Color get titleTextColor => const Color(0xffffffff);
  @override
  Color get secondTextColor => const Color(0xff8E8E8E);

  @override
  Color get myMessageTextColor => const Color(0xff007665);
  @override
  Color get messageTextColor => const Color(0xffE7E7E7);
  @override
  Color get unreadMessageTextColor => const Color(0xffBABABA);
  @override
  Color get sendMessageFieldBackgroundColor => const Color(0xff242424);
  @override
  Color get sendMessageFieldHintTextColor => const Color(0xff929292);

  @override
  Color get myMessageBackgroundColor => const Color(0xffD0ECE8);
  @override
  Color get messageBackgroundColor => const Color(0xff3D3D3D);
}

class LightThemeColors extends AppThemeColors {
  @override
  Color get backgroundColor => const Color(0xffffffff);

  @override
  Color get borderColor => const Color(0xffD9D9D9);

  @override
  Color get firstPrimaryColor => const Color(0xff007665);
  @override
  Color get secondPrimaryColor => const Color(0xff55A99D);

  @override
  LinearGradient get primaryGradient => const LinearGradient(
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
        colors: [
          Color(0xff007665),
          Color(0xff55A99D),
        ],
      );

  @override
  Color get inactiveInputColor => const Color(0xffC9C9C9);
  @override
  Color get titleTextColor => const Color(0xff000000);
  @override
  Color get secondTextColor => const Color(0xff8E8E8E);

  @override
  Color get myMessageTextColor => const Color(0xff007665);
  @override
  Color get messageTextColor => const Color(0xff383737);
  @override
  Color get unreadMessageTextColor => const Color(0xffBABABA);
  @override
  Color get sendMessageFieldBackgroundColor => const Color(0xffEFEFEF);
  @override
  Color get sendMessageFieldHintTextColor => const Color(0xff929292);

  @override
  Color get myMessageBackgroundColor => const Color(0xffD0ECE8);
  @override
  Color get messageBackgroundColor => const Color(0xffE9E9E9);
}
