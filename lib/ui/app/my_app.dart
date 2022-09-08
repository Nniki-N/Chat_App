import 'package:chat_app/domain/cubits/theme_colors_cubit.dart';
import 'package:chat_app/ui/navigation/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainNavigation = MainNavigation();
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider(
          create: (context) => ThemeColorsCubit(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: 'Poppins'),
            routes: mainNavigation.routes,
            initialRoute: MainNavigationRouteNames.mainScreen,
          ),
        );
      },
    );
  }
}
