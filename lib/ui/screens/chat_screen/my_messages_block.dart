import 'package:chat_app/domain/cubits/theme_colors_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyMessagesBlock extends StatelessWidget {
  const MyMessagesBlock({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textsList = [
      'Yes, i\'m at Istanbul.. ',
    ];

    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: textsList.length == 1
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.end,
        children: [
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 270.w,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) =>
                    _MyMessageBlockItem(
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

class _MyMessageBlockItem extends StatelessWidget {
  const _MyMessageBlockItem({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: themeColors.myMessageBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.w),
            topRight: Radius.circular(20.w),
            bottomLeft: Radius.circular(20.w),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                color: themeColors.myMessageTextColor,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              '15:04',
              style: TextStyle(
                fontSize: 12.sp,
                color: themeColors.secondPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}