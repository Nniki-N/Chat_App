import 'package:chat_app/domain/cubits/chats_cubit.dart';
import 'package:chat_app/domain/cubits/theme_cubit.dart';
import 'package:chat_app/domain/entity/chat_model.dart';
import 'package:chat_app/ui/navigation/main_navigation.dart';
import 'package:chat_app/ui/screens/main_screen/chats_page/chat_item_avatar.dart';
import 'package:chat_app/ui/screens/main_screen/chats_page/chat_item_last_message_and_indicator.dart';
import 'package:chat_app/ui/screens/main_screen/chats_page/chat_item_user_name_and_date.dart';
import 'package:chat_app/ui/widgets/pop_up_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({
    Key? key,
    required this.chatModel,
  }) : super(key: key);

  void pushToChat() {}

  final ChatModel chatModel;

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    final chatsCubit = context.watch<ChatsCubit>();

    final String? avatarUrl = chatModel.chatImageUrl;
    final String userName = chatModel.chatName;
    final String lastMessageTime =
        chatsCubit.converDateInString(dateTime: chatModel.lastMessageTime);
    final String lastMesssage = chatModel.lastMessage;
    final int unreadedMessagesCount = chatModel.unreadMessagesCount;

    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            flex: 1,
            onPressed: (context) {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    insetPadding: EdgeInsets.symmetric(horizontal: 30.w),
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
                              chatsCubit.deleteChatForCurrentUser(chatModel: chatModel);
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 35.w, top: 20.h, right: 35.w,  bottom: 10.h),
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Text(
                                AppLocalizations.of(context)!.deleteJustForMe,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: themeColors.redColor,
                                ),
                              ),
                            ),
                          ),
                          PopUpDivider(color: themeColors.popUpDividerColor),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              chatsCubit.deleteChatForBoth(chatModel: chatModel);
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 35.w, top: 10.h, right: 35.w,  bottom: 20.h),
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Text(
                                '${AppLocalizations.of(context)!.deleteJustForMeAnd} $userName',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: themeColors.redColor,
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
            backgroundColor: themeColors.redColor,
            foregroundColor: themeColors.mainColor,
            icon: Icons.delete,
            label: AppLocalizations.of(context)!.delete,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () async {
          final chatConfiguration = await chatsCubit.showChat(
              contactUserId: chatModel.chatContactUserId, chatModel: chatModel);

          if (chatConfiguration != null) {
            Navigator.of(context).pushNamed(
            MainNavigationRouteNames.chatScreen,
            arguments: chatConfiguration,
          );
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 17.w),
          child: Row(
            children: [
              ChatItemAvatar(avatarUrl: avatarUrl),
              Expanded(
                child: Column(
                  children: [
                    ChatItemUserNameAndDate(
                        userName: userName, messageDate: lastMessageTime),
                    ChatItemLastMessageAndIndicator(
                        lastMesssage: lastMesssage,
                        unreadedMessagesCount: unreadedMessagesCount),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}