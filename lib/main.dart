import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oreed_clean/core/constants.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/routing/app_router.dart';
import 'package:oreed_clean/core/translation/appTranslationsDelegate.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/injection_container.dart';

void main() async{
    WidgetsFlutterBinding.ensureInitialized(); // Required for async init
  await init(); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AppRouter appRouter = AppRouter();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.login,
      onGenerateRoute: appRouter.generateRoute,

      // 🌍 Localization
      localizationsDelegates: const [
        AppTranslationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      locale: const Locale('ar'), 

      builder: (context, child) {
        final locale = Localizations.localeOf(context);

        return Directionality(
          textDirection: locale.languageCode == 'ar'
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: child!,
        );
      },

      theme: ThemeData(
        fontFamily: Constants.fontFamily,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primary,
        ),
      ),
    );
  }
}
