import 'package:chat_app/domain/cubits/chats_cubit.dart';
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

class NewChatScreen extends StatefulWidget {
  const NewChatScreen({super.key});

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    final chatsCubit = context.watch<ChatsCubit>();
    final loading = chatsCubit.loading;

    return loading ? const LoadingPage() : Scaffold(
      backgroundColor: themeColors.backgroundColor,
      body: Stack(
        children: [
          Center(
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
                        color: themeColors.titleTextColor,
                      ),
                    ),
                    SizedBox(height: 25.h),
                    CustomTextFormField(
                      hintText: 'User E-mail',
                      validatorText: 'Please enter user E-mail',
                      controller: emailController,
                      obscureText: false,
                    ),
                    SizedBox(height: 20.h),
                    GradientButton(
                      text: 'Create',
                      backgroundGradient: themeColors.primaryGradient,
                      onPressed: () async {
                        final form = _formKey.currentState;
                        if (!form!.validate()) return;

                        final email = emailController.text;

                        await chatsCubit.createNewChat(userEmail: email);
                        
                        if (chatsCubit.errorText.isEmpty) Navigator.of(context).pop();
                      },
                    ),
                    ErrorMessage(
                        errorText: chatsCubit.errorText, color: themeColors.errorColor),
                  ],
                ),
              ),
            ),
          ),
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
                    color: themeColors.titleTextColor,
                  ),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  padding: const EdgeInsets.all(0),
                ),
              ),
          ),
        ],
      ),
    );
  }
}
