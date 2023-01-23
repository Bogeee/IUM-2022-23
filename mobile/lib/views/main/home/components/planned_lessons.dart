import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// constants
import 'package:proj/constants.dart';

// models
import 'package:proj/models/ripetizioni.dart';

// views
import 'package:proj/views/main/home/components/labels.dart';
import 'package:proj/views/main/home/lesson_details.dart';

class PlannedLessons extends StatefulWidget {
  const PlannedLessons({ 
    Key? key,
    required this.accent,
    required this.isDark,
    required this.lessonList,
    required this.refreshUICallback,
    required this.changePageCallback
  }) : super(key: key);

  final Color accent;
  final bool isDark;
  final List<Ripetizione> lessonList;
  final VoidCallback refreshUICallback;
  final VoidCallback changePageCallback;

  @override
  State<PlannedLessons> createState() => _PlannedLessonsState();
}

class _PlannedLessonsState extends State<PlannedLessons> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: widget.accent.withOpacity(0.13),
          borderRadius: BorderRadius.circular(defaultPadding)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                defaultPadding, defaultPadding / 1.5, defaultPadding, 0),
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/icons/book-bookmark-solid.svg",
                  color: widget.isDark ? Colors.white : const Color(0xFF0F172A),
                  height: 16,
                ),
                const SizedBox(width: defaultPadding),
                Text(
                  'Lezioni programmate',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: widget.isDark ? Colors.white : const Color(0xFF0F172A)),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Expanded(
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.lessonList.length,
                itemBuilder: lessonBuilder,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 0.3*defaultPadding,);
                },
              )
            )
          ),
          Row(
            children: const [
              SizedBox(
                width: defaultPadding,
              ),
              Text(
                'Puoi aggiungere ripetizioni nella sezione "Prenota".',
                style: TextStyle(color: Color(0xff4E4D4D), fontSize: 13),
              )
            ],
          ),
          Padding(
              padding: const EdgeInsets.only(
                  top: 0.5 * defaultPadding, bottom: 0.5 * defaultPadding),
              child: Center(
                child: SizedBox(
                width: 140,
                child: OutlinedButton(
                  onPressed: () {
                    widget.changePageCallback();
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      )),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          widget.accent.withOpacity(0.25)),
                      overlayColor: MaterialStateProperty.all<Color>(
                          Colors.white.withOpacity(0.20)),
                      foregroundColor: widget.isDark
                          ? MaterialStateProperty.all<Color>(Colors.white)
                          : MaterialStateProperty.all<Color>(Colors.black)),
                  child: Row(
                    children: [
                      const SizedBox(width: 0.8 * defaultPadding,),
                      SvgPicture.asset('assets/icons/plus-solid.svg',
                          width: 14),
                      const Expanded(
                        child: Text(
                          'Ripetizione',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        )
                      )
                    ],
                  ),
                ),
              )))
        ],
      ),
    );
  }

  Widget lessonBuilder(BuildContext context, int index) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0.5 * defaultPadding),
          color: Colors.white
      ),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, 
            MaterialPageRoute(
              builder: ((context) => LessonDetails(
                  lesson: widget.lessonList[index],
                  refreshUICallback: widget.refreshUICallback,
                )
              )
            )
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
              widget.lessonList[index].corso.materia.nome.toString(),
              textAlign: TextAlign.center,
            )),
            Container(
              width: 1,
              height: 25,
              decoration: const BoxDecoration(color: Colors.grey),
            ),
            Expanded(
              child: Text(
              '${widget.lessonList[index].oraI}.00 - ${widget.lessonList[index].oraF}.00',
              textAlign: TextAlign.center,
            )),
            Container(
              width: 1,
              height: 25,
              decoration: const BoxDecoration(color: Colors.grey),
            ),
            Expanded(
                child: widget.lessonList[index].stato == 0
                  ? const ActiveLabel()
                  : const CompletedLabel()
            ),
          ],
        ),
      ),
    );
  }
}
