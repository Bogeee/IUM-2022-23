import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proj/views/main/home/components/empty_week.dart';
import 'package:simple_shadow/simple_shadow.dart';

// constants
import 'package:proj/constants.dart';

// models
import 'package:provider/provider.dart';
import 'package:proj/models/notifiers.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeNotifier>(context).isDark;
    Color accent = Provider.of<ThemeNotifier>(context).accentColor;

    // check number of lessons
    int lessonNumber = 0;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding / 2),
          child: Column(
            children: [
              lessonNumber == 0 
                ? EmptyWeek(accent: accent, isDark: isDark)
                // : WeekLessons(accent accent, isDark: isDark),
                : Text('Helo my friendo')
            ],
          )
        ),
      )
    );
  }
}


