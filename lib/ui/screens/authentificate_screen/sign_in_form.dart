import 'package:chat_app/domain/cubits/authentification_cubit.dart';
import 'package:chat_app/domain/cubits/theme_cubit.dart';
import 'package:chat_app/ui/widgets/custom_text_button.dart';
import 'package:chat_app/ui/widgets/custom_text_form_field.dart';
import 'package:chat_app/ui/widgets/error_message.dart';
import 'package:chat_app/ui/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key, required this.onPressed});
  final void Function(bool) onPressed;

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    final authentificationCubit = context.watch<AuthentificationCubit>();
    final errorText = authentificationCubit.errorText;

    return Form(
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
                  widget.onPressed(false);
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
          ErrorMessage(errorText: errorText, color: themeColors.errorColor),
        ],
      ),
    );
  }
}
