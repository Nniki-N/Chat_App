import 'package:chat_app/domain/cubits/auth_cubit.dart';
import 'package:chat_app/domain/cubits/theme_cubit.dart';
import 'package:chat_app/ui/screens/auth_screen/registration_form.dart';
import 'package:chat_app/ui/screens/auth_screen/sign_in_form.dart';
import 'package:chat_app/ui/widgets/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool showSignIn = true;

  void toogleForms(bool value) => setState(() => showSignIn = value);

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    return Builder(
      builder: (context) {
        final authCubit = context.watch<AuthCubit>();
        bool loading = authCubit.loading;

        return loading ? const LoadingPage() : Scaffold(
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
    );
  }
}
