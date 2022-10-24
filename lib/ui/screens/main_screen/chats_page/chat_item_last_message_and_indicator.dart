import 'package:chat_app/domain/cubits/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatItemLastMessageAndIndicator extends StatelessWidget {
  const ChatItemLastMessageAndIndicator({
    Key? key,
    required this.lastMesssage,
    required this.unreadedMessagesCount,
  }) : super(key: key);

  final String lastMesssage;
  final int unreadedMessagesCount;

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            lastMesssage,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: themeColors.chatItemTextColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        unreadedMessagesCount == 0
            ? const SizedBox.shrink()
            : Padding(
                padding: EdgeInsets.only(left: 17.w),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.h),
                    color: themeColors.firstPrimaryColor,
                  ),
                  child: Text(
                    unreadedMessagesCount.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )),
      ],
    );
  }
}