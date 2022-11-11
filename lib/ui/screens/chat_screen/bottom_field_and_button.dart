import 'package:chat_app/domain/cubits/chat_cubit.dart';
import 'package:chat_app/domain/cubits/theme_cubit.dart';
import 'package:chat_app/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomFieldAndButton extends StatefulWidget {
  const BottomFieldAndButton({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomFieldAndButton> createState() => _BottomFieldAndButtonState();
}

class _BottomFieldAndButtonState extends State<BottomFieldAndButton> {
  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    final chatCubit = context.watch<ChatCubit>();
    final isMessageEditing = chatCubit.isMessageEditing;
    final isImageSending = chatCubit.isImageSending;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Column(
        children: [
          isMessageEditing
              ? const _ChangeMessageIndicator()
              : const SizedBox.shrink(),
          isImageSending
              ? const _CancelSendingImageIndicator()
              : const SizedBox.shrink(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: themeColors.backgroundColor,
              border: Border(
                top: BorderSide(
                    color: themeColors.sendMessageFieldBackgroundColor),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                ChooseImageButton(),
                _Field(),
                _SendTextMessageButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChooseImageButton extends StatelessWidget {
  const ChooseImageButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    final chatCubit = context.watch<ChatCubit>();


    return GestureDetector(
      onTap: () {
        chatCubit.chooseImageToSendFromGallery();
      },
      child: Container(
        height: 50.h,
        margin: EdgeInsets.only(right: 8.w),
        child: SvgPicture.asset(
          Svgs.image,
          width: 20.w,
          color: themeColors.secondTextColor,
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    final chatCubit = context.watch<ChatCubit>();
    final messageFieldController = chatCubit.messageFieldController;

    return Expanded(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 50.h),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: themeColors.sendMessageFieldBackgroundColor,
            border:
                Border.all(color: themeColors.sendMessageFieldBackgroundColor),
            borderRadius: BorderRadius.circular(25.h),
          ),
          child: TextField(
            onEditingComplete: () {
              if (messageFieldController.text.trim().isEmpty) return;

              chatCubit.sendMessage(text: messageFieldController.text);
              messageFieldController.clear();
            },
            minLines: 1,
            maxLines: 7,
            cursorColor: themeColors.firstPrimaryColor,
            controller: messageFieldController,
            keyboardType: TextInputType.multiline,
            style: TextStyle(color: themeColors.mainColor),
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
    );
  }
}

class _SendTextMessageButton extends StatelessWidget {
  const _SendTextMessageButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    final chatCubit = context.watch<ChatCubit>();
    final messageFieldController = chatCubit.messageFieldController;

    return Container(
      height: 50.w,
      width: 50.w,
      margin: EdgeInsets.only(left: 8.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: themeColors.primaryGradient,
      ),
      child: IconButton(
        onPressed: () {
          if (messageFieldController.text.trim().isEmpty &&
              !chatCubit.isImageSending) return;

          chatCubit.sendMessage(text: messageFieldController.text);
          messageFieldController.clear();
        },
        icon: SvgPicture.asset(
          Svgs.send,
          color: themeColors.mainColor,
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        padding: const EdgeInsets.all(0),
      ),
    );
  }
}

class _ChangeMessageIndicator extends StatelessWidget {
  const _ChangeMessageIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    final chatCubit = context.watch<ChatCubit>();
    final messageFieldController = chatCubit.messageFieldController;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: themeColors.backgroundColor,
        border: Border(
          top: BorderSide(color: themeColors.sendMessageFieldBackgroundColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              messageFieldController.text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: themeColors.mainColor.withOpacity(0.7)),
            ),
          ),
          Container(
            height: 15.w,
            width: 15.w,
            color: Colors.transparent,
            margin: EdgeInsets.only(left: 15.w),
            child: IconButton(
              onPressed: () {
                chatCubit.changeEditingStatus(isEditing: false);
                messageFieldController.clear();
              },
              icon: SvgPicture.asset(
                Svgs.cross,
                color: themeColors.firstPrimaryColor,
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              padding: const EdgeInsets.all(0),
            ),
          ),
        ],
      ),
    );
  }
}

class _CancelSendingImageIndicator extends StatelessWidget {
  const _CancelSendingImageIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    final chatCubit = context.watch<ChatCubit>();
    final imageToSendInUint8List = chatCubit.imageToSendInUint8List;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: themeColors.backgroundColor,
        border: Border(
          top: BorderSide(color: themeColors.sendMessageFieldBackgroundColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          imageToSendInUint8List != null
              ? SizedBox(
                  height: 20.h,
                  child: Image.memory(
                    imageToSendInUint8List,
                    fit: BoxFit.cover,
                  ),
                )
              : const SizedBox.shrink(),
          Container(
            height: 15.w,
            width: 15.w,
            color: Colors.transparent,
            margin: EdgeInsets.only(left: 15.w),
            child: IconButton(
              onPressed: () {
                chatCubit.cancelImageSending();
              },
              icon: SvgPicture.asset(
                Svgs.cross,
                color: themeColors.firstPrimaryColor,
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              padding: const EdgeInsets.all(0),
            ),
          ),
        ],
      ),
    );
  }
}
