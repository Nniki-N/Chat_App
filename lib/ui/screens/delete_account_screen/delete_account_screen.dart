import 'package:chat_app/domain/cubits/account_cubit.dart';
import 'package:chat_app/domain/cubits/theme_cubit.dart';
import 'package:chat_app/resources/resources.dart';
import 'package:chat_app/ui/widgets/custom_text_form_field.dart';
import 'package:chat_app/ui/widgets/error_message.dart';
import 'package:chat_app/ui/widgets/gradient_button.dart';
import 'package:chat_app/ui/widgets/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  final userEmailController = TextEditingController();
  final userPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    final accountCubit = context.watch<AccountCubit>();
    final errorTextStream = accountCubit.errorTextStream;
    final loading = accountCubit.loading;

    return Scaffold(
      backgroundColor: themeColors.backgroundColor,
      body: Stack(
        children: [
          StreamBuilder(
              stream: errorTextStream,
              builder: (context, snapshot) {
                final errorText = accountCubit.errorText;

                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delete account',
                            style: TextStyle(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w700,
                              color: themeColors.mainColor,
                            ),
                          ),
                          SizedBox(height: 25.h),
                          CustomTextFormField(
                            hintText: 'Your email',
                            validatorText: 'Please enter your email',
                            controller: userEmailController,
                            obscureText: false,
                          ),
                          SizedBox(height: 25.h),
                          CustomTextFormField(
                            hintText: 'Your password',
                            validatorText: 'Please enter your password',
                            controller: userPasswordController,
                            obscureText: true,
                          ),
                          SizedBox(height: 20.h),
                          GradientButton(
                            text: 'Delete',
                            backgroundGradient: themeColors.primaryGradient,
                            onPressed: () async {
                              final form = _formKey.currentState;
                              if (!form!.validate()) return;

                              final userEmail = userEmailController.text;
                              final userPassword = userPasswordController.text;
                              accountCubit.deleteUserWithEmailAndPassword(
                                  userEmail: userEmail,
                                  userPassword: userPassword);
                            },
                          ),
                          ErrorMessage(
                              errorText: errorText,
                              color: themeColors.errorColor),
                        ],
                      ),
                    ),
                  ),
                );
              }),
          Positioned(
            top: 45.h,
            right: 16.w,
            child: SizedBox(
              height: 20.w,
              width: 20.w,
              child: IconButton(
                onPressed: () {
                  accountCubit.errorTextClean();
                  Navigator.of(context).pop();
                },
                icon: SvgPicture.asset(
                  Svgs.cross,
                  color: themeColors.mainColor,
                ),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                padding: const EdgeInsets.all(0),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: loading ? const LoadingPage() : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
