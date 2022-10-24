import 'package:chat_app/domain/cubits/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatItemUserNameAndDate extends StatelessWidget {
  const ChatItemUserNameAndDate({
    Key? key,
    required this.userName,
    required this.messageDate,
  }) : super(key: key);

  final String userName;
  final String messageDate;

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            userName,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: themeColors.mainColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 17.w),
          child: Text(
            messageDate,
            style: TextStyle(
              color: themeColors.chatItemTextColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
