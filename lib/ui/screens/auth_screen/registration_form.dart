import 'package:chat_app/domain/cubits/auth_cubit.dart';
import 'package:chat_app/domain/cubits/theme_cubit.dart';
import 'package:chat_app/ui/widgets/custom_text_button.dart';
import 'package:chat_app/ui/widgets/custom_text_form_field.dart';
import 'package:chat_app/ui/widgets/error_message.dart';
import 'package:chat_app/ui/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key, required this.onPressed});
  final void Function(bool) onPressed;

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    final authCubit = context.read<AuthCubit>();
    final errorTextStream = authCubit.errorTextStream;

    return StreamBuilder(
      stream: errorTextStream,
      builder: (context, snapsot) {
        final errorText = authCubit.errorText;

        return Form(
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
                    text: 'Sign In',
                    onpressed: () {
                      authCubit.errorTextClean();
                      widget.onPressed(true);
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

                  authCubit.registerWithEmailAndPassword(
                    userName: userName,
                    email: email,
                    password: password,
                  );
                },
              ),
              ErrorMessage(errorText: errorText, color: themeColors.errorColor),
            ],
          ),
        );
      },
    );
  }
}