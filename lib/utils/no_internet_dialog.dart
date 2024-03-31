import 'package:flutter/material.dart';

import '../Widgets/custom/customtext.dart';
import '../constants/color.dart';

Future<void> showMyDialog(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: CustomText('No Connection found!!', black, 20, FontWeight.w600,
            TextOverflow.ellipsis),
        content: SizedBox(
          child: Image.asset(
            "assets/images/noInternet.png",
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: CustomText(
                'Exit', black, 20, FontWeight.w600, TextOverflow.ellipsis),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
