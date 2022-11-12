import 'package:chat_app/domain/cubits/chat_cubit.dart';
import 'package:chat_app/domain/cubits/theme_cubit.dart';
import 'package:chat_app/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(17.w, 32.h, 17.w, 12.h),
        decoration: BoxDecoration(
          color: themeColors.backgroundColor,
          border: Border(
            bottom: BorderSide(color: themeColors.chatHeaderBorderColor),
          ),
        ),
        child: Row(
          children: [
            const _HeaaderButtonBack(),
            SizedBox(width: 13.w),
            BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                return _HeaderAvatar(avatarUrl: state.currentChat.chatImageUrl);
              },
            ),
            SizedBox(width: 16.w),
            BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                return _HeaderTitle(
                  userName: state.currentChat.chatName,
                  isOnline: state.currentChat.isChatContactUserOline,
                );
              },
            ),
            SizedBox(width: 16.w),
            const _HeaderCallButtons()
          ],
        ),
      ),
    );
  }
}

class _HeaaderButtonBack extends StatelessWidget {
  const _HeaaderButtonBack({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    return SizedBox(
      width: 17.w,
      height: 17.h,
      child: IconButton(
        onPressed: () => Navigator.of(context)
            .pop(),
        icon: SvgPicture.asset(
          Svgs.arrowLeft,
          color: themeColors.mainColor,
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        padding: const EdgeInsets.all(0),
      ),
    );
  }
}

class _HeaderAvatar extends StatelessWidget {
  const _HeaderAvatar({
    Key? key, required this.avatarUrl,
  }) : super(key: key);

  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      width: 50.w,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: avatarUrl == null || avatarUrl!.trim().isEmpty
          ? SvgPicture.asset(Svgs.defaultUserImage)
          : Image.network(avatarUrl!, fit: BoxFit.cover,),
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle({
    Key? key,
    required this.userName,
    required this.isOnline,
  }) : super(key: key);

  final String userName;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            userName,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: themeColors.mainColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              Text(
                isOnline ? AppLocalizations.of(context)!.active : AppLocalizations.of(context)!.notActive,
                style: TextStyle(
                  color: themeColors.secondTextColor,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                width: 4.w,
              ),
              Container(
                width: 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isOnline
                      ? themeColors.firstPrimaryColor
                      : Colors.grey[700],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class _HeaderCallButtons extends StatelessWidget {
  const _HeaderCallButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    return Row(
      children: [
        SizedBox(
          width: 20.w,
          height: 20.h,
          child: IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              Svgs.phone,
              color: themeColors.mainColor,
            ),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            padding: const EdgeInsets.all(0),
          ),
        ),
        SizedBox(width: 30.w),
        SizedBox(
          width: 20.w,
          height: 20.h,
          child: IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              Svgs.videoPhone,
              color: themeColors.mainColor,
            ),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            padding: const EdgeInsets.all(0),
          ),
        ),
      ],
    );
  }
}
