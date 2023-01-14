import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

// models
import 'package:provider/provider.dart';
import 'package:proj/models/notifiers.dart';
import 'package:proj/models/user.dart';

// styles
import 'package:proj/views/onboarding/components/introduction_screen_styles.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeNotifier>(context).isDark;
    Color accent = Provider.of<ThemeNotifier>(context).accentColor;

    return SafeArea(
      child: IntroductionScreen(
        pages: [
          PageViewModel(
            title:
                'Cerca le ripetizioni di cui hai bisogno e supera i tuoi ostacoli...',
            body: 'Ci sono docenti per qualsiasi materia!',
            image: IntroductionScreenStyles.buildImage('assets/images/onboarding/o1.png'),
            decoration: IntroductionScreenStyles.getPageDecoration()
          ),
          PageViewModel(
            title:
                'Scegli l’orario ed il giorno disponibile che più preferisci...',
            body:
                'Sarai seguito da un docente per tutte le ore che riterrai necessarie!',
            image: IntroductionScreenStyles.buildImage('assets/images/onboarding/o2.png'),
            decoration: IntroductionScreenStyles.getPageDecoration()
          ),
          PageViewModel(
            title: 'Esercitati con i docenti in ripetizioni online...',
            body:
                'Oggigiorno ci sono tantissimi strumenti online per il supporto all\'insegnamento!',
            image: IntroductionScreenStyles.buildImage('assets/images/onboarding/o3.png'),
            decoration: IntroductionScreenStyles.getPageDecoration()
          )
        ],
        done: const Text('Inizia', style: TextStyle(fontWeight: FontWeight.bold)),
        onDone: () {
          // After User.onboardingComplete(), we won't show again the onboarding
          // page to the user, unless he deletes the app and reinstalls it.
          User.onboardingComplete();
          Navigator.pushReplacementNamed(context, '/login');
        },
        next: const Text('Avanti', style: TextStyle(fontWeight: FontWeight.bold)),
        showSkipButton: true,
        skip: const Text('Salta'),
        dotsDecorator: IntroductionScreenStyles.getDotDecoration(accent),
        skipStyle: ButtonStyle(
          foregroundColor: isDark 
              ? MaterialStateProperty.all<Color>(Colors.white)
              : MaterialStateProperty.all<Color>(Colors.black),
          textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
            fontWeight: FontWeight.w800,
          ))
        ),
        nextStyle: IntroductionScreenStyles.getRightButtonStyle(accent, isDark).copyWith(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
          foregroundColor: MaterialStateProperty.all<Color>(accent)
        ),
        doneStyle: IntroductionScreenStyles.getRightButtonStyle(accent, isDark),
      )
    );
  }
}
