import 'package:chat_app/domain/cubits/authentification_cubit.dart';
import 'package:chat_app/domain/cubits/theme_colors_cubit.dart';
import 'package:chat_app/ui/navigation/main_navigation.dart';
import 'package:chat_app/ui/widgets/custom_text_button.dart';
import 'package:chat_app/ui/widgets/custom_text_form_field.dart';
import 'package:chat_app/ui/widgets/error_message.dart';
import 'package:chat_app/ui/widgets/gradient_button.dart';
import 'package:chat_app/ui/widgets/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeColorsCubit>();
    final themeColors = themeColorsCubit.themeColors;

    final authentificationCubit = context.watch<AuthentificationCubit>();
    final loading = authentificationCubit.loading;
    final errorText = authentificationCubit.errorText;

    return loading
        ? const LoadingPage()
        : Scaffold(
            backgroundColor: themeColors.backgroundColor,
            body: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w700,
                              color: themeColors.titleTextColor,
                            ),
                          ),
                          CustomTextButton(
                            text: 'Register',
                            onpressed: () {
                              authentificationCubit.errorTextClean();
                              Navigator.of(context).pushReplacementNamed(
                                  MainNavigationRouteNames.registrationScreen);
                            },
                            color: themeColors.firstPrimaryColor,
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      CustomTextFormField(
                        hintText: 'E-mail',
                        validatorText: 'Please enter your E-mail',
                        controller: emailController,
                        obscureText: false,
                      ),
                      SizedBox(height: 20.h),
                      CustomTextFormField(
                        hintText: 'Password',
                        validatorText: 'Please enter your password',
                        controller: passwordController,
                        obscureText: true,
                      ),
                      SizedBox(height: 20.h),
                      GradientButton(
                        text: 'Sign In',
                        backgroundGradient: themeColors.primaryGradient,
                        onPressed: () {
                          final form = _formKey.currentState;
                          if (!form!.validate()) return;

                          final email = emailController.text;
                          final password = passwordController.text;

                          authentificationCubit.signInWithEmailAndPassword(
                            email,
                            password,
                          );
                        },
                      ),
                      ErrorMessage(
                          errorText: errorText, color: themeColors.errorColor),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
