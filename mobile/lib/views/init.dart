import 'package:flutter/material.dart';
import 'package:proj/models/login_info.dart';
import 'package:proj/models/notifiers.dart';
// Models
import 'package:proj/models/user.dart';
import 'package:provider/provider.dart';

// Views
import 'package:proj/views/login/login.dart';
import 'package:proj/views/main/main_screen.dart';
import 'package:proj/views/onboarding/onboarding.dart';

class InitView extends StatefulWidget {
  const InitView({super.key});

  @override
  State<InitView> createState() => _InitViewState();
}

class _InitViewState extends State<InitView> {
  bool _isSaved = false;
  User? _user;
  bool checked = false;
  bool _firstOpening = false;

  // Necessary to run _checkInitStatus() just once in the FutureBuilder
  Future<void> _futureCall() async {
    if(!checked){
      _checkInitStatus();
    }
  }

  // This function checks if the user is already logged in or if it's the
  // first time he is opening the app. The first view depends on these infos.
  Future<void> _checkInitStatus() async {

    // FIRST OPENING CHECK
    bool firstUse = await User.isFirstOpening();
    setState(() {
      _firstOpening = firstUse;
    });

    // If it's the first time we open the app, there is no way we
    // are logged in, so we skip the rest of the code.
    if (firstUse) {
      setState(() {
        checked = true;
      });
      return;
    }

    // ALREADY LOGGED IN CHECK (+ zero trust check)
    User? tmp = await User.readUserFromLocalStorage();
    if (tmp != null) {
      setState(() {
        _user = tmp;
      });
      // We must test the login credentials because we can't restore
      // the session just because we read info from the json file.
      // This file can be edited with root privileges!
      LoginInfo info = await testLoginCrypted(tmp.email, tmp.password, true);

      if (info.success) {
        setState(() {
          _isSaved = true;
        });
        // Then we must rewrite the local file with the DB info to keep consistent data,
        // but also, if a root user edited this text, this won't affect the app
        // when running. This will fix malicious edits before using user's data in the app.
        User.writeUserToLocalStorage(info.user);
      } else {
        await tmp.removeUserFromLocalStorage();
        setState(() {
          _isSaved = false;
        });
      }
    } else {
      setState(() {
        _user = null;
      });
    }

    setState(() {
      checked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureCall(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(checked){
          Provider.of<LoggedInNotifier>(context).saved = _isSaved;
          Provider.of<LoggedInNotifier>(context).user = _user;

          if (_firstOpening) {
            return const OnboardingPage();
          } else {
            return _isSaved ? const MainScreen() : const LoginView();
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Provider.of<ThemeNotifier>(context).accentColor,
              ),
            )
          );
        }
      }
    );
  }
}
