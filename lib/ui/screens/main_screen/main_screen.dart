import 'package:chat_app/domain/cubits/chats_cubit.dart';
import 'package:chat_app/domain/cubits/theme_cubit.dart';
import 'package:chat_app/resources/resources.dart';
import 'package:chat_app/ui/screens/main_screen/chats_page/chats_page.dart';
import 'package:chat_app/ui/screens/main_screen/settings_page/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    return Scaffold(
            backgroundColor: themeColors.backgroundColor,
            body: IndexedStack(
              index: _currentIndex,
              children: [
                const Center(child: Text('Contacts')),
                BlocProvider(
                  create: (context) => ChatsCubit(),
                  child: const ChatsPage(),
                ),
                const Center(child: Text('Camera')),
                const SettingsPage(),
              ],
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: themeColors.backgroundColor,
                border: Border(top: BorderSide(color: themeColors.borderColor)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _bottomNavigationBarItem(svgPath: Svgs.person, index: 0),
                  _bottomNavigationBarItem(svgPath: Svgs.people, index: 1),
                  _bottomNavigationBarItem(svgPath: Svgs.camera, index: 2),
                  _bottomNavigationBarItem(svgPath: Svgs.settings, index: 3),
                ],
              ),
            ),
          );
  }

  GestureDetector _bottomNavigationBarItem(
      {required String svgPath, required int index}) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: EdgeInsets.only(top: 22.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              svgPath,
              color:
                  index == _currentIndex ? themeColors.firstPrimaryColor : null,
            ),
            SizedBox(height: 15.h),
            Container(
              width: 77.w,
              height: 5.h,
              decoration: BoxDecoration(
                gradient:
                    index == _currentIndex ? themeColors.primaryGradient : null,
              ),
            )
          ],
        ),
      ),
    );
  }
}
