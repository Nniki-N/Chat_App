import 'package:chat_app/domain/cubits/chat_cubit.dart';
import 'package:chat_app/domain/cubits/theme_cubit.dart';
import 'package:chat_app/domain/entity/text_message_model.dart';
import 'package:chat_app/ui/widgets/pop_up_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTextMessageItem extends StatelessWidget {
  const MyTextMessageItem({
    Key? key,
    required this.textMessageModel,
  }) : super(key: key);

  final TextMessageModel textMessageModel;

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

                              messageFieldController.text = textMessageModel.message;
                              chatCubit.changeEditingStatus(isEditing: true, messageId: textMessageModel.messageId);
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
                                  color: themeColors.mainColor,
                                ),
                              ),
                            ),
                          ),
                          PopUpDivider(color: themeColors.popUpDividerColor),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              chatCubit.deleteMessage(messageId: textMessageModel.messageId);
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
                  textMessageModel.message,
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
                    textMessageModel.isEdited ?? false
                        ? Text(
                            'Edited',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: themeColors.secondPrimaryColor,
                            ),
                          )
                        : const SizedBox.shrink(),
                    textMessageModel.isEdited ?? false ? SizedBox(width: 7.w) : const SizedBox.shrink(),
                    Text(
                      chatCubit.getMessageTime(time: textMessageModel.messageTime),
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
