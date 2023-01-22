import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:simple_shadow/simple_shadow.dart';

// modals
import 'package:proj/models/materie.dart';
import 'package:proj/models/ripetizioni.dart';
import 'package:proj/models/notifiers.dart';
import 'package:proj/models/docenti.dart';

// constants
import 'package:proj/constants.dart';

import 'lesson.dart';

class SearchResult extends StatelessWidget {
  const SearchResult({
    Key? key,
    required this.accent,
    required this.isDark,
    required this.lessons,
    required this.refreshUICallback,
  }) : super(key: key);

  final Color accent;
  final bool isDark;
  final List<Ripetizione> lessons;
  final VoidCallback refreshUICallback;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(defaultPadding/4, defaultPadding/4, 0, defaultPadding),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Risultati ricerca",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            // physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Lesson(lesson: lessons[index], refreshUICallback: refreshUICallback,);
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 0.5 * defaultPadding,
                );
              },
              itemCount: lessons.length),
        ),
      ],
    );
  }
}