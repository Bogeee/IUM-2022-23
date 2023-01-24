import 'package:flutter/material.dart';
import 'package:proj/models/notifiers.dart';
import 'package:provider/provider.dart';

class GenericTitle extends StatelessWidget {
  const GenericTitle({
    Key? key,
    required this.title
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        )
      ],
    );
  }
}

class NextLessonsTitle extends StatelessWidget {
  const NextLessonsTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: const [
        Text(
          'In programma',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        )
      ],
    );
  }
}

class TodayTitle extends StatelessWidget {
  const TodayTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color lessContrastTextColor = Provider.of<ThemeNotifier>(context).lessContrastTextColor;
    
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Oggi',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        Text(
          '25 Gennaio 2023',
          style: TextStyle(
            color: lessContrastTextColor,
            fontSize: 14,
          ),
          textAlign: TextAlign.right,
        )
      ],
    );
  }
}
