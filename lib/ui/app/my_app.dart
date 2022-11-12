import 'package:chat_app/domain/cubits/account_cubit.dart';
import 'package:chat_app/domain/cubits/auth_cubit.dart';
import 'package:chat_app/domain/cubits/language_cubit.dart';
import 'package:chat_app/domain/cubits/theme_cubit.dart';
import 'package:chat_app/ui/navigation/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final _navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainNavigation = MainNavigation();

    // show ui on all screens in the same way
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => ThemeCubit()),
            BlocProvider(create: (context) => AuthCubit()),
            BlocProvider(create: (context) => AccountCubit()),
            BlocProvider(create: (context) => LanguageCubit()),
          ],
          child: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state == AuthState.signedOut) {
                _navigatorKey.currentState?.popUntil((route) {
                  if (route.settings.name !=
                      MainNavigationRouteNames.authScreen) {
                    _navigatorKey.currentState?.pushNamedAndRemoveUntil(
                        MainNavigationRouteNames.authScreen, (r) => false);
                  }
                  return true;
                });
              } else if (state == AuthState.signedIn) {
                _navigatorKey.currentState?.pushNamedAndRemoveUntil(
                    MainNavigationRouteNames.mainScreen, (r) => false);
              }
            },
            child: BlocBuilder<LanguageCubit, LanguageState>(
              builder: (context, state) {
                final languageCode = state.currentLanguage;

                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    fontFamily: languageCode == 'uk' ? 'OpenSans' : 'Poppins',
                  ),
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  locale: languageCode == null
                      ? const Locale('en')
                      : Locale(languageCode),
                  routes: mainNavigation.routes,
                  onGenerateRoute: mainNavigation.onGenerateRoute,
                  navigatorKey: _navigatorKey,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
