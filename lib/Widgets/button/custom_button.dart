import 'package:flutter/material.dart';

class Buttons extends StatelessWidget {
  Buttons({
    Key? key,
    required this.onPress,
    required this.child,
    required this.height,
    required this.color,
    this.loading = false,
    required this.radius,
  }) : super(key: key);
  final bool loading;
  Function() onPress;
  Widget child;
  double height;
  Color color;
  double radius;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onPress,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: color,
          ),
          child: Center(
            child: loading
                ? const CircularProgressIndicator(color: Colors.white)
                : child,
          ),
        ),
      ),
    );
  }
}
