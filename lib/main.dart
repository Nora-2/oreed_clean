import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oreed_clean/core/app_shared_prefs.dart';
import 'package:oreed_clean/core/constants.dart';
import 'package:oreed_clean/core/routing/routes.dart';
import 'package:oreed_clean/core/routing/app_router.dart';
import 'package:oreed_clean/core/translation/appTranslationsDelegate.dart';
import 'package:oreed_clean/core/utils/appcolors/app_colors.dart';
import 'package:oreed_clean/features/notification/presentation/pages/notification_services.dart';
import 'package:oreed_clean/injection_container.dart';
import 'package:oreed_clean/networking/firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppSharedPreferences().initSharedPreferencesProp();

  // 🔔 Set the navigator key for immediate notification navigation
  NotificationService.setNavigatorKey(navigatorKey);

  await NotificationService().initNotification();

  // ✅ Crashlytics setup
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
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
      initialRoute: Routes.splash,
      onGenerateRoute: appRouter.generateRoute,

      // 🌍 Localization
      localizationsDelegates: const [
        AppTranslationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ar')],
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
