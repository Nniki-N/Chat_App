import 'package:chat_app/domain/cubits/theme_colors_cubit.dart';
import 'package:chat_app/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class MessagesBlock extends StatelessWidget {
  const MessagesBlock({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textsList = [
      'Are you still travelling? OoOo, Thats so Cool!',
      'Raining??',
    ];

    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: 40.h,
            width: 40.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(Images.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 15.w),
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 270.w,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) =>
                    _MessageBlockItem(
                  text: textsList[index],
                ),
                itemCount: textsList.length,
                separatorBuilder: (BuildContext context, int index) =>
                    SizedBox(height: 10.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBlockItem extends StatelessWidget {
  const _MessageBlockItem({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                color: themeColors.messageTextColor,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              '15:04',
              style: TextStyle(
                fontSize: 12.sp,
                color: themeColors.secondTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
