import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proj/constants.dart';
import 'package:proj/models/ripetizioni.dart';
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
              color: const Color(0xfff6f6f6), // FIXME: mettere colore giusto
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(defaultPadding / 2)),
          child: Stack(
            children: [
              Column(
                children: [
                  // FIXME: settare icone giuste
                  LessonDetailRow(
                    detail: lesson.corso.materia.nome,
                    header: true,
                    iconPath: "",
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          LessonDetailRow(
                            detail: lesson.giorno,
                            iconPath: "",
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          LessonDetailRow(
                            detail: "${lesson.oraI}:00 - ${lesson.oraF}:00",
                            iconPath: "",
                          ),
                        ],
                      ),
                    ],
                  ),
                  LessonDetailRow(
                    detail:
                        "${lesson.corso.docente.nome} ${lesson.corso.docente.cognome}",
                    iconPath: "",
                  ),
                ],
              ),
              // FIXME: mettere icona giusta e posizionarla!!!
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