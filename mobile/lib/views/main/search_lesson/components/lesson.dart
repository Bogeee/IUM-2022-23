import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proj/constants.dart';
import 'package:proj/models/ripetizioni.dart';
import 'package:proj/views/main/home/lesson_details.dart';

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
        child: Container(
        decoration: BoxDecoration(
          color: Colors.white70, // FIXME: mettere colore giusto
          shape: BoxShape.rectangle,
          boxShadow: [
            // FIXME: prima andava, era perfetto, ora non va più e non ho cambiato nulla
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 4,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(defaultPadding)
        ),
        child: Stack(
            children: [
              Column(
                children: [
                  // FIXME: settare icone giuste
                  LessonDetailRow(detail: lesson.corso.materia.nome, header: true, iconPath: "",),
                  Row(
                    children: [
                      Column(
                        children: [
                          LessonDetailRow(detail: lesson.giorno, iconPath: "",),
                        ],
                      ),
                      Column(
                        children: [
                          LessonDetailRow(detail: "${lesson.oraI}:00 - ${lesson.oraF}:00",iconPath: "",),
                        ],
                      ),
                    ],
                  ),
                  LessonDetailRow(detail: "${lesson.corso.docente.nome} ${lesson.corso.docente.cognome}", iconPath: "",),
              ],),
              // FIXME: mettere icona giusta e posizionarla!!!
              Positioned(
                top: 45,
                right: 10,
                child: SvgPicture.asset(
                  'assets/icons/chevron-right-solid.svg',
                  width: 18,
                ),
              )
          ],
          ),
      ),
    );
  }
}