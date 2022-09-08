import 'package:chat_app/domain/cubits/theme_colors_cubit.dart';
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
    final themeColorsCubit = context.watch<ThemeColorsCubit>();
    final themeColors = themeColorsCubit.themeColors;
    final isSelected = [themeColorsCubit.state, !themeColorsCubit.state];

    return Center(
      child: Container(
        decoration: BoxDecoration(
          border:
              Border.all(color: themeColors.firstPrimaryColor, width: 1.5.w),
          borderRadius: BorderRadius.circular(15.w),
        ),
        clipBehavior: Clip.hardEdge,
        child: ToggleButtons(
          isSelected: isSelected,
          color: themeColors.firstPrimaryColor,
          fillColor: themeColors.firstPrimaryColor,
          selectedColor: Colors.white,
          renderBorder: false,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
              child: Text('Light theme', style: TextStyle(fontSize: 18.sp)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
              child: Text('Dark theme', style: TextStyle(fontSize: 18.sp)),
            ),
          ],
          onPressed: (int newIndex) {
            setState(() {
              if (!isSelected[newIndex]) {
                themeColorsCubit.switchTheme();
              }
            });
          },
        ),
      ),
    );
  }
}
