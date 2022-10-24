import 'package:chat_app/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatItemAvatar extends StatelessWidget {
  const ChatItemAvatar({
    Key? key,
    required this.avatarUrl,
  }) : super(key: key);

  final String? avatarUrl;

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
      child: avatarUrl == null || avatarUrl!.trim().isEmpty
          ? SvgPicture.asset(Svgs.defaultUserImage)
          : Image.network(
              avatarUrl!,
              fit: BoxFit.cover,
            ),
    );
  }
}
