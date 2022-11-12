import 'package:chat_app/domain/cubits/chats_cubit.dart';
import 'package:chat_app/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatsScreenSearchField extends StatelessWidget {
  const ChatsScreenSearchField({
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
        hintText: AppLocalizations.of(context)!.searchHere,
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
