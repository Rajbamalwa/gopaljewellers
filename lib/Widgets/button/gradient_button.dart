import 'package:flutter/material.dart';
import 'package:gopaljewellers/constants/color.dart';

import '../custom/customtext.dart';

class GradientButton extends StatelessWidget {
  double width;
  double height;
  String text;
  double fontSize;
  FontWeight fontWeight;
  Color fontColor;
  Function() onTap;
  GradientButton({
    required this.width,
    required this.height,
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    required this.fontColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [primaryColor22, primaryColor2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ElevatedButton(
          onPressed: onTap,
          style: ButtonStyle(
              shadowColor: MaterialStateColor.resolveWith(
                  (states) => Colors.transparent),
              backgroundColor: MaterialStateColor.resolveWith(
                  (states) => Colors.transparent),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.transparent)))),
          child: CustomText2(
              text, fontColor, fontSize, fontWeight, TextOverflow.ellipsis),
        ),
      ),
    );
  }
}
