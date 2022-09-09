import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({super.key, required this.errorText, required this.color});
  final String errorText;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return errorText.isEmpty
        ? const SizedBox()
        : Padding(
            padding: EdgeInsets.only(top: 25.h),
            child: Text(
              errorText,
              style: TextStyle(
                fontSize: 14,
                color: color,
              ),
            ),
          );
  }
}