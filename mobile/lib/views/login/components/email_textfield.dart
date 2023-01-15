import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// constants
import 'package:proj/constants.dart';

class EmailTextView extends StatefulWidget {
  const EmailTextView({
    Key? key,
    required this.isDark,
    required this.emailController,
    required this.correct,
  }) : super(key: key);

  final TextEditingController emailController;
  final bool isDark;
  final bool correct;

  @override
  State<EmailTextView> createState() => _EmailTextViewState();
}

class _EmailTextViewState extends State<EmailTextView> {

  bool edited = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: TextFormField(
        controller: widget.emailController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Inserisci una email.';
          }
          // check if the input is a valid email
          final RegExp emailExp = RegExp(
            // regex for the most common email formats
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$"
          );
          if (!emailExp.hasMatch(value)) {
            return 'Inserisci una email valida.';
          }

          return null;
        },
        decoration: InputDecoration(
          hintText: 'Inserisci l\'indirizzo email',
          hintStyle: const TextStyle(color: Color(0xFF616161)),
          errorStyle: TextStyle(
            color: widget.isDark 
              ? const Color(0xffff5959) 
              : const Color(0xffc50000)
          ),
          prefixIcon: Container(
            padding: const EdgeInsets.all(0.75 * defaultPadding),
            margin:
              const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            child: SvgPicture.asset(
              'assets/icons/at-solid.svg',
              width: 18,
            ),
          ),
          fillColor: const Color(0xFFEDEDED),
          filled: true,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(5))
          ),
          constraints: const BoxConstraints(
            minWidth: 270, maxWidth: 350, minHeight: 60, maxHeight: 85
          ),
          errorText: widget.correct || edited ? null : 'Email errata.'
        ),
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(color: Colors.black),
        onChanged: (value) {
          setState(() {
            edited = true;
          });
        },
        onSaved: (value) {
          setState(() {
            edited = false;
          });
        },
      ),
    );
  }
}
