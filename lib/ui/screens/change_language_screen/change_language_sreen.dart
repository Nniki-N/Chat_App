import 'package:chat_app/domain/cubits/language_cubit.dart';
import 'package:chat_app/domain/cubits/theme_cubit.dart';
import 'package:chat_app/resources/resources.dart';
import 'package:chat_app/ui/navigation/main_navigation.dart';
import 'package:chat_app/ui/widgets/settings_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChangeLanguageScreen extends StatelessWidget {
  const ChangeLanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    final languageCubit = context.watch<LanguageCubit>();
    final languageCode = languageCubit.state.currentLanguage;

    return Scaffold(
      backgroundColor: themeColors.backgroundColor,
      body: Padding(
        padding: EdgeInsets.only(left: 17.w, top: 50.h, right: 17.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              height: 20.w,
              width: 20.w,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).popAndPushNamed(MainNavigationRouteNames.mainScreen, arguments: 2);
                },
                icon: SvgPicture.asset(
                  Svgs.cross,
                  color: themeColors.mainColor,
                ),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                padding: const EdgeInsets.all(0),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 25.h),
              decoration: BoxDecoration(
                color: themeColors.settingsItemBackgroundColor,
                borderRadius: BorderRadius.circular(7.h),
              ),
              child: Column(
                children: [
                  LanguageItem(
                    isSelected: languageCode == 'en',
                    text: 'English',
                    fontFamily: 'Poppins',
                    onPressed: () {
                      languageCubit.changeLanguage(languageCode: 'en');
                    },
                  ),
                  SettingsDivider(color: themeColors.settingsDividerColor),
                  LanguageItem(
                    isSelected: languageCode == 'uk',
                    text: 'Українська',
                    fontFamily: 'OpenSans',
                    onPressed: () {
                      languageCubit.changeLanguage(languageCode: 'uk');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageItem extends StatelessWidget {
  const LanguageItem({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.isSelected,
    this.fontFamily,
  }) : super(key: key);

  final String? fontFamily;
  final bool isSelected;
  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 17.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                color: themeColors.mainColor,
                fontSize: 18.sp,
                fontFamily: fontFamily,
              ),
            ),
            isSelected
                ? SvgPicture.asset(
                    Svgs.checkMark,
                    color: themeColors.firstPrimaryColor,
                    height: 8.h,
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
