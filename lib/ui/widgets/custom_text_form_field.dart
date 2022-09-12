import 'package:chat_app/domain/cubits/theme_colors_cubit.dart';
import 'package:chat_app/ui/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    required this.hintText,
    required this.validatorText,
    required this.controller,
    required this.obscureText
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final String validatorText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    final themeColorsCubit = context.watch<ThemeCubit>();
    final themeColors = themeColorsCubit.themeColors;
    final appConstants = AppConstants();

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
        color: themeColors.titleTextColor,
      ),
      cursorColor: themeColors.firstPrimaryColor,
      obscureText: obscureText,
      decoration: appConstants.getTextFieldDecoration(
        themeColors: themeColors,
        hintText: hintText,
      ),
    );
  }
}