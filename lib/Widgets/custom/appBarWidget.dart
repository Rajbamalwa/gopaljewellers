import 'package:flutter/material.dart';

import '../../constants/color.dart';
import 'customtext.dart';

AppBar appBarWidget(
  text,
  backVisible,
  List<Widget>? actions,
  onPress,
) {
  return AppBar(
    automaticallyImplyLeading: backVisible,
    // backgroundColor: white,

    elevation: 0,
    leading: backVisible == false
        ? null
        : LeadingIcon(
            onpress: onPress,
          ),
    title: CustomText(
      text,
      white,
      20,
      FontWeight.w900,
      TextOverflow.ellipsis,
    ),
    actions: actions,
  );
}

class LeadingIcon extends StatelessWidget {
  final onpress;
  const LeadingIcon({
    Key? key,
    required this.onpress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.6,
      child: Container(
        width: 36,
        height: 36,
        decoration: ShapeDecoration(
          color: transparent,
          shape: RoundedRectangleBorder(
            side:
                BorderSide(width: 0.50, color: primaryColor22.withOpacity(0.6)),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: IconButton(
            onPressed: onpress,
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: primaryColor22,
            )),
      ),
    );
  }
}

Widget backIcon(context) {
  return GestureDetector(
    onTap: () {
      Navigator.pop(context);
    },
    child: Container(
      child: Center(
        child: Image.asset(
          "assets/images/back.png",
          scale: 1,
        ),
      ),
    ),
  );
}
