import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/color.dart';

class TabBarMenu extends StatelessWidget {
  const TabBarMenu({
    Key? key,
    required this.tabTitle,
  }) : super(key: key);

  final List<String> tabTitle;
  @override
  Widget build(BuildContext context) {
    return TabBar(
      labelColor: primaryColor3,
      unselectedLabelColor: grey,
      labelStyle: TextStyle(
        color: primaryColor3,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        color: secondaryTextColor,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      indicatorColor: primaryColor3,
      indicator: BoxDecoration(
        color: primaryColor3.withOpacity(0.1),
        border: Border.symmetric(
          horizontal: BorderSide(
            color: primaryColor3,
            width: 2,
          ),
          vertical: BorderSide.none,
        ),
      ),
      indicatorWeight: 3,
      tabs: List.generate(
          tabTitle.length,
          (index) => Tab(
                text: tabTitle[index],
              )),
    );
  }
}
