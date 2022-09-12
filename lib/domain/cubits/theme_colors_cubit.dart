import 'package:chat_app/ui/utils/app_colors.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<bool> {
  late AppThemeColors themeColors;

  ThemeCubit() : super(true) {
    themeColors = state ? LightThemeColors() : DarkThemeColors();
  }

  Future<void> toggleTheme() async {
    emit(!state);
    themeColors = state ? LightThemeColors() : DarkThemeColors();
  }

  // read data from storage
  @override
  bool? fromJson(Map<String, dynamic> json) {
    return json['theme'];
  }

  // write data to storage
  @override
  Map<String, dynamic>? toJson(bool state) {
    return <String, bool>{
      'theme': state,
    };
  }
}
