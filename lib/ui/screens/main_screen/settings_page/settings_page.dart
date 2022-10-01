import 'package:chat_app/domain/cubits/authentification_cubit.dart';
import 'package:chat_app/domain/cubits/theme_cubit.dart';
import 'package:chat_app/ui/widgets/error_message.dart';
import 'package:chat_app/ui/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;
    final isSelected = [themeColorsCubit.state, !themeColorsCubit.state];

    final authentificationCubit = context.watch<AuthentificationCubit>();
    final errorText = authentificationCubit.errorText;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 40.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: themeColors.firstPrimaryColor, width: 1.5.w),
              borderRadius: BorderRadius.circular(50.w),
            ),
            clipBehavior: Clip.hardEdge,
            child: LayoutBuilder(builder: (context, constraints) {
              return ToggleButtons(
                constraints:
                    BoxConstraints.expand(width: constraints.maxWidth / 2),
                isSelected: isSelected,
                color: themeColors.firstPrimaryColor,
                fillColor: themeColors.firstPrimaryColor,
                selectedColor: Colors.white,
                renderBorder: false,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                children: [
                  Text('Light theme', style: TextStyle(fontSize: 18.sp)),
                  Text('Dark theme', style: TextStyle(fontSize: 18.sp)),
                ],
                onPressed: (int newIndex) {
                  setState(() {
                    if (!isSelected[newIndex]) themeColorsCubit.toggleTheme();
                  });
                },
              );
            }),
          ),
          SizedBox(height: 30.h),
          ErrorMessage(errorText: errorText, color: themeColors.errorColor),
          SizedBox(height: 30.h),
          GradientButton(
            text: 'Sign Out',
            backgroundGradient: themeColors.primaryGradient,
            onPressed: () => authentificationCubit.signOut(),
          ),
        ],
      ),
    );
  }
}
