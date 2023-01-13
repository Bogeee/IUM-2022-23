import 'package:flutter/material.dart';

class RemindMeCheckbox extends StatefulWidget {
  const RemindMeCheckbox({
    Key? key, 
    required this.remindMeController,
    required this.accentColor,
    required this.isDark
  }) : super(key: key);

  final ValueNotifier<bool?> remindMeController;
  final Color accentColor;
  final bool isDark;

  @override
  State<RemindMeCheckbox> createState() => _RemindMeCheckboxState();
}

class _RemindMeCheckboxState extends State<RemindMeCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          checkColor: widget.isDark
             ? Colors.black
             : Colors.white,
          fillColor: MaterialStateProperty.all<Color>(widget.accentColor),
          value: widget.remindMeController.value,
          onChanged: (bool? choice) {
            setState(() {
              widget.remindMeController.value = choice;
            });
          },
        ),
        const Text('Ricordami')
      ],
    );
  }
}
