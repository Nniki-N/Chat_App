import 'package:chat_app/domain/cubits/authentification_cubit.dart';
import 'package:chat_app/ui/screens/log_in_screen/sign_in_screen.dart';
import 'package:chat_app/ui/screens/main_screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authentificationCubit = context.watch<AuthentificationCubit>();
    final isLogedIn = authentificationCubit.isLogedIn;

    if (isLogedIn) {
      return const MainScreen();
    }

    return const SignInScreen();
  }
}
