import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BgShade extends StatelessWidget {
  BgShade({
    Key? key,
    required this.shadeColor,
    required this.dimension,
    this.top,
    this.left,
    this.right,
    this.bottom,
  }) : super(key: key);

  final Color shadeColor;
  final double dimension; // width == height
  double? top = double.infinity;
  double? left = double.infinity;
  double? right = double.infinity;
  double? bottom = double.infinity;
  // only two of the following heights must be specified:
  // [height], [top coordinate], [bottom coordinate]
  // I set the bottom coordinate if and only if the top is not defined

  @override
  Widget build(BuildContext context) {
    return Positioned(
      width: dimension,
      height: dimension,
      top: top != double.infinity ? top : null,
      right: right != double.infinity ? right : null,
      left: left != double.infinity ? left : null,
      bottom:
        bottom != double.infinity && top == double.infinity ? bottom : null,
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: shadeColor),
      ),
    );
  }
}
