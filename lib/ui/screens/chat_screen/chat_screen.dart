import 'package:chat_app/domain/cubits/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chat_app/domain/cubits/theme_cubit.dart';
import 'package:chat_app/ui/screens/chat_screen/bottom_field_and_button.dart';
import 'package:chat_app/ui/screens/chat_screen/header.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    final chatCubit = context.watch<ChatCubit>();
    final messagesStream = chatCubit.messagesStream;
    final messagesList = chatCubit.messagesList;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 95.h,
            left: 0,
            right: 0,
            bottom: 75.h,
            child: StreamBuilder(
                stream: messagesStream,
                builder: (context, snapshot) {

                  return Container(
                    color: themeColors.backgroundColor,
                    height: double.infinity,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 17.w),
                    child: ListView.separated(
                      reverse: true,
                      itemBuilder: (context, index) =>
                          chatCubit.getMessageView(index: index) ??
                          const SizedBox.shrink(),
                      itemCount: messagesList.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          chatCubit.getMessageDateView(index: index) ??
                          const SizedBox.shrink(),
                    ),
                  );
                }),
          ),
          const Header(),
          const BottomFieldAndButton(),
        ],
      ),
    );
  }
}
