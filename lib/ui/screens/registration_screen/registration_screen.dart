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

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
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
                            'Registration',
                            style: TextStyle(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w700,
                              color: themeColors.titleTextColor,
                            ),
                          ),
                          CustomTextButton(
                            text: 'Log In',
                            onpressed: () {
                              authentificationCubit.errorTextClean();
                              Navigator.of(context).pushReplacementNamed(
                                  MainNavigationRouteNames.signInScreen);
                            },
                            color: themeColors.firstPrimaryColor,
                          ),
                        ],
                      ),
                      SizedBox(height: 25.h),
                      CustomTextFormField(
                        hintText: 'User name',
                        validatorText: 'Please enter your user name',
                        controller: userNameController,
                        obscureText: false,
                      ),
                      SizedBox(height: 25.h),
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
                        text: 'Register',
                        backgroundGradient: themeColors.primaryGradient,
                        onPressed: () {
                          final form = _formKey.currentState;
                          if (!form!.validate()) return;

                          final userName = userNameController.text;
                          final email = emailController.text;
                          final password = passwordController.text;

                          authentificationCubit.registerWithEmailAndPassword(
                            userName,
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
