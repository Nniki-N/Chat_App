import 'package:chat_app/domain/cubits/theme_cubit.dart';
import 'package:chat_app/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoInernetConnectionScreen extends StatelessWidget {
  const NoInernetConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    return Scaffold(
      backgroundColor: themeColors.backgroundColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(Svgs.noInternetConnection, width: 140.w,),
              SizedBox(height: 30.h),
              Text(
                AppLocalizations.of(context)!.internetConnectionAbsents,
                style: TextStyle(
                  color: themeColors.mainColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 26.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
