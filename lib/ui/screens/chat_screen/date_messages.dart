import 'package:chat_app/domain/cubits/theme_colors_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessagesDate extends StatelessWidget {
  const MessagesDate({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;
    return Container(
      alignment: Alignment.center,
      child: Text(
        'Tuesday 07.09',
        style: TextStyle(
          fontSize: 14.sp,
          color: themeColors.secondTextColor,
        ),
      ),
    );
  }
}