import 'package:chat_app/domain/cubits/chat_cubit.dart';
import 'package:chat_app/domain/cubits/theme_cubit.dart';
import 'package:chat_app/domain/entity/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyMessageItem extends StatelessWidget {
  const MyMessageItem({
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
                  return Dialog(
                    insetPadding: EdgeInsets.symmetric(horizontal: 90.w),
                    backgroundColor: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                          color: themeColors.backgroundColor,
                          borderRadius: BorderRadius.circular(20.h)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              final messageFieldController =
                                  chatCubit.messageFieldController;

                              messageFieldController.text = messageModel.message;
                              chatCubit.setEditingStatus(messageId: messageModel.messageId);
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 35.w, top: 20.h, right: 35.w,  bottom: 10.h),
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: themeColors.titleTextColor,
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            color: themeColors.inactiveInputColor,
                            height: 2.h,
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              chatCubit.deleteMessage(messageId: messageModel.messageId);
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 35.w, top: 10.h, right: 35.w,  bottom: 20.h),
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Text(
                                'Delete',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
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
                Text(
                  messageModel.message,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: themeColors.myMessageTextColor,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
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
                    messageModel.isEdited ?? false ? SizedBox(width: 7.w) : const SizedBox.shrink(),
                    Text(
                      chatCubit.getMessageTime(time: messageModel.messageTime),
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
