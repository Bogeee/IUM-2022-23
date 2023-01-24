import 'package:flutter/material.dart';
import 'package:proj/constants.dart';
import 'package:proj/models/notifiers.dart';
import 'package:proj/models/ripetizioni.dart';
import 'package:proj/views/main/search_lesson/components/lesson.dart';
import 'package:provider/provider.dart';

class HistoryList extends StatefulWidget{
  const HistoryList({
    super.key,
    required this.oldLessons,
    required this.refreshUI
  });

  final List<Ripetizione> oldLessons;
  final VoidCallback refreshUI;

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: ((context, index) {
          return Lesson(
            lesson: widget.oldLessons[index],
            refreshUICallback: widget.refreshUI,
          );
        }), 
        separatorBuilder: (context, index){
          return const SizedBox(
            height: defaultPadding,
          );
        }, 
        itemCount: widget.oldLessons.length
      ),
    );
  }
}