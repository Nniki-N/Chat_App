import 'package:chat_app/domain/cubits/theme_cubit.dart';
import 'package:chat_app/ui/navigation/main_navigation.dart';
import 'package:chat_app/ui/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
              AppLocalizations.of(context)!.thisScreenDoesntExists,
              style: TextStyle(
                color: themeColors.mainColor,
                fontSize: 20.sp,
              ),
            ),
            SizedBox(height: 45.h),
            GradientButton(
                backgroundGradient: themeColors.primaryGradient,
                onPressed: () => Navigator.of(context)
                    .pop(MainNavigationRouteNames.authScreen),
                text: AppLocalizations.of(context)!.back)
          ],
        ),
      ),
    );
  }
}
