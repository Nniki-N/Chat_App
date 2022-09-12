import 'package:chat_app/domain/cubits/theme_colors_cubit.dart';
import 'package:chat_app/resources/resources.dart';
import 'package:chat_app/ui/navigation/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            bottom: BorderSide(color: themeColors.borderColor),
          ),
        ),
        child: Row(
          children: [
            const _HeaaderButtonBack(),
            SizedBox(width: 13.w),
            const _HeaderAvatar(),
            SizedBox(width: 16.w),
            const _HeaderTitle(),
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
        onPressed: () => Navigator.of(context).popAndPushNamed(MainNavigationRouteNames.mainScreen),
        icon: SvgPicture.asset(
          Svgs.arrowLeft,
          color: themeColors.titleTextColor,
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      width: 50.w,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage(Images.image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User name',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: themeColors.titleTextColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              Text(
                'Active Now',
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
                  color: themeColors.firstPrimaryColor,
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
              color: themeColors.titleTextColor,
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
              color: themeColors.titleTextColor,
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
