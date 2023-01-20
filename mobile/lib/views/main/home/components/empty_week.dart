import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_shadow/simple_shadow.dart';

// constants
import 'package:proj/constants.dart';

class EmptyWeek extends StatelessWidget {
  const EmptyWeek({
    Key? key,
    required this.accent,
    required this.isDark,
  }) : super(key: key);

  final Color accent;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: accent.withOpacity(0.13),
          borderRadius: BorderRadius.circular(defaultPadding)),
      child: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    defaultPadding, defaultPadding / 1.5, defaultPadding, 0),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/chart-line-solid.svg",
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      height: 16,
                    ),
                    const SizedBox(width: defaultPadding),
                    Text(
                      'Resoconto settimanale',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? Colors.white : const Color(0xFF0F172A)),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: defaultPadding,
                    top: 1.5 * defaultPadding,
                    bottom: 1.5 * defaultPadding),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Non hai ripetizioni in \nprogramma',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : Color.fromARGB(255, 0, 10, 34),
                              fontSize: 16),
                        ),
                        const SizedBox(height: 0.75 * defaultPadding),
                        const Text(
                          'Buona settimana',
                          style:
                              TextStyle(color: Color(0xff4E4D4D), fontSize: 13),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          Positioned(
              right: 0,
              top: 1.5 * defaultPadding,
              child: SimpleShadow(
                color: Colors.black38,
                offset: const Offset(0, 3),
                child: Image.asset(
                  'assets/images/home/free_week.png',
                  width: 120,
                ),
              ))
        ],
      ),
    );
  }
}
