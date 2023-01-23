import 'package:flutter/material.dart';

// constants
import 'package:proj/constants.dart';

// models
import 'package:provider/provider.dart';
import 'package:proj/models/notifiers.dart';
import 'package:proj/models/ripetizioni.dart';

// views
import 'package:proj/views/main/home/components/empty_week.dart';
import 'package:proj/views/main/home/components/no_planned_lessons.dart';
import 'package:proj/views/main/home/components/planned_lessons.dart';
import 'package:proj/views/main/home/components/titles.dart';
import 'package:proj/views/main/home/components/weekly_lessons.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({
    super.key,
    required this.changePageCallback
  });

  final VoidCallback changePageCallback;

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  List<LezioniSettimanali> lessonsEachDay = [];
  List<Ripetizione> lessonsToday = [];
  List<Ripetizione> nextLessons = [];

  bool _checked = false;

  Future<void> _homeFuture(int studentID) async{
    if(!_checked){
      lessonsEachDay = await getWeeklyLessons(studentID);
      lessonsToday = await getTodaysLessons(studentID);
      nextLessons = await getNextLessons(studentID);
      setState(() {
        _checked = true;
      });
    }
  }

  void _refreshUI(){
    setState(() {
      _checked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int studentID = Provider.of<LoggedInNotifier>(context).userId;
    bool isDark = Provider.of<ThemeNotifier>(context).isDark;
    Color accent = Provider.of<ThemeNotifier>(context).accentColor;

    return FutureBuilder(
      future: _homeFuture(studentID),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(_checked){
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding / 2),
                child: Column(
                  children: [
                    lessonsEachDay.isEmpty 
                      ? EmptyWeek(accent: accent, isDark: isDark)
                      : WeekLessons(accent: accent, isDark: isDark, lessonList: lessonsEachDay),
                    const SizedBox(height: defaultPadding),
                    const TodayTitle(),
                    const SizedBox(height: 0.4*defaultPadding),
                    lessonsToday.isEmpty
                      ? NoPlannedLessons(
                          accent: accent, 
                          isDark: isDark,
                          changePageCallback: widget.changePageCallback,
                        )
                      : PlannedLessons(
                          accent: accent, 
                          isDark: isDark, 
                          lessonList: lessonsToday, 
                          refreshUICallback: _refreshUI,
                          changePageCallback: widget.changePageCallback
                        ),
                    const SizedBox(height: defaultPadding),
                    const NextLessonsTitle(),
                    const SizedBox(height: 0.4 * defaultPadding),
                    nextLessons.isEmpty
                      ? NoPlannedLessons(
                          accent: accent, 
                          isDark: isDark,
                          changePageCallback: widget.changePageCallback,
                        )
                      : PlannedLessons(
                          accent: accent, 
                          isDark: isDark, 
                          lessonList: nextLessons, 
                          refreshUICallback: _refreshUI,
                          changePageCallback: widget.changePageCallback,
                        )
                  ],
                )
              ),
            )
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: accent,
            ),
          );
        }
      }
    );
  }
}




