import 'package:chat_app/domain/cubits/theme_cubit.dart';
import 'package:chat_app/ui/screens/chat_screen/bottom_field_and_button.dart';
import 'package:chat_app/ui/screens/chat_screen/date_messages.dart';
import 'package:chat_app/ui/screens/chat_screen/header.dart';
import 'package:chat_app/ui/screens/chat_screen/messages_block.dart';
import 'package:chat_app/ui/screens/chat_screen/my_messages_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 95.h,
            left: 0,
            right: 0,
            bottom: 75.h,
            child: Container(
              color: themeColors.backgroundColor,
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 17.w),
              child: ListView(
                children: const [
                  MessagesBlock(),
                  MyMessagesBlock(),
                  MessagesDate(),
                  MessagesBlock(),
                ],
              ),
            ),
          ),
          const Header(),
          const BottomFieldAndButton(),
        ],
      ),
    );
  }
}

