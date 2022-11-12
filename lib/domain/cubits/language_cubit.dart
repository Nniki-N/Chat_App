// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chat_app/domain/data_poviders/language_provider.dart';

class LanguageState {
  String? currentLanguage;

  LanguageState({
    required this.currentLanguage,
  });


  LanguageState copyWith({
    String? currentLanguage,
  }) {
    return LanguageState(
      currentLanguage: currentLanguage ?? this.currentLanguage,
    );
  }
}

class LanguageCubit extends Cubit<LanguageState> {
  final _languageProvider = LanguageProvider();

  LanguageCubit()
      : super(LanguageState(
          currentLanguage: null,
        )) {
    _initialize();
  }

  Future<void> _initialize() async {
    emit(state.copyWith(currentLanguage: await _languageProvider.getLanguageCode()));
  }

  Future<void> changeLanguage({required String languageCode}) async {
    if (state.currentLanguage == languageCode) return;

    await _languageProvider.changeLanguage(languageCode: languageCode);
    emit(state.copyWith(currentLanguage: languageCode));
  }
}
