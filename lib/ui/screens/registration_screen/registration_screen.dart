import 'package:chat_app/domain/cubits/theme_colors_cubit.dart';
import 'package:chat_app/ui/navigation/main_navigation.dart';
import 'package:chat_app/ui/utils/app_constants.dart';
import 'package:chat_app/ui/widgets/custom_text_button.dart';
import 'package:chat_app/ui/widgets/gradient_button.dart';
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

  void onPressed() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      print('Form is valid');
    } else {
      print('Form is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeColorsCubit>();
    final themeColors = themeColorsCubit.themeColors;
    final appConstants = AppConstants();

    return Scaffold(
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
                      onpressed: () => Navigator.of(context)
                          .pushReplacementNamed(
                              MainNavigationRouteNames.logInScreen),
                      color: themeColors.firstPrimaryColor,
                    ),
                  ],
                ),
                SizedBox(height: 25.h),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  autocorrect: false,
                  enableSuggestions: false,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: themeColors.firstPrimaryColor,
                  decoration: appConstants.getTextFieldDecoration(
                    themeColors: themeColors,
                    hintText: 'Phone number',
                  ),
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  autocorrect: false,
                  enableSuggestions: false,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: themeColors.firstPrimaryColor,
                  obscureText: true,
                  decoration: appConstants.getTextFieldDecoration(
                    themeColors: themeColors,
                    hintText: 'Password',
                  ),
                ),
                SizedBox(height: 20.h),
                GradientButton(
                  text: 'Register',
                  backgroundGradient: themeColors.primaryGradient,
                  onPressed: onPressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
