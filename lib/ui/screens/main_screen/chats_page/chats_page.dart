import 'package:chat_app/domain/cubits/theme_colors_cubit.dart';
import 'package:chat_app/resources/resources.dart';
import 'package:chat_app/ui/navigation/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _ChatsTitleAndSearchField(),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.only(bottom: 15.h),
            itemBuilder: (context, index) => const _ChatItem(),
            separatorBuilder: (context, index) => SizedBox(height: 25.h),
            itemCount: 10,
          ),
        )
      ],
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
                  onPressed: () {},
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
  }) : super(key: key);

  final Color cursorColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      enableSuggestions: false,
      keyboardType: TextInputType.emailAddress,
      cursorColor: cursorColor,
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String avatarPath = Images.image;
    const String userName = 'User name';
    const String messageDate = '29 may';
    const String lastMesssage =
        'Are you ready for thoday\'s party in Toms home?';
    const int unreadedMessagesCount = 4;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(MainNavigationRouteNames.chatScreen);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 17.w),
        child: Row(
          children: [
            const _ChatItemAvatar(avatarPath: avatarPath),
            Expanded(
              child: Column(
                children: const [
                  _ChatItemUserNameAndDate(
                      userName: userName, messageDate: messageDate),
                  _ChatItemLastMessageAndIndicator(
                      lastMesssage: lastMesssage,
                      unreadedMessagesCount: unreadedMessagesCount),
                ],
              ),
            )
          ],
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

  final String avatarPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      width: 50.w,
      margin: EdgeInsets.only(right: 23.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage(avatarPath),
          fit: BoxFit.cover,
        ),
      ),
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
            style: TextStyle(
              color: themeColors.unreadMessageTextColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Padding(
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
