import 'package:flutter/material.dart';
import 'package:proj/models/materie.dart';
import 'package:proj/models/ripetizioni.dart';
import 'package:proj/views/login/components/bg_shade.dart';
import 'package:provider/provider.dart';
import 'package:simple_shadow/simple_shadow.dart';

// constants
import 'package:proj/constants.dart';

// models
import 'package:proj/models/notifiers.dart';

import 'lesson.dart';

class SuggestedLessons extends StatefulWidget {
  const SuggestedLessons({
    Key? key,
    required this.accent,
    required this.isDark,
    required this.previousSubjects,
    required this.refreshUICallback,
  }) : super(key: key);

  final Color accent;
  final bool isDark;
  final List<Materia> previousSubjects;
  final VoidCallback refreshUICallback;

  @override
  State<SuggestedLessons> createState() => _SuggestedLessonsState();
}

class _SuggestedLessonsState extends State<SuggestedLessons> {
  List<Ripetizione> suggestedLessons = [];
  bool _checked = false;

  Future<void> _suggestedLessonsFuture(studentId) async {
    if(!_checked) {
      suggestedLessons = await getSuggestedLessons(widget.previousSubjects, studentId, 'Mercoledì');
      setState(() {
        _checked = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int userId = Provider.of<LoggedInNotifier>(context).userId;

    return FutureBuilder(future: _suggestedLessonsFuture(userId), builder: (BuildContext context, AsyncSnapshot snapshot) {
      if(_checked) {
        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(defaultPadding/4, defaultPadding/4, 0, defaultPadding),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    "Potrebbero interessarti",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
              ),
            ),
              Expanded(
                child: ListView.separated(
                    // physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Lesson(lesson: suggestedLessons[index], refreshUICallback: widget.refreshUICallback,);
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 0.5 * defaultPadding,
                      );
                    },
                    itemCount: suggestedLessons.length),
              ),
            ],
        );
      } else {
        return Center(
          child: CircularProgressIndicator(
            color: Provider.of<ThemeNotifier>(context).accentColor,
          ),
        );
      }
    },);
  }
}
