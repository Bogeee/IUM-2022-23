import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:proj/constants.dart';
import 'package:proj/models/notifiers.dart';
import 'package:provider/provider.dart';

class LessonDetailRow extends StatelessWidget {
  const LessonDetailRow({
    Key? key,
    required this.iconPath,
    required this.detail,
    this.header = false
  }) : super(key: key);

  final String? iconPath;
  final String detail;
  final bool header;

  @override
  Widget build(BuildContext context) {
    Color accent = Provider.of<ThemeNotifier>(context).accentColor;
    bool isDark = Provider.of<ThemeNotifier>(context).isDark;

    return Padding(
      padding: const EdgeInsets.all(defaultPadding/2),
      child: Row(
        children: [
          iconPath == ""
              ? SvgPicture.asset('assets/icons/at-solid.svg', width: 14, color: accent,)
              : SvgPicture.asset(
              iconPath!,
              width: 14,
              color: accent
          ),
          const SizedBox(width: 10),
          Text(
            detail,
            style: header
                ? TextStyle(
                    fontSize: 16, color: accent, fontWeight: FontWeight.bold)
                : TextStyle(
                  color: isDark
                    ? Colors.white
                    : Colors.black
                ),
          ),
        ],
      ),
    );
  }
}

