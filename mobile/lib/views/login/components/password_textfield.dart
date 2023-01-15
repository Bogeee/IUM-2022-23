import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// constants
import 'package:proj/constants.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    Key? key, 
    required this.passwordController, 
    required this.accentColor,
    required this.isDark,
    required this.correct
  }) : super(key: key);

  final TextEditingController passwordController;
  final Color accentColor;
  final bool isDark;
  final bool correct;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {

  bool showPassword = false;
  bool edited = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: TextFormField(
        controller: widget.passwordController,
        validator: (value) {
          if (value == null || value.isEmpty || value.length < 8) {
            if (value!.length < 8){
              return 'La password deve avere almeno 8 caratteri.';
            }
            return 'Inserisci la password.';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: 'Inserisci la password',
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
              'assets/icons/lock-tick.svg',
              width: 18,
            ),
          ),
          fillColor: const Color(0xFFEDEDED),
          filled: true,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(5))
          ),
          suffixIcon: Container(
            padding: const EdgeInsets.all(0.75 * defaultPadding),
            margin:
              const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            child: InkWell(
              onTap: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              child: SvgPicture.asset(
                showPassword
                    ? 'assets/icons/eye-slash-regular.svg'
                    : 'assets/icons/eye-regular.svg',
                width: 18,
              ),
            ),
          ),
          constraints: const BoxConstraints(
            minWidth: 270, maxWidth: 350, minHeight: 60, maxHeight: 85
          ),
          errorText: widget.correct || edited ? null : 'Password errata.'
        ),
        keyboardType: TextInputType.visiblePassword,
        style: const TextStyle(color: Colors.black),
        obscureText: showPassword ? false : true,
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
