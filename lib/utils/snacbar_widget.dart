import 'package:flutter/material.dart';

import '../constants/color.dart';

showSnackBar(BuildContext context, String title, bool isErrorSnackBar,
    VoidCallback callback) {
  final snackBar = SnackBar(
    content: Text(
      title,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: isErrorSnackBar ? red : green,
    action: SnackBarAction(
      label: 'ok',
      textColor: black,
      onPressed: callback,
    ),
  );
  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
