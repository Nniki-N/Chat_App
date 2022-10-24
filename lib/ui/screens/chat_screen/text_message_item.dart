import 'package:chat_app/domain/cubits/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextMessageItem extends StatelessWidget {
  const TextMessageItem({
    Key? key,
    required this.messageText,
    required this.messageDate,
    required this.isEdited,
  }) : super(key: key);

  final String messageText;
  final String messageDate;
  final bool isEdited;

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 270.w,
        ),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.h),
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: themeColors.messageBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.w),
              topRight: Radius.circular(20.w),
              bottomRight: Radius.circular(20.w),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                messageText,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: themeColors.messageTextColor,
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  isEdited
                      ? Text(
                          'Edited',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: themeColors.secondPrimaryColor,
                          ),
                        )
                      : const SizedBox.shrink(),
                  isEdited ? SizedBox(width: 7.w) : const SizedBox.shrink(),
                  Text(
                    messageDate,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: themeColors.secondTextColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
