import 'package:chat_app/ui/screens/chat_screen/chat_screen.dart';
import 'package:chat_app/ui/screens/loader_screen/loader_screen.dart';
import 'package:chat_app/ui/screens/log_in_screen/lod_in_screen.dart';
import 'package:chat_app/ui/screens/main_screen/main_screen.dart';
import 'package:chat_app/ui/screens/registration_screen/registration_screen.dart';
import 'package:flutter/material.dart';

class MainNavigationRouteNames {
  static const loaderScreen = 'loader';

  static const logInScreen = 'logIn';
  static const registrationScreen = 'registration';

  static const mainScreen = '/main';
  static const chatScreen = '/main/chat';
}

class MainNavigation {
  // final initialRoute = MainNavigationRouteNames.mainScreen;

  final routes = <String, Widget Function(BuildContext)>{
    // MainNavigationRouteNames.startPage: (context) => BlocProvider(
    //       create: (context) => StartCubit(context),
    //       child: const StartPage(),
    //     ),
    MainNavigationRouteNames.loaderScreen: (context) => const LoaderScreen(),
    MainNavigationRouteNames.logInScreen: (context) => const LogInScreen(),
    MainNavigationRouteNames.registrationScreen: (context) => const RegistrationScreen(),
    MainNavigationRouteNames.mainScreen: (context) => const MainScreen(),
    MainNavigationRouteNames.chatScreen: (context) => const ChatScreen(),
  };
}
