import 'package:chat_app/ui/utils/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeColorsCubit extends Cubit<bool> {
  late AppThemeColors themeColors;

  ThemeColorsCubit() : super(true) {
    _initialize();
  }

  Future<void> _initialize() async {
    themeColors = state ? LightThemeColors() : DarkThemeColors();
  }

  void switchTheme() {
    emit(!state);
    themeColors = state ? LightThemeColors() : DarkThemeColors();
  }

}