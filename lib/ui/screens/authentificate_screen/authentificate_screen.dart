import 'package:chat_app/domain/cubits/authentification_cubit.dart';
import 'package:chat_app/domain/cubits/theme_cubit.dart';
import 'package:chat_app/ui/screens/authentificate_screen/registration_form.dart';
import 'package:chat_app/ui/screens/authentificate_screen/sign_in_form.dart';
import 'package:chat_app/ui/widgets/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthentificationScreen extends StatefulWidget {
  const AuthentificationScreen({super.key});

  @override
  State<AuthentificationScreen> createState() => _AuthentificationScreenState();
}

class _AuthentificationScreenState extends State<AuthentificationScreen> {
  bool showSignIn = true;

  void toogleForms(bool value) => setState(() => showSignIn = value);

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    final authentificationCubit = context.watch<AuthentificationCubit>();
    final loading = authentificationCubit.loading;

    return loading
        ? const LoadingPage()
        : Scaffold(
            backgroundColor: themeColors.backgroundColor,
            body: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: showSignIn
                    ? SignInForm(onPressed: toogleForms)
                    : RegistrationForm(onPressed: toogleForms),
              ),
            ),
          );
  }
}
