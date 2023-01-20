import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proj/models/ripetizioni.dart';
import 'package:simple_shadow/simple_shadow.dart';

// constants
import 'package:proj/constants.dart';

class WeekLessons extends StatefulWidget {
  const WeekLessons({
    Key? key,
    required this.accent,
    required this.isDark,
    required this.lessonList
  }) : super(key: key);

  final Color accent;
  final bool isDark;
  final List<LezioniSettimanali> lessonList;

  @override
  State<WeekLessons> createState() => _WeekLessonsState();
}

class _WeekLessonsState extends State<WeekLessons> {

  final lun = DateTime(2023, 01, 23);
  final mar = DateTime(2023, 01, 24);
  final mer = DateTime(2023, 01, 25);
  final gio = DateTime(2023, 01, 26);
  final ven = DateTime(2023, 01, 27);
  int total_number = 0;

  List<DataPoint<DateTime>> getChartData(){
    List<DataPoint<DateTime>> data = [];

    total_number = 0;
    for(int i = 0; i < widget.lessonList.length; i++){
      total_number += widget.lessonList[i].numero;
      switch(widget.lessonList[i].giorno){
        case 'Lunedì':
          data.add(DataPoint<DateTime>(
            value: widget.lessonList[i].numero.toDouble(),
            xAxis: lun 
          ));
          break;
        case 'Martedì':
          data.add(DataPoint<DateTime>(
            value: widget.lessonList[i].numero.toDouble(), 
            xAxis: mar
          ));
          break;
        case 'Mercoledì':
          data.add(DataPoint<DateTime>(
            value: widget.lessonList[i].numero.toDouble(), 
            xAxis: mer
          ));
          break;
        case 'Giovedì':
          data.add(DataPoint<DateTime>(
            value: widget.lessonList[i].numero.toDouble(), 
            xAxis: gio
          ));
          break;
        case 'Venerdì':
          data.add(DataPoint<DateTime>(
            value: widget.lessonList[i].numero.toDouble(), 
            xAxis: ven
          ));
          break;
      }
    }

    return data;
  }

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
                  "assets/icons/chart-line-solid.svg",
                  color: widget.isDark ? Colors.white : const Color(0xFF0F172A),
                  height: 16,
                ),
                const SizedBox(width: defaultPadding),
                Text(
                  'Resoconto settimanale',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: widget.isDark
                          ? Colors.white
                          : const Color(0xFF0F172A)),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 1.5 * defaultPadding),
            child: Stack(
              children: [
                Positioned(
                  right: defaultPadding,
                  top: 3 * defaultPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      total_number == 1
                          ? Text(
                              '$total_number ripetizione',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            )
                          : Text(
                              '$total_number ripetizioni',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                      const Text(
                        'Questa settimana',
                        style: TextStyle(
                          color: Color(0xFF4E4D4D),
                          fontSize: 14
                        ),
                      )
                    ],
                  )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Colors.transparent,
                          height: 130,
                          width: 250,
                          child: BezierChart(
                            fromDate: lun,
                            bezierChartScale: BezierChartScale.WEEKLY,
                            toDate: ven,
                            selectedDate: mer,
                            series: [
                              BezierLine(
                                label: "Ripetizioni",
                                lineColor: widget.accent,
                                data: getChartData(),
                              ),
                            ],
                            config: BezierChartConfig(
                                showVerticalIndicator: true,
                                pinchZoom: false,
                                verticalIndicatorStrokeWidth: 3.0,
                                verticalIndicatorColor: Colors.black26,
                                footerHeight: 32,
                                physics: const NeverScrollableScrollPhysics(),
                                backgroundColor: Colors.transparent,
                                xAxisTextStyle: TextStyle(color: widget.accent),
                                snap: true),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ]
            ),
          )
        ],
      ),
    );
  }
}
