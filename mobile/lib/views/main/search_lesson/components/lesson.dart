import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proj/constants.dart';
import 'package:proj/models/ripetizioni.dart';
import 'package:proj/views/main/home/components/labels.dart';
import 'package:proj/views/main/home/lesson_details.dart';
import 'package:simple_shadow/simple_shadow.dart';

import 'lesson_detail.dart';

class Lesson extends StatelessWidget {
  const Lesson({
    super.key,
    required this.lesson,
    required this.refreshUICallback,
  });

  final Ripetizione lesson;
  final VoidCallback refreshUICallback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
          Navigator.push(context,
              MaterialPageRoute(
                  builder: ((context) => LessonDetails(
                    lesson: lesson,
                    refreshUICallback: refreshUICallback,
                  )
                )
              )
          );
        },
        child: SimpleShadow(
          sigma: 3,
          offset: const Offset(2,2),
          child: Container(
          decoration: BoxDecoration(
              color: const Color(0xfff6f6f6),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(defaultPadding / 2)),
          child: Stack(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      LessonDetailRow(
                          detail: lesson.corso.materia.nome,
                          header: true,
                          iconPath: 'assets/icons/graduation-cap-solid.svg',
                        ),
                      const SizedBox(width: defaultPadding,),
                      if(lesson.stato != 4)
                        if(lesson.stato == 0)
                          const ActiveLabel(),
                        if(lesson.stato == 1)
                          const ExtendedCompletedLabel(),
                        if(lesson.stato == 2)
                          const CancelledLabel(),
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: 130,
                            child: LessonDetailRow(
                            detail: lesson.giorno,
                            iconPath: 'assets/icons/calendar-days-solid.svg',
                          ),
                          )
                        ],
                      ),
                      // const SizedBox(width: 1.5 * defaultPadding,),
                      Column(
                        children: [
                          LessonDetailRow(
                            detail: "${lesson.oraI}:00 - ${lesson.oraF}:00",
                            iconPath: 'assets/icons/clock-regular.svg',
                          ),
                        ],
                      ),
                    ],
                  ),
                  LessonDetailRow(
                    detail:
                        "${lesson.corso.docente.nome} ${lesson.corso.docente.cognome}",
                    iconPath: 'assets/icons/user-tie-solid.svg',
                  ),
                ],
              ),
              Positioned(
                top: 45,
                right: 20,
                child: SvgPicture.asset(
                  'assets/icons/chevron-right-solid.svg',
                  width: 11,
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}