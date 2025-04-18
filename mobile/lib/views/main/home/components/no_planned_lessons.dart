import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proj/models/notifiers.dart';
import 'package:provider/provider.dart';
import 'package:simple_shadow/simple_shadow.dart';

// constants
import 'package:proj/constants.dart';

class NoPlannedLessons extends StatelessWidget {
  const NoPlannedLessons({
    Key? key,
    required this.accent,
    required this.isDark,
    required this.changePageCallback
  }) : super(key: key);

  final Color accent;
  final bool isDark;
  final VoidCallback changePageCallback;

  @override
  Widget build(BuildContext context) {
    Color lessContrastTextColor = Provider.of<ThemeNotifier>(context).lessContrastTextColor;

    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: accent.withOpacity(0.13),
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
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  height: 16,
                ),
                const SizedBox(width: defaultPadding),
                Text(
                  'Lezioni programmate',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A)),
                )
              ],
            ),
          ),
          Center(
            child: SimpleShadow(
              color: isDark
                ? Colors.white38
                : Colors.black38,
              offset: const Offset(0, 3),
              child: Image.asset(
                'assets/images/home/lessons.png',
                width: 260
              ),
            )
          ),
          Row(
            children: [
              const SizedBox(width: defaultPadding,),
              Text(
                'Nessuna ripetizione',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? Colors.white
                      : const Color(0xFF0F172A),
                  fontSize: 16
                ),
              )
            ],
          ),
          Row(
            children: [
              const SizedBox(width: defaultPadding,),
              Text(
                'Puoi aggiungere ripetizioni nella sezione "Prenota".',
                style: TextStyle(
                  color: lessContrastTextColor,
                  fontSize: 13
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.5 * defaultPadding, bottom: 0.5 *defaultPadding),
            child: Center(
              child: SizedBox(
                width: 140,
                child: OutlinedButton(
                onPressed: () {
                  changePageCallback();
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  )),
                  backgroundColor: MaterialStateProperty.all<Color>(accent.withOpacity(0.25)),
                  overlayColor: MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.20)),
                  foregroundColor: isDark 
                    ? MaterialStateProperty.all<Color>(Colors.white)  
                    : MaterialStateProperty.all<Color>(Colors.black)
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 0.8 * defaultPadding,
                    ),
                    SvgPicture.asset(
                      'assets/icons/plus-solid.svg',
                      width: 14,
                      color: isDark
                        ? Colors.white
                        : Colors.black,
                    ),
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
              )
            )
          )
        ],
      ),
    );
  }
}
