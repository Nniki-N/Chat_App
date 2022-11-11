import 'package:chat_app/domain/cubits/chat_cubit.dart';
import 'package:chat_app/domain/cubits/theme_cubit.dart';
import 'package:chat_app/domain/entity/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({
    Key? key,
    required this.messageModel,
  }) : super(key: key);

  final MessageModel messageModel;

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    final chatCubit = context.watch<ChatCubit>();

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 270.w,
        ),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.h),
          clipBehavior: Clip.hardEdge,
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
              messageModel.messageImageUrl != null
                  ? SizedBox(
                      width: 270.w,
                      child: Image.network(
                        messageModel.messageImageUrl!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const SizedBox.shrink(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      messageModel.message,
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
                        messageModel.isEdited ?? false
                            ? Text(
                                'Edited',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: themeColors.secondPrimaryColor,
                                ),
                              )
                            : const SizedBox.shrink(),
                        messageModel.isEdited ?? false
                            ? SizedBox(width: 7.w)
                            : const SizedBox.shrink(),
                        Text(
                          chatCubit.getMessageTime(
                                time: messageModel.messageTime),
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
            ],
          ),
        ),
      ),
    );
  }
}
