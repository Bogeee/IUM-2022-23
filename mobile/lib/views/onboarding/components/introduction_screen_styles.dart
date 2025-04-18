import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

// constants
import 'package:proj/constants.dart';

class IntroductionScreenStyles{

  static Widget buildImage(String path) => Center(child: Image.asset(path, width: 350));

  static PageDecoration getPageDecoration() => const PageDecoration(
    titleTextStyle: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
    titlePadding: EdgeInsets.all(defaultPadding),
    imagePadding: EdgeInsets.fromLTRB(0, 5 * defaultPadding, 0, defaultPadding),
    bodyPadding: EdgeInsets.only(top: 2 * defaultPadding),
    bodyTextStyle: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
  );

  static DotsDecorator getDotDecoration(Color accent) => DotsDecorator(
    size: const Size(10, 10),
    activeSize: const Size(24, 10),
    activeShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultPadding)),
    activeColor: accent
  );

  static ButtonStyle getRightButtonStyle(Color accent, bool isDark) => ButtonStyle(
    foregroundColor: isDark
        ? MaterialStateProperty.all<Color>(Colors.black)
        : MaterialStateProperty.all<Color>(Colors.white),
    textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
      fontWeight: FontWeight.w800,
    )),
    backgroundColor: MaterialStateProperty.all<Color>(accent),
    overlayColor: MaterialStateProperty.all<Color>(accent.withOpacity(0.12)),
  );
}


