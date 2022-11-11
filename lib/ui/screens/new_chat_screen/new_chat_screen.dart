import 'package:chat_app/domain/cubits/chats_cubit.dart';
import 'package:chat_app/domain/cubits/theme_cubit.dart';
import 'package:chat_app/resources/resources.dart';
import 'package:chat_app/ui/navigation/main_navigation.dart';
import 'package:chat_app/ui/widgets/custom_text_form_field.dart';
import 'package:chat_app/ui/widgets/error_message.dart';
import 'package:chat_app/ui/widgets/gradient_button.dart';
import 'package:chat_app/ui/widgets/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewChatScreen extends StatefulWidget {
  const NewChatScreen({super.key});

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  final _formKey = GlobalKey<FormState>();

  final userLoginController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    final chatsCubit = context.watch<ChatsCubit>();
    final loading = chatsCubit.loading;
    final errorTextStream = chatsCubit.errorTextStream;

    return Scaffold(
      backgroundColor: themeColors.backgroundColor,
      body: Stack(
        children: [
          StreamBuilder(
              stream: errorTextStream,
              builder: (context, snapshot) {
                final errorText = chatsCubit.errorText;

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
                            'Create new chat',
                            style: TextStyle(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w700,
                              color: themeColors.mainColor,
                            ),
                          ),
                          SizedBox(height: 25.h),
                          CustomTextFormField(
                            hintText: 'User Login',
                            validatorText: 'Please enter user Login',
                            controller: userLoginController,
                            obscureText: false,
                            prefixText: '@ ',
                          ),
                          SizedBox(height: 20.h),
                          GradientButton(
                            text: 'Create',
                            backgroundGradient: themeColors.primaryGradient,
                            onPressed: () {
                              final form = _formKey.currentState;
                              if (!form!.validate()) return;

                              final userLogin = '@${userLoginController.text}';

                              chatsCubit
                                  .createNewChat(userLogin: userLogin)
                                  .then((successful) {
                                if (successful) {
                                  Navigator.of(context).pop(
                                    MainNavigationRouteNames.mainScreen,
                                  );
                                }
                              });
                            },
                          ),
                          ErrorMessage(
                              errorText: errorText,
                              color: themeColors.redColor),
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
