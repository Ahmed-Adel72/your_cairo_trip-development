// lib/main.dart

import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/di/service_locator.dart';
import 'core/storage/token_manager.dart';
import 'core/navigation/main_navigation_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── easy_localization init ──
  await EasyLocalization.ensureInitialized();

  // ── get_it init ──
  setupServiceLocator();

  // ── Check Token ──
  final token = await TokenManager.getToken();
  final isLoggedIn = token != null && token.isNotEmpty;

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Cairo Trip',

          // ── easy_localization ──
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,

          // ── الاتجاه بيتغير تلقائي حسب اللغة ──
          builder: (context, child) {
            return Directionality(
              textDirection: context.locale.languageCode == 'ar'
                  ? ui.TextDirection.rtl
                  : ui.TextDirection.ltr,
              child: child!,
            );
          },

          // ── Home: حسب حالة اللوجين ──
          home: isLoggedIn ? const MainNavigationScreen() : const LoginScreen(),
        );
      },
    );
  }
}
