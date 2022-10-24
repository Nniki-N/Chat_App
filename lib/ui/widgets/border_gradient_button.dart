import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BorderGradientButton extends StatelessWidget {
  BorderGradientButton({
    Key? key,
    required this.borderGradient,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
    required this.text,
    double width = double.infinity,
    double height = 50,
  }) : super(key: key) {
    this.height = height == 50 ? height.h : height;
    this.width = width != double.infinity ? width : double.infinity;
  }

  final String text;
  late final double width;
  late final double height;
  final Gradient borderGradient;
  final Color backgroundColor;
  final Color textColor;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(1.5.w),
      decoration: BoxDecoration(
        gradient: borderGradient,
        borderRadius: BorderRadius.circular(50.h),
      ),
      child: Container(
        decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(50.h),
      ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            elevation: MaterialStateProperty.all(0),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
