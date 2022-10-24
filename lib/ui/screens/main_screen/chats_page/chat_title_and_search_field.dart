import 'package:chat_app/domain/cubits/theme_cubit.dart';
import 'package:chat_app/resources/resources.dart';
import 'package:chat_app/ui/navigation/main_navigation.dart';
import 'package:chat_app/ui/screens/main_screen/chats_page/chats_screen_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatsTitleAndSearchField extends StatelessWidget {
  const ChatsTitleAndSearchField({Key? key}) : super(key: key);

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
                  color: themeColors.mainColor,
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
                    color: themeColors.mainColor,
                  ),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  padding: const EdgeInsets.all(0),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          ChatsScreenSearchField(
            cursorColor: themeColors.firstPrimaryColor,
            borderColor: themeColors.searchFieldBorderColor,
            textColor: themeColors.mainColor,
          ),
        ],
      ),
    );
  }
}