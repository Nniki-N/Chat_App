import 'package:chat_app/domain/cubits/account_cubit.dart';
import 'package:chat_app/domain/cubits/theme_cubit.dart';
import 'package:chat_app/domain/entity/user_model.dart';
import 'package:chat_app/resources/resources.dart';
import 'package:chat_app/ui/widgets/custom_text_button.dart';
import 'package:chat_app/ui/widgets/error_message.dart';
import 'package:chat_app/ui/widgets/gradient_button.dart';
import 'package:chat_app/ui/widgets/settings_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangeProfileConfiguration {
  final UserModel currentUserModel;

  ChangeProfileConfiguration({required this.currentUserModel});
}

class ChangeProfileScreen extends StatefulWidget {
  const ChangeProfileScreen({
    Key? key,
    required this.currentUserModel,
  }) : super(key: key);

  final UserModel currentUserModel;

  @override
  State<ChangeProfileScreen> createState() => _ChangeProfileScreenState();
}

class _ChangeProfileScreenState extends State<ChangeProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController userNameController;
  late TextEditingController userLoginController;

  @override
  void didChangeDependencies() {
    userNameController =
        TextEditingController(text: widget.currentUserModel.userName);
    userLoginController = TextEditingController(
        text: widget.currentUserModel.userLogin.substring(1));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    final accountCubit = context.watch<AccountCubit>();
    final accountErrorTextStream = accountCubit.errorTextStream;

    return Scaffold(
      backgroundColor: themeColors.backgroundColor,
      body: Padding(
        padding: EdgeInsets.only(left: 17.w, top: 50.h, right: 17.w),
        child: Stack(
          children: [
            StreamBuilder<Object>(
                stream: accountErrorTextStream,
                builder: (context, snapshot) {
                  final String errorText = accountCubit.errorText;

                  return Column(
                    children: [
                      const _UserAvatar(),
                      SizedBox(height: 15.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextButton(
                            color: themeColors.firstPrimaryColor,
                            text: AppLocalizations.of(context)!.setNewPhoto,
                            onpressed: () {
                              accountCubit.setUserAvatar();
                            },
                          ),
                          SizedBox(width: 15.w),
                          CustomTextButton(
                            color: themeColors.redColor.withOpacity(0.6),
                            text: AppLocalizations.of(context)!.deletePhoto,
                            onpressed: () {
                              accountCubit.deleteUserAvatar();
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      _ProfileSettingsBlock(
                          formKey: _formKey,
                          userNameController: userNameController,
                          userLoginController: userLoginController),
                      SizedBox(height: 30.h),
                      GradientButton(
                        text: AppLocalizations.of(context)!.updateProfile,
                        backgroundGradient: themeColors.primaryGradient,
                        onPressed: () {
                          final form = _formKey.currentState;
                          if (!form!.validate()) return;

                          final userName = userNameController.text;
                          final userLogin = '@${userLoginController.text}';

                          accountCubit
                              .updateProfile(
                                  userName: userName, userLogin: userLogin)
                              .then((successful) {
                            if (successful) {
                              Navigator.of(context).pop();
                            }
                          });
                        },
                      ),
                      ErrorMessage(
                          errorText: errorText, color: themeColors.redColor),
                    ],
                  );
                }),
            Positioned(
              top: 0,
              right: 0,
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
          ],
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubit, AccountState>(builder: (context, state) {
      final userAvatar = state.userAvatar;

      return Container(
        width: 120.w,
        height: 120.h,
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: userAvatar == null
            ? SvgPicture.asset(Svgs.defaultUserImage)
            : Image.memory(
                userAvatar,
                fit: BoxFit.cover,
              ),
      );
    });
  }
}

class _ProfileSettingsBlock extends StatelessWidget {
  const _ProfileSettingsBlock({
    Key? key,
    required this.userNameController,
    required this.userLoginController,
    required this.formKey,
  }) : super(key: key);

  final Key formKey;
  final TextEditingController userNameController;
  final TextEditingController userLoginController;

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;

    return Form(
      key: formKey,
      child: Container(
        decoration: BoxDecoration(
          color: themeColors.sendMessageFieldBackgroundColor,
          borderRadius: BorderRadius.circular(7.h),
        ),
        child: Column(
          children: [
            _ProfileSettingsTextField(
              controller: userNameController,
              hintText: 'User Name',
              validatorText: 'sdf',
              obscureText: false,
            ),
            SettingsDivider(color: themeColors.settingsDividerColor),
            _ProfileSettingsTextField(
              controller: userLoginController,
              hintText: 'Login',
              validatorText: 'sdf',
              obscureText: false,
              prefixText: '@ ',
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSettingsTextField extends StatelessWidget {
  const _ProfileSettingsTextField(
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.validatorText,
      required this.obscureText,
      this.prefixText = ''})
      : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final String validatorText;
  final bool obscureText;
  final String prefixText;

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;
    return TextFormField(
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return validatorText;
        }
        return null;
      },
      controller: controller,
      autocorrect: false,
      enableSuggestions: false,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        color: themeColors.mainColor,
      ),
      cursorColor: themeColors.firstPrimaryColor,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: themeColors.settingsItemContentColor,
          fontSize: 14.sp,
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 17.w),
          child: Text(
            prefixText,
            style: TextStyle(
              color: themeColors.secondTextColor,
              fontSize: 14.sp,
            ),
          ),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 20.w, minHeight: 0),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 0),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 0),
        ),
      ),
    );
  }
}
