import 'package:flutter/material.dart';
import 'package:proj/light_theme.dart';
import 'package:proj/dark_theme.dart';

import 'package:proj/models/notifiers.dart';
import 'package:proj/views/provider_test/prov_test.dart';
import 'package:provider/provider.dart';

void main() {
  // To access multiple providers we must nest them
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(true), 
      child: ChangeNotifierProvider(
        create: (context) => LoggedInNotifier("saved_user"),
        // The ThemeNotifiers and LoggedInNotifier can be accessed
        // by any Widget inside MyApp()
        child: const MyApp(),
      )
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    bool isDark = Provider.of<ThemeNotifier>(context).isDark;

    return MaterialApp(
      title: 'Ripetizioni',
      theme: isDark ? darkTheme : lightTheme,
      home: const FirstView(),
      initialRoute: '/first',
      routes: {
        '/first': (context) => const FirstView(),
        '/second': (context) => const SecondView()
      },
    );
  }
}
