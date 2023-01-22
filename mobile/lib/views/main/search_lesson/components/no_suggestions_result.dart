import 'package:flutter/material.dart';
import 'package:proj/views/login/components/bg_shade.dart';
import 'package:provider/provider.dart';
import 'package:simple_shadow/simple_shadow.dart';

// constants
import 'package:proj/constants.dart';

// models
import 'package:proj/models/notifiers.dart';

class NoSuggestionsResult extends StatelessWidget {
  const NoSuggestionsResult({
    Key? key,
    required this.accent,
    required this.isDark,
  }) : super(key: key);

  final Color accent;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    Color shade = Provider.of<ThemeNotifier>(context).shadeColor;

    return Stack(
      children: [
        BgShade(shadeColor: shade, dimension: 111, top: 150, left: 10),
        BgShade(shadeColor: shade, dimension: 36, top: 130, right: 70),
        BgShade(shadeColor: shade, dimension: 36, top: 200, right: 20),
        BgShade(shadeColor: shade, dimension: 36, top: 250, right: 100),
        Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Seleziona la materia, il giorno e l’ora della\nripetizione, poi tocca sul pulsante “Cerca”\nper trovare ciò che fa per te!\n\nUna volta scelta la ripetizione potrai\nspecificare l’argomento su cui hai dei dubbi...',
                      style: TextStyle(
                          color:
                              isDark ? Colors.white : const Color(0xFF0F172A),
                          fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    )))
          ],
        ),
        Positioned(
            left: 2 * defaultPadding,
            bottom: 0,
            child: SimpleShadow(
              color: Colors.black38,
              offset: const Offset(0, 3),
              child: Image.asset(
                'assets/images/home/search2.png',
                height: 200,
              ),
            ))
      ],
    );
  }
}
