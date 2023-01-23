import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';

// constants
import 'package:proj/constants.dart';

// models
import 'package:provider/provider.dart';
import 'package:proj/models/notifiers.dart';

// views
import 'package:proj/views/login/components/bg_shade.dart';

class NoHistory extends StatelessWidget {
  const NoHistory({
    Key? key,
    required this.changePageCallback
  }) : super(key: key);

  final VoidCallback changePageCallback;

  @override
  Widget build(BuildContext context) {

    Color accent = Provider.of<ThemeNotifier>(context).accentColor;
    Color shade = Provider.of<ThemeNotifier>(context).shadeColor;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding / 2),
            child: Center(
              child: Stack(
                children: [
                  BgShade(
                      top: 30, right: 20, shadeColor: shade, dimension: 111),
                  BgShade(top: 25, left: 131, shadeColor: shade, dimension: 36),
                  BgShade(top: 90, left: 50, shadeColor: shade, dimension: 36),
                  BgShade(
                      top: 400, left: 40, shadeColor: shade, dimension: 111),
                  BgShade(
                      top: 500, right: 120, shadeColor: shade, dimension: 36),
                  BgShade(
                      top: 450, right: 50, shadeColor: shade, dimension: 36),
                  BgShade(
                      top: 375, right: 100, shadeColor: shade, dimension: 36),
                  Column(
                    children: [
                      const SizedBox(height: 3 * defaultPadding),
                      Center(
                          child: SimpleShadow(
                              child: Image.asset(
                                  'assets/images/history/homework.png',
                                  width: 300))),
                      const SizedBox(
                        height: 0.5 * defaultPadding,
                      ),
                      const Text(
                        'Non hai ancora completato alcuna ripetizione!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      const Text(
                        'In questa sezione potrai vedere tutte le lezioni svolte o disdette in passato.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      const Text(
                        'Puoi prenotare una ripetizione nella sezione “Prenota” oppure con il pulsante qui sotto.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        height: 3 * defaultPadding,
                      ),
                      SizedBox(
                          width: 400,
                          height: 40,
                          child: OutlinedButton(
                            onPressed: () {
                              changePageCallback();
                            },
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(accent),
                              overlayColor: MaterialStateProperty.all<Color>(
                                  Colors.white.withOpacity(0.20)),
                              textStyle: MaterialStateProperty.all<TextStyle>(
                                  const TextStyle(fontWeight: FontWeight.bold)),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              )),
                            ),
                            child: const Text('Prenota una ripetizione'),
                          )),
                      const SizedBox(
                        height: 5.7 * defaultPadding,
                      )
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
