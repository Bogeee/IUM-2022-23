// dependencies
import 'package:flutter/material.dart';

// constants, themes and utilities
import 'package:proj/light_theme.dart';
import 'package:proj/dark_theme.dart';

// models
import 'package:provider/provider.dart';
import 'package:proj/models/notifiers.dart';
import 'package:proj/models/build_db.dart';

// views
import 'package:proj/views/onboarding/onboarding.dart';
import 'package:proj/views/login/login.dart';
import 'package:proj/views/register/register.dart';
import 'package:proj/views/init.dart';
import 'package:proj/views/main/main_screen.dart';

void main() async 
{
  // To access multiple providers we must nest them
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(false), 
      child: ChangeNotifierProvider(
        create: (context) => LoggedInNotifier(),
        // The ThemeNotifiers and LoggedInNotifier can be accessed
        // by any Widget inside MyApp()
        child: const MyApp()
      )
    )
  );

  // Create the DB at startup
  createDB();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    bool isDark = Provider.of<ThemeNotifier>(context).isDark;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ripetizioni',
      theme: isDark ? darkTheme : lightTheme,
      home: const OnboardingPage(),
      initialRoute: '/main',
      routes: {
        '/init': (context) => const InitView(),
        '/onboarding': (context) => const OnboardingPage(),
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
        '/main': (context) => const MainScreen(),
      },
    );
  }
}
