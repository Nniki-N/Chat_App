import 'package:chat_app/domain/cubits/account_cubit.dart';
import 'package:chat_app/domain/cubits/auth_cubit.dart';
import 'package:chat_app/domain/cubits/theme_cubit.dart';
import 'package:chat_app/resources/resources.dart';
import 'package:chat_app/ui/navigation/main_navigation.dart';
import 'package:chat_app/ui/screens/change_profile_screen/change_profile_screen.dart';
import 'package:chat_app/ui/widgets/border_gradient_button.dart';
import 'package:chat_app/ui/widgets/custom_text_button.dart';
import 'package:chat_app/ui/widgets/error_message.dart';
import 'package:chat_app/ui/widgets/gradient_button.dart';
import 'package:chat_app/ui/widgets/settings_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 17.w, top: 50.h, right: 17.w),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const _UserInfoBlock(),
          SizedBox(height: 25.h),
          const _AppSettingsBlock(),
          SizedBox(height: 25.h),
          const _AccountBlock(),
        ],
      ),
    );
  }
}

class _UserInfoBlock extends StatelessWidget {
  const _UserInfoBlock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        final currentUser = state.currentUser;
        final userName = currentUser?.userName;
        final userLogin = currentUser?.userLogin;
        final userImageUrl = currentUser?.userImageUrl;

        return Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: double.infinity),
                Container(
                  width: 120.w,
                  height: 120.h,
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: userImageUrl == null || userImageUrl.trim().isEmpty
                      ? SvgPicture.asset(Svgs.defaultUserImage)
                      : Image.network(
                          userImageUrl,
                          fit: BoxFit.cover,
                        ),
                ),
                SizedBox(height: 10.h),
                Text(
                  userName ?? 'user name',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: themeColors.mainColor,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  userLogin ?? 'user login',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: themeColors.settingsUserLoginTextColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: CustomTextButton(
                text: 'Edit',
                color: themeColors.mainColor,
                onpressed: () {
                  final changeProfileConfiguration = ChangeProfileConfiguration(
                      currentUserModel: currentUser!);

                  Navigator.of(context).pushNamed(
                      MainNavigationRouteNames.changeProfileScreen,
                      arguments: changeProfileConfiguration);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AppSettingsBlock extends StatelessWidget {
  const _AppSettingsBlock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: themeColors.settingsItemBackgroundColor,
            borderRadius: BorderRadius.circular(7.h),
          ),
          child: Column(
            children: [
              _AppSettingsItem(text: 'Language', onPressed: () {}),
              SettingsDivider(color: themeColors.settingsDividerColor),
              _AppSettingsItem(text: 'Privacy and Security', onPressed: () {}),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: themeColors.settingsItemBackgroundColor,
            borderRadius: BorderRadius.circular(7.h),
          ),
          child: Column(
            children: [
              _AppSettingsSwitchItem(
                text: 'Dark theme',
                switchValue: !themeColorsCubit.state,
                onPressed: (_) {
                  themeColorsCubit.toggleTheme();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AppSettingsItem extends StatelessWidget {
  const _AppSettingsItem({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 17.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: themeColors.settingsItemContentColor,
                fontSize: 16.sp,
              ),
            ),
            SvgPicture.asset(
              Svgs.arrowRight,
              color: themeColors.settingsItemContentColor,
              width: 15.w,
              height: 15.h,
            )
          ],
        ),
      ),
    );
  }
}

class _AppSettingsSwitchItem extends StatelessWidget {
  const _AppSettingsSwitchItem({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.switchValue,
  }) : super(key: key);

  final String text;
  final bool switchValue;
  final void Function(bool) onPressed;

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 17.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: themeColors.settingsItemContentColor,
              fontSize: 16.sp,
            ),
          ),
          Switch(
            value: switchValue,
            onChanged: onPressed,
            activeColor: themeColors.firstPrimaryColor,
          ),
        ],
      ),
    );
  }
}

class _AccountBlock extends StatelessWidget {
  const _AccountBlock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    final authCubit = context.read<AuthCubit>();
    final accountCubit = context.read<AccountCubit>();
    final authErrorTextStream = authCubit.errorTextStream;
    final accountErrorTextStream = accountCubit.errorTextStream;

    return StreamBuilder(
      stream: authErrorTextStream,
      builder: (context, snapshot) {
        return StreamBuilder(
          stream: accountErrorTextStream,
          builder: (context, snapshot) {
            final String errorText;
            if (authCubit.errorText.isNotEmpty) {
              errorText = authCubit.errorText;
            } else if (accountCubit.errorText.isEmpty) {
              errorText = accountCubit.errorText;
            } else {
              errorText = '';
            }

            return Column(
              children: [
                GradientButton(
                  text: 'Sign Out',
                  backgroundGradient: themeColors.primaryGradient,
                  onPressed: () {
                    authCubit.signOut().then(
                      (successful) {
                        if (successful) {
                          accountCubit.setNewCurrentUser(isSignedIn: true);
                        }
                      },
                    );
                  },
                ),
                SizedBox(height: 15.h),
                BorderGradientButton(
                  text: 'Delete account',
                  borderGradient: themeColors.primaryGradient,
                  backgroundColor: themeColors.backgroundColor,
                  textColor: themeColors.firstPrimaryColor,
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                        MainNavigationRouteNames.deleteAccountScreen);
                  },
                ),
                ErrorMessage(
                    errorText: errorText, color: themeColors.errorColor),
              ],
            );
          },
        );
      },
    );
  }
}
