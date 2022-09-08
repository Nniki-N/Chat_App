
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppConstants {
  InputDecoration getTextFieldDecoration({required hintText, required themeColors}) => InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: themeColors.inactiveInputColor,
          fontSize: 14.sp,
        ),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: themeColors.inactiveInputColor),
          borderRadius: BorderRadius.circular(50.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: themeColors.firstPrimaryColor, width: 1.5.w),
          borderRadius: BorderRadius.circular(50.w),
        ),
        
      );
}
