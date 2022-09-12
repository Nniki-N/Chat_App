import 'package:chat_app/ui/screens/authentificate_screen/authentificate_screen.dart';
import 'package:chat_app/ui/screens/chat_screen/chat_screen.dart';
import 'package:chat_app/ui/screens/main_screen/main_screen.dart';
import 'package:flutter/material.dart';

class MainNavigationRouteNames {
  static const authentificationScreen = 'authentification';
  static const mainScreen = '/main';
  static const chatScreen = '/main/chat';
}

class MainNavigation {
  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRouteNames.authentificationScreen: (context) => const AuthentificationScreen(),
    MainNavigationRouteNames.mainScreen: (context) => const MainScreen(),
    MainNavigationRouteNames.chatScreen: (context) => const ChatScreen(),
  };
}
