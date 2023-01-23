import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simple_shadow/simple_shadow.dart';

// constants
import 'package:proj/constants.dart';

// models
import 'package:provider/provider.dart';
import 'package:proj/models/notifiers.dart';
import 'package:proj/models/user.dart';

class UserProfilePage extends StatefulWidget{
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {

  late bool _darkThemeSwitch;

  @override
  Widget build(BuildContext context) {
    User userDetails = Provider.of<LoggedInNotifier>(context).userDetails;
    Color accent = Provider.of<ThemeNotifier>(context).accentColor;
    bool isDark = Provider.of<ThemeNotifier>(context).isDark;

    setState(() {
      _darkThemeSwitch = isDark;
    });

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding / 2),
          child: Column(
            children: [
              const SizedBox(height: defaultPadding,),
              Center(
                child: SimpleShadow(child: SvgPicture.asset(
                    userDetails.isAdmin
                      ? 'assets/icons/user-gear-solid.svg'
                      : 'assets/icons/user-graduate-solid.svg',
                      width: userDetails.isAdmin
                        ? 80 // admin icon has different width
                        : 60,
                      color: accent,
                    ),
                  )
              ),
              const SizedBox(height: 0.5 * defaultPadding,),
              Center(
                child: Text(
                  "${userDetails.nome} ${userDetails.cognome}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  ),
                ),
              ),
              const SizedBox(height: 0.3 * defaultPadding,),
              Center(
                child: Text(
                  userDetails.email,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic
                  ),
                ),
              ),
              const SizedBox(height: 2*defaultPadding,),
              Row(
                children: [
                  SvgPicture.asset(
                        'assets/icons/palette-solid.svg', 
                        width: 14, 
                        color: accent
                      ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Tema scuro',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Switch(
                    value: _darkThemeSwitch,
                    onChanged: (value) async {
                      setState(() {
                        _darkThemeSwitch = value;
                      });
                      Provider.of<ThemeNotifier>(context, listen: false).isDark = value;
                    }
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 3*defaultPadding),
                child: Container(
                  height: 0.5,
                  color: Colors.grey,
                ),
              ),
              Center(
                child: SizedBox(
                  width: 130,
                  height: 40,
                  child: OutlinedButton(
                  onPressed: (){
                    logoutDialog(context);
                  },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                    overlayColor: MaterialStateProperty.all<Color>(Colors.red.withOpacity(0.20)),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(
                        fontWeight: FontWeight.bold
                      )
                    ),
                    side: MaterialStateProperty.all<BorderSide>(
                      const BorderSide(
                        color: Colors.red, 
                        width: 2
                      )
                    )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/right-from-bracket-solid.svg', 
                        width: 14, 
                        color: Colors.red
                      ),
                      const SizedBox(width: 0.5 * defaultPadding),
                      const Text('Esci')
                    ],
                  ),
                ),
                )
              ),
              const SizedBox(height: 15.1*defaultPadding,)
            ],
          ),
        )
      )
    );
  }

  void logoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Conferma'),
          content: const Text(
              'Sei sicuro di voler USCIRE dall\'account?\n\nDovrai rieffettuare l\'accesso.'),
          actions: <Widget>[
            Row(
              children: [
                const SizedBox(
                  width: defaultPadding,
                ),
                Expanded(
                  flex: 2,
                  child: OutlinedButton(
                      onPressed: () {
                        // Non confermato
                        Navigator.of(context).pop(); // close dialog
                      },
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                          overlayColor: MaterialStateProperty.all<Color>(
                              Colors.red.withOpacity(0.20)),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                              const TextStyle(fontWeight: FontWeight.bold)),
                          side: MaterialStateProperty.all<BorderSide>(
                              const BorderSide(color: Colors.red, width: 2))),
                      child: const Text('No')),
                ),
                const Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: 4 * defaultPadding,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: OutlinedButton(
                      onPressed: () async {
                        // confermato, annullo la lezione
                        User? tmp = User();
                        await tmp.removeUserFromLocalStorage();
                        Provider.of<LoggedInNotifier>(context, listen: false).saved = false;
                        Provider.of<LoggedInNotifier>(context, listen: false).user = User();
                        Navigator.of(context).pop(); // close dialog
                        Navigator.of(context).pushReplacementNamed('/login'); // goto login
                      },
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                          overlayColor: MaterialStateProperty.all<Color>(
                              Colors.white.withOpacity(0.20)),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                              const TextStyle(fontWeight: FontWeight.bold)),
                          side: MaterialStateProperty.all<BorderSide>(
                              const BorderSide(color: Colors.blue, width: 2))),
                      child: const Text('Si')),
                ),
                const SizedBox(
                  width: defaultPadding,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}