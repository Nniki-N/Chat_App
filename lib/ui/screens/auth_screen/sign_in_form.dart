import 'package:chat_app/domain/cubits/account_cubit.dart';
import 'package:chat_app/domain/cubits/auth_cubit.dart';
import 'package:chat_app/domain/cubits/theme_cubit.dart';
import 'package:chat_app/ui/widgets/custom_text_button.dart';
import 'package:chat_app/ui/widgets/custom_text_form_field.dart';
import 'package:chat_app/ui/widgets/error_message.dart';
import 'package:chat_app/ui/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key, required this.onPressed});
  final void Function(bool) onPressed;

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final emailOrLoginController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;
    
    final authCubit = context.read<AuthCubit>();
    final errorTextStream = authCubit.errorTextStream;

    final accountCubit = context.read<AccountCubit>();

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
                    AppLocalizations.of(context)!.signIn,
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w700,
                      color: themeColors.mainColor,
                    ),
                  ),
                  CustomTextButton(
                    text: AppLocalizations.of(context)!.register,
                    onpressed: () {
                      authCubit.errorTextClean();
                      widget.onPressed(false);
                      authCubit.changeShowSignIn(showSignIn: false);
                    },
                    color: themeColors.firstPrimaryColor,
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              CustomTextFormField(
                hintText: AppLocalizations.of(context)!.emailOrLogin,
                validatorText: AppLocalizations.of(context)!.pleaseEnterYourEmailOrLogin,
                controller: emailOrLoginController,
                obscureText: false,
              ),
              SizedBox(height: 20.h),
              CustomTextFormField(
                hintText: AppLocalizations.of(context)!.password,
                validatorText: AppLocalizations.of(context)!.pleaseEnterYourPassword,
                controller: passwordController,
                obscureText: true,
              ),
              SizedBox(height: 20.h),
              GradientButton(
                text: AppLocalizations.of(context)!.signIn,
                backgroundGradient: themeColors.primaryGradient,
                onPressed: () {
                  final form = _formKey.currentState;
                  if (!form!.validate()) return;

                  final emailOrLogin = emailOrLoginController.text;
                  final password = passwordController.text;

                  authCubit.signInWithEmailAndPassword(
                    emailOrLogin: emailOrLogin,
                    password: password,
                  ).then(
                    (successful) {
                      if (successful) {
                        accountCubit.setNewCurrentUser(isSignedIn: true);
                      }
                    },
                  );
                },
              ),
              ErrorMessage(errorText: errorText, color: themeColors.redColor),
            ],
          ),
        );
      },
    );
  }
}
