import 'package:chat_app/domain/cubits/chat_cubit.dart';
import 'package:chat_app/domain/cubits/theme_cubit.dart';
import 'package:chat_app/domain/entity/image_message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyImageMessageItem extends StatelessWidget {
  const MyImageMessageItem({
    Key? key,
    required this.imageMessageModel,
  }) : super(key: key);

  final ImageMessageModel imageMessageModel;

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    final chatCubit = context.watch<ChatCubit>();

    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 270.w,
        ),
        child: GestureDetector(
          onLongPress: () {
            showDialog(
                context: context,
                builder: (context) {
                  return Container(); ////////////////////////////////////////////////////////////////////////////////////////
                });
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.h),
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
                Image.network(imageMessageModel.imageUrl),
                SizedBox(height: 2.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    imageMessageModel.isEdited ?? false
                        ? Text(
                            'Edited',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: themeColors.secondPrimaryColor,
                            ),
                          )
                        : const SizedBox.shrink(),
                    imageMessageModel.isEdited ?? false ? SizedBox(width: 7.w) : const SizedBox.shrink(),
                    Text(
                      chatCubit.getMessageTime(time: imageMessageModel.messageTime),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: themeColors.secondPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
