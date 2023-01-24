import 'package:flutter/material.dart';
import 'package:proj/constants.dart';
import 'package:proj/models/ripetizioni.dart';
import 'package:proj/views/main/search_lesson/components/lesson.dart';

class CancelledList extends StatefulWidget {
  const CancelledList(
      {super.key, required this.cancelledLessons, required this.refreshUI});

  final List<Ripetizione> cancelledLessons;
  final VoidCallback refreshUI;

  @override
  State<CancelledList> createState() => _CancelledListState();
}

class _CancelledListState extends State<CancelledList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: ((context, index) {
          return Lesson(
            lesson: widget.cancelledLessons[index],
            refreshUICallback: widget.refreshUI,
          );
        }),
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: defaultPadding,
          );
        },
        itemCount: widget.cancelledLessons.length
      ),
    );
  }
}
