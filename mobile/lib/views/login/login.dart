import 'package:flutter/material.dart';

// models
import 'package:provider/provider.dart';
import 'package:proj/models/notifiers.dart';

// views
import 'package:proj/views/login/components/bg_shade.dart';
import 'package:proj/views/login/components/login_form.dart';


class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeNotifier>(context).isDark;
    Color accent = Provider.of<ThemeNotifier>(context).accentColor;
    Color shade = Provider.of<ThemeNotifier>(context).shadeColor;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Stack(children: [
            BgShade(shadeColor: shade, dimension: 111, top: 40, right: 27),
            BgShade(shadeColor: shade, dimension: 36, top: 159, left: 48),
            BgShade(shadeColor: shade, dimension: 55, top: 30, left: 75),
            LoginForm(isDark: isDark, accent: accent),
          ]),
        ),
      ),
    );
  }
}
