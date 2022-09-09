import 'package:chat_app/ui/screens/chat_screen/chat_screen.dart';
import 'package:chat_app/ui/screens/log_in_screen/sign_in_screen.dart';
import 'package:chat_app/ui/screens/main_screen/main_screen.dart';
import 'package:chat_app/ui/screens/registration_screen/registration_screen.dart';
import 'package:flutter/material.dart';

class MainNavigationRouteNames {

  static const signInScreen = 'signIn';
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
    MainNavigationRouteNames.signInScreen: (context) => const SignInScreen(),
    MainNavigationRouteNames.registrationScreen: (context) => const RegistrationScreen(),
    MainNavigationRouteNames.mainScreen: (context) => const MainScreen(),
    MainNavigationRouteNames.chatScreen: (context) => const ChatScreen(),
  };
}
