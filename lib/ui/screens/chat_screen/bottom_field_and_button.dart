import 'package:chat_app/domain/cubits/theme_colors_cubit.dart';
import 'package:chat_app/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomFieldAndButton extends StatelessWidget {
  const BottomFieldAndButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: themeColors.backgroundColor,
          border: Border(
            top: BorderSide(color: themeColors.sendMessageFieldBackgroundColor),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 22.w),
                alignment: Alignment.centerLeft,
                height: 50.h,
                decoration: BoxDecoration(
                  color: themeColors.sendMessageFieldBackgroundColor,
                  border: Border.all(
                      color: themeColors.sendMessageFieldBackgroundColor),
                  borderRadius: BorderRadius.circular(50.h),
                ),
                child: TextField(
                  minLines: 1,
                  maxLines: 7,
                  cursorColor: themeColors.firstPrimaryColor,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: themeColors.sendMessageFieldHintTextColor,
                      fontSize: 16.sp,
                    ),
                    hintText: 'Message',
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            Container(
              height: 50.w,
              width: 50.w,
              margin: EdgeInsets.only(left: 8.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: themeColors.primaryGradient,
              ),
              child: IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  Svgs.send,
                  color: Colors.white,
                ),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                padding: const EdgeInsets.all(0),
              ),
            )
          ],
        ),
      ),
    );
  }
}