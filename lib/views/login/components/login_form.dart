import 'package:flutter/material.dart';

// constants
import 'package:proj/constants.dart';

// models
import 'package:provider/provider.dart';
import 'package:proj/models/notifiers.dart';
import 'package:proj/models/login_info.dart';

// views
import 'package:proj/views/login/components/email_textfield.dart';
import 'package:proj/views/login/components/password_textfield.dart';
import 'package:proj/views/login/components/remindme_checkbox.dart';


class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
    required this.isDark,
    required this.accent,
  }) : super(key: key);

  final bool isDark;
  final Color accent;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final remindMeController = ValueNotifier<bool?>(false);
  bool correct = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      // non ci piace il comportamento, abbiamo scritto la logica per la validazione
      // e per mostrare all'utente i vari messaggi d'errore nel momento opportuno
      // autovalidateMode: AutovalidateMode.always,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 4 * defaultPadding),
          // Text or Logo
          Text(
            'Ripetizioni',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: widget.isDark ? Colors.white : Colors.black),
          ),
          const SizedBox(height: 3 * defaultPadding),
          const Text(
            'Accedi',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 2 * defaultPadding),

          EmailTextView(
            emailController: emailController,
            isDark: widget.isDark,
            correct: correct,
          ),
          const SizedBox(height: 1 * defaultPadding),
          PasswordTextField(
            passwordController: passwordController,
            isDark: widget.isDark,
            accentColor: widget.accent,
            correct: correct,
          ),
          const SizedBox(height: defaultPadding),
          RemindMeCheckbox(
            remindMeController: remindMeController,
            accentColor: widget.accent,
            isDark: widget.isDark,
          ),
          const SizedBox(height: defaultPadding),
          // Submit button
          OutlinedButton(
              onPressed: () async {
                final String email = emailController.text;
                final String pwd = passwordController.text;
                final bool? saveme = remindMeController.value;

                if (_formKey.currentState!.validate()) {
                  // inform user of logging in
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Row(
                      children: [
                        CircularProgressIndicator(
                          color: widget.accent,
                        ),
                        const SizedBox(
                          width: defaultPadding,
                          height: 20,
                        ),
                        const Text('Accesso in corso...')
                      ],
                    ),
                    duration: const Duration(seconds: 1),
                  ));

                  final loggedIn = await testLogin(email, pwd, saveme);
                  if (loggedIn.success) {
                    // Login successful
                    Provider.of<LoggedInNotifier>(context, listen: false).user =
                        loggedIn.user;
                    // FIXME: set /home route
                    Navigator.pushReplacementNamed(context, '/onboarding');
                  } else {
                    // Login error
                    setState(() {
                      correct = false;
                    });
                  }
                  _formKey.currentState!.save();
                }
              },
              style: ButtonStyle(
                foregroundColor: widget.isDark
                    ? MaterialStateProperty.all<Color>(Colors.black)
                    : MaterialStateProperty.all<Color>(Colors.white),
                textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
                  fontWeight: FontWeight.w800,
                )),
                minimumSize:
                    MaterialStateProperty.all<Size>(const Size(270, 60)),
                maximumSize:
                    MaterialStateProperty.all<Size>(const Size(350, 60)),
                backgroundColor:
                    MaterialStateProperty.all<Color>(widget.accent),
                overlayColor: MaterialStateProperty.all<Color>(
                    Colors.white.withOpacity(0.20)),
              ),
              child: const Text(
                'Accedi',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              )),
          const SizedBox(height: 3 * defaultPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 1,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: widget.isDark ? Colors.white : Colors.black,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 3 * defaultPadding),
                child: Text('Oppure'),
              ),
              Container(
                width: 30,
                height: 1,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: widget.isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3 * defaultPadding),
          const Text('Non hai ancora un account?'),
          TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/register');
              },
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(widget.accent)),
              child: const Text(
                'Registrati',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ))
        ],
      ),
    );
  }
}
