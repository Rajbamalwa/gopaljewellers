import 'package:flutter/material.dart';

class ShrinkButton extends StatefulWidget {
  final Widget child;
  final Function onPressed;
  final double shrinkScale;
  final double height;
  final double width;
  final Color color;
  ShrinkButton(
      {required this.child,
      required this.onPressed,
      this.shrinkScale = 0.9,
      required this.width,
      required this.height,
      required this.color});

  @override
  _ShrinkButtonState createState() => _ShrinkButtonState();
}

class _ShrinkButtonState extends State<ShrinkButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        _controller.forward();
        Future.delayed(Duration(milliseconds: 200), () {
          _controller.reverse().then((value) {});
        });
      },
      onTap: () {
        _controller.forward();
        Future.delayed(Duration(milliseconds: 200), () {
          _controller.reverse().then((value) {
            widget.onPressed();
          });
        });
      },
      child: ScaleTransition(
          scale: Tween<double>(
            begin: 1.0,
            end: widget.shrinkScale,
          ).animate(_controller),
          child: Container(
            child: Center(child: widget.child),
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: widget.color),
          )),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
