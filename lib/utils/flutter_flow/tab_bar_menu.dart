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
      labelColor: black,
      unselectedLabelColor: grey,
      labelStyle: GoogleFonts.inter(
        color: black,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.alata(
        color: secondaryTextColor,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      indicatorColor: black,
      indicatorWeight: 3,
      tabs: List.generate(
          tabTitle.length,
          (index) => Tab(
                text: tabTitle[index],
              )),
    );
  }
}
