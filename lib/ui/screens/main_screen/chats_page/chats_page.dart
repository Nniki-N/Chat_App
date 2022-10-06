import 'package:chat_app/domain/cubits/chats_cubit.dart';
import 'package:chat_app/domain/cubits/theme_cubit.dart';
import 'package:chat_app/domain/entity/chat_model.dart';
import 'package:chat_app/resources/resources.dart';
import 'package:chat_app/ui/navigation/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final chatsCubit = context.watch<ChatsCubit>();
    final chatsStream = chatsCubit.chatsStream;

    return StreamBuilder(
      stream: chatsStream,
      builder: (context, snapshot) {
        final chatsList = chatsCubit.getChatsList();

        return Column(
          children: [
            const _ChatsTitleAndSearchField(),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.only(bottom: 15.h),
                itemBuilder: (context, index) {
                  final chatModel = chatsList.elementAt(index);

                  return _ChatItem(
                    chatModel: chatModel,
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 25.h),
                itemCount: chatsList.length,
              ),
            )
          ],
        );
      },
    );
  }
}

class _ChatsTitleAndSearchField extends StatelessWidget {
  const _ChatsTitleAndSearchField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    return Container(
      padding: EdgeInsets.fromLTRB(18.w, 40.h, 18.w, 18.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Chats',
                style: TextStyle(
                  color: themeColors.titleTextColor,
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 24.w,
                width: 24.w,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(MainNavigationRouteNames.newChatScreen);
                  },
                  icon: SvgPicture.asset(
                    Svgs.edit,
                    color: themeColors.titleTextColor,
                  ),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  padding: const EdgeInsets.all(0),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          _SearchField(
            cursorColor: themeColors.firstPrimaryColor,
            borderColor: themeColors.inactiveInputColor,
            textColor: themeColors.titleTextColor,
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    Key? key,
    required this.cursorColor,
    required this.borderColor,
    required this.textColor,
  }) : super(key: key);

  final Color cursorColor;
  final Color borderColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final chatsCubit = context.watch<ChatsCubit>();

    return TextField(
      autocorrect: false,
      enableSuggestions: false,
      keyboardType: TextInputType.emailAddress,
      cursorColor: cursorColor,
      onChanged: (text) => chatsCubit.setSearchText(searchText: text),
      style: TextStyle(
        color: textColor,
      ),
      decoration: InputDecoration(
        hintText: 'Search here...',
        hintStyle: TextStyle(
          color: borderColor,
          fontSize: 14.sp,
        ),
        prefixIcon: Container(
          margin: EdgeInsets.symmetric(horizontal: 17.w),
          child: SvgPicture.asset(Svgs.magnifier),
        ),
        suffixIcon: Container(
          margin: EdgeInsets.symmetric(horizontal: 17.w),
          child: GestureDetector(
            onTap: () {},
            child: SvgPicture.asset(Svgs.microphone),
          ),
        ),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 11.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(50.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(50.w),
        ),
      ),
    );
  }
}

class _ChatItem extends StatelessWidget {
  const _ChatItem({
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

    final String? avatarPath = chatModel.chatImageUrl;
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
              // chatsCubit.deleteChat(chatModel: chatModel);


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
                              ///////////////////////////////////////////////////////////
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 35.w, top: 20.h, right: 35.w,  bottom: 10.h),
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Text(
                                'Delete just for me',
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Colors.red,
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
                              chatsCubit.deleteChatForBoth(chatModel: chatModel);

                              ///////////////////////////////////////////////////////
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 35.w, top: 10.h, right: 35.w,  bottom: 20.h),
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Text(
                                'Delete for me and $userName',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () async {
          final chatConfiguration = await chatsCubit.showChat(
              contactUserId: chatModel.chatContactId, chatModel: chatModel);

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
              _ChatItemAvatar(avatarPath: avatarPath),
              Expanded(
                child: Column(
                  children: [
                    _ChatItemUserNameAndDate(
                        userName: userName, messageDate: lastMessageTime),
                    _ChatItemLastMessageAndIndicator(
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

class _ChatItemAvatar extends StatelessWidget {
  const _ChatItemAvatar({
    Key? key,
    required this.avatarPath,
  }) : super(key: key);

  final String? avatarPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      width: 50.w,
      margin: EdgeInsets.only(right: 23.w),
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: avatarPath == null
          ? SvgPicture.asset(Svgs.defaultUserImage)
          : const Image(image: AssetImage(Images.image)),
    );
  }
}

class _ChatItemUserNameAndDate extends StatelessWidget {
  const _ChatItemUserNameAndDate({
    Key? key,
    required this.userName,
    required this.messageDate,
  }) : super(key: key);

  final String userName;
  final String messageDate;

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            userName,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: themeColors.titleTextColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 17.w),
          child: Text(
            messageDate,
            style: TextStyle(
              color: themeColors.unreadMessageTextColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

class _ChatItemLastMessageAndIndicator extends StatelessWidget {
  const _ChatItemLastMessageAndIndicator({
    Key? key,
    required this.lastMesssage,
    required this.unreadedMessagesCount,
  }) : super(key: key);

  final String lastMesssage;
  final int unreadedMessagesCount;

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            lastMesssage,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: themeColors.unreadMessageTextColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        unreadedMessagesCount == 0
            ? const SizedBox.shrink()
            : Padding(
                padding: EdgeInsets.only(left: 17.w),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.h),
                    color: themeColors.firstPrimaryColor,
                  ),
                  child: Text(
                    unreadedMessagesCount.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )),
      ],
    );
  }
}
