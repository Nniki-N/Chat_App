import 'package:chat_app/ui/navigation/main_navigation.dart';
import 'package:chat_app/ui/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domain/cubits/theme_cubit.dart';

class NonExistentScreen extends StatelessWidget {
  const NonExistentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;
    return Scaffold(
      backgroundColor: themeColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'This screen doesn\'t exists',
              style: TextStyle(
                color: themeColors.titleTextColor,
                fontSize: 20.sp,
              ),
            ),
            SizedBox(height: 45.h),
            GradientButton(
                backgroundGradient: themeColors.primaryGradient,
                onPressed: () => Navigator.of(context)
                    .pop(MainNavigationRouteNames.authScreen),
                text: 'Back')
          ],
        ),
      ),
    );
  }
}
