import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  CustomText(this.text, this.color, this.size, this.weight, this.overflow);
  final String text;
  final Color color;
  final double size;
  final FontWeight weight;
  final TextOverflow overflow;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      style: TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: color,
      ),
    );
  }
}

class CustomText2 extends StatelessWidget {
  CustomText2(this.text, this.color, this.size, this.weight, this.overflow);
  final String text;
  final Color color;
  final double size;
  final FontWeight weight;
  final TextOverflow overflow;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      style: TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: color,
      ),
    );
  }
}
