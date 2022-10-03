import 'package:chat_app/domain/cubits/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatDateSeparator extends StatelessWidget {
  const ChatDateSeparator({
    Key? key, required this.date,
  }) : super(key: key);

  final String date;

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;
    return Container(
      alignment: Alignment.center,
      child: Text(
        date,
        style: TextStyle(
          fontSize: 14.sp,
          color: themeColors.secondTextColor,
        ),
      ),
    );
  }
}