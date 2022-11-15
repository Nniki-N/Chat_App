import 'package:chat_app/domain/cubits/camera_cubit.dart';
import 'package:chat_app/domain/cubits/chat_cubit.dart';
import 'package:chat_app/domain/cubits/chats_cubit.dart';
import 'package:chat_app/domain/cubits/internet_connection_cubit.dart';
import 'package:chat_app/domain/entity/chat_configuration.dart';
import 'package:chat_app/ui/screens/auth_screen/auth_screen.dart';
import 'package:chat_app/ui/screens/change_language_screen/change_language_sreen.dart';
import 'package:chat_app/ui/screens/change_profile_screen/change_profile_screen.dart';
import 'package:chat_app/ui/screens/chat_screen/chat_screen.dart';
import 'package:chat_app/ui/screens/delete_account_screen/delete_account_screen.dart';
import 'package:chat_app/ui/screens/loading_screen/loading_screen.dart';
import 'package:chat_app/ui/screens/main_screen/camera_page/camera_page.dart';
import 'package:chat_app/ui/screens/main_screen/main_screen.dart';
import 'package:chat_app/ui/screens/new_chat_screen/new_chat_screen.dart';
import 'package:chat_app/ui/screens/no_internet_connection_screen/no_internet_connection_screen.dart';
import 'package:chat_app/ui/screens/non_existent_screen/non_existent_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainNavigationRouteNames {
  static const initialScreen = '/';
  static const noInternetConnectionScreen = '/noInternetConnection';
  static const authScreen = '/auth';
  static const mainScreen = '/main';
  static const newChatScreen = '/main/newChat';
  static const chatScreen = '/main/chat';
  static const cameraScreen = '/main/camera';
  static const deleteAccountScreen = '/main/deleteAccount';
  static const changeProfileScreen = '/main/changeProfile';
  static const changeLanguageScreen = '/main/changeLanguage';
}

class MainNavigation {
  final routes = <String, Widget Function(BuildContext)>{
    // MainNavigationRouteNames.authScreen: (context) => const AuthScreen(),
    // MainNavigationRouteNames.newChatScreen: (context) => BlocProvider(
    //       create: (context) => ChatsCubit(),
    //       child: const NewChatScreen(),
    //     ),
    // MainNavigationRouteNames.cameraScreen: (context) => MultiBlocProvider(
    //       providers: [
    //         BlocProvider(create: (context) => ChatsCubit()),
    //         BlocProvider(create: (context) => CameraCubit()),
    //       ],
    //       child: const CameraPage(),
    //     ),
    // MainNavigationRouteNames.deleteAccountScreen: (context) =>
    //     const DeleteAccountScreen(),
    // MainNavigationRouteNames.changeLanguageScreen: (context) =>
    //     const ChangeLanguageScreen(),
  };

  Route<Object>? onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) {
        final internetConnectionCubit =
            context.watch<InternetConnectionCubit>();

        // shoe if internet connection absents
        if (internetConnectionCubit.connectionStatus == false) {
          return const NoInernetConnectionScreen();
        }

        // all another routes
        switch (settings.name) {
          case MainNavigationRouteNames.initialScreen:
            return const LoadingScrenn();
          case MainNavigationRouteNames.authScreen:
            return const AuthScreen();
          case MainNavigationRouteNames.mainScreen:
            final index = settings.arguments as int?;

            return MainScreen(index: index);
          case MainNavigationRouteNames.chatScreen:
            final configuration = settings.arguments as ChatConfiguration;

            return BlocProvider(
              create: (context) => ChatCubit(
                chatModel: configuration.chat,
                imageToSend: configuration.imageToSend,
              ),
              child: const ChatScreen(),
            );
          case MainNavigationRouteNames.newChatScreen:
            return BlocProvider(
              create: (context) => ChatsCubit(),
              child: const NewChatScreen(),
            );
          case MainNavigationRouteNames.cameraScreen:
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => ChatsCubit()),
                BlocProvider(create: (context) => CameraCubit()),
              ],
              child: const CameraPage(),
            );
          case MainNavigationRouteNames.deleteAccountScreen:
            return const DeleteAccountScreen();
          case MainNavigationRouteNames.changeLanguageScreen:
            return const ChangeLanguageScreen();
          case MainNavigationRouteNames.changeProfileScreen:
            final configuration =
                settings.arguments as ChangeProfileConfiguration;

            return ChangeProfileScreen(
                currentUserModel: configuration.currentUserModel);
          default:
            return const NonExistentScreen();
        }
      },
    );

    //   switch (settings.name) {
    //     case MainNavigationRouteNames.initialScreen:
    //       return MaterialPageRoute(builder: (context) => const LoadingScrenn());
    //     case MainNavigationRouteNames.mainScreen:
    //       final index = settings.arguments as int?;
    //
    //       return MaterialPageRoute(
    //           builder: (context) => MainScreen(index: index));
    //     case MainNavigationRouteNames.chatScreen:
    //       final configuration = settings.arguments as ChatConfiguration;
    //
    //       return MaterialPageRoute(
    //         builder: (context) => BlocProvider(
    //           create: (context) => ChatCubit(
    //             chatModel: configuration.chat,
    //             imageToSend: configuration.imageToSend,
    //           ),
    //           child: const ChatScreen(),
    //         ),
    //       );
    //     case MainNavigationRouteNames.changeProfileScreen:
    //       final configuration = settings.arguments as ChangeProfileConfiguration;
    //
    //       return MaterialPageRoute(
    //         builder: (context) => ChangeProfileScreen(
    //             currentUserModel: configuration.currentUserModel),
    //       );
    //     default:
    //       return MaterialPageRoute(
    //           builder: (context) => const NonExistentScreen());
    //   }
    // }
  }
}
