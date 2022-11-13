import 'package:camera/camera.dart';
import 'package:chat_app/ui/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// class AppConstants {
//   InputDecoration getTextFieldDecoration(
//           {required String hintText, required AppThemeColors themeColors, String prefixText = ''}) =>
//       InputDecoration(
//         hintText: hintText,
//         hintStyle: TextStyle(
//           color: themeColors.secondTextColor,
//           fontSize: 14.sp,
//         ),
//         prefixIcon: Padding(
//           padding: EdgeInsets.only(left: 30.w),
//           child: Text(
//             prefixText,
//             style: TextStyle(
//               color: themeColors.secondTextColor,
//               fontSize: 14.sp,
//             ),
//           ),
//         ),
//         prefixIconConstraints: BoxConstraints(minWidth: 30.w, minHeight: 0),
//         isDense: true,
//         contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(50.w),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: themeColors.textFieldBorderColor),
//           borderRadius: BorderRadius.circular(50.w),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide:
//               BorderSide(color: themeColors.firstPrimaryColor, width: 1.5.w),
//           borderRadius: BorderRadius.circular(50.w),
//         ),
//       );
// }

List<CameraDescription> cameras = [];

InputDecoration getTextFieldDecoration(
          {required String hintText, required AppThemeColors themeColors, String prefixText = ''}) =>
      InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: themeColors.secondTextColor,
          fontSize: 14.sp,
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 30.w),
          child: Text(
            prefixText,
            style: TextStyle(
              color: themeColors.secondTextColor,
              fontSize: 14.sp,
            ),
          ),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 30.w, minHeight: 0),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: themeColors.textFieldBorderColor),
          borderRadius: BorderRadius.circular(50.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: themeColors.firstPrimaryColor, width: 1.5.w),
          borderRadius: BorderRadius.circular(50.w),
        ),
      );