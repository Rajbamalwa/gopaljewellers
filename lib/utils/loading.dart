import 'package:flutter/material.dart';
import 'package:gopaljewellers/constants/color.dart';

Widget showLoading() {
  // return Center(
  //   child: SizedBox(
  //     height: 50.0,
  //     width: 50.0,
  //     child: CircularProgressIndicator(
  //       color: primaryColor,
  //       strokeWidth: 2,
  //       valueColor: AlwaysStoppedAnimation(
  //         primaryColor,
  //       ),
  //     ),
  //   ),
  // );
  return Center(
    child: Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: primaryColor22,
          strokeWidth: 1,
        ),
      ),
    ),
  );
}
