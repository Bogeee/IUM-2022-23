import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:proj/models/notifiers.dart';
import 'package:provider/provider.dart';

class LessonInfoRowSeparator extends StatelessWidget {
  const LessonInfoRowSeparator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Container(
        height: 0.5,
        color: Colors.grey,
      ),
    );
  }
}

class LessonInfoRow extends StatelessWidget {
  const LessonInfoRow({
    Key? key,
    required this.icon_path,
    required this.item_title,
    required this.item,
  }) : super(key: key);

  final String? icon_path;
  final String item_title;
  final String item;

  @override
  Widget build(BuildContext context) {
    Color accent = Provider.of<ThemeNotifier>(context).accentColor;

    return Row(
      children: [
        icon_path == "" 
          ? SvgPicture.asset('assets/icons/at-solid.svg', width: 14, color: accent,) 
          : SvgPicture.asset(
              icon_path!, 
              width: 14, 
              color: accent
            ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            item_title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
            child: Text(
          item,
          textAlign: item_title == 'Argomento' && item.length > 25
              ? TextAlign.left
              : TextAlign.right,
        ))
      ],
    );
  }
}
