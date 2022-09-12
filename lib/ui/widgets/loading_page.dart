
import 'package:chat_app/domain/cubits/theme_colors_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;
    
    return Scaffold(
      backgroundColor: themeColors.backgroundColor,
      body: Center(
        child: LoadingAnimationWidget.fourRotatingDots(
        color: themeColors.secondPrimaryColor,
        size: 90.w,
      ),
      ),
    );
  }
}