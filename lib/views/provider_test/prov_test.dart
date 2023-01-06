import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/notifiers.dart';

class FirstView extends StatelessWidget {
  const FirstView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeNotifier>(context).isDark;

    return Scaffold(
        appBar: AppBar(
            title: const Text('First View'), automaticallyImplyLeading: false),
        body: Center(
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/second');
            },
            child: isDark ? const Text('Dark') : const Text('Light'),
          ),
        ));
  }
}

class SecondView extends StatelessWidget {
  const SecondView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeNotifier>(context).isDark;
    return Scaffold(
      appBar: AppBar(
          title: const Text('Second View'), automaticallyImplyLeading: false),
      body: Center(
        child: FloatingActionButton(
            onPressed: () {
              if (isDark) {
                Navigator.pushReplacementNamed(context, '/first');
              }
              Provider.of<ThemeNotifier>(context, listen: false).isDark = !isDark;
            },
            child: !isDark ? const Text('Dark') : const Text('Flip')
        ),
      ),
    );
  }
}
