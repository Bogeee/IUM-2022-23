import 'package:flutter/material.dart';
import 'package:proj/constants.dart';

class ActiveLabel extends StatelessWidget{
  const ActiveLabel({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: SizedBox(
          height: 25,
          width: 70,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFCDFFCD),
              borderRadius: BorderRadius.circular(25)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 0.9* defaultPadding),
                Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle, 
                    color: Color(0xff007f00)
                  ),
                ),
                const SizedBox(width: 3,),
                const Expanded(child: Text(
                  'Attiva',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Color(0xff007f00)),
                ))
              ],
            ),
          ),
        ),
      )
    );
  }
  
}

class CompletedLabel extends StatelessWidget {
  const CompletedLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: SizedBox(
          height: 25,
          width: 70,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFECCC),
              borderRadius: BorderRadius.circular(25)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 0.9* defaultPadding),
                Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle, 
                    color: Color(0xff965E00)
                  ),
                ),
                const SizedBox(width: 3,),
                const Expanded(child: Text(
                  'Finita',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Color(0xff965E00)),
                ))
              ],
            ),
          ),
        ),
      )
    );
  }
}
