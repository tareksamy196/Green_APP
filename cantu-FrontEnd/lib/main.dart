import 'package:cantu/core/providers/LocalProvider.dart';
import 'package:cantu/core/services/services.dart';
import 'package:cantu/data/ApiService.dart';
import 'package:cantu/ui/MainBottomBar.dart';
import 'package:cantu/ui/SplashScreen.dart';
import 'package:cantu/ui/admin.dart';
import 'package:cantu/ui/auth/login.dart';
import 'package:cantu/ui/auth/signup.dart';
import 'package:cantu/ui/onboarding/language.dart';
import 'package:cantu/ui/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'I18n.dart';
import 'core/constant/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ApiService apiService = ApiService();
  await initialServices();
  await apiService.initApp();
  runApp(
      ChangeNotifierProvider(
        create: (_) =>LocaleProvider(),
        child: const MyApp(),
      ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: localeProvider.locale,
            localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('ar'), // arabic
          ],
          initialRoute: AppRoute.splash,
          title: "Cantu",
          routes: {
            AppRoute.splash: (context) =>const SplashScreen(),
            AppRoute.onBoarding: (context) => const OnBoarding(),
            AppRoute.language: (context) => const Language(),
            AppRoute.login: (context) => const Login(),
            AppRoute.signUp: (context) => const Signup(),
            AppRoute.home: (context) => const MainNavigation(),
            AppRoute.admin: (context) => const ProductDashboard()
          },
          theme: ThemeData(useMaterial3: true),
          );
          },
    );
  }

}
 