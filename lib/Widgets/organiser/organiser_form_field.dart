import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/color.dart';
import '../custom/customtext.dart';

class organiser_form_widget extends StatelessWidget {
  const organiser_form_widget({
    super.key,
    required this.controller,
    required this.text,
    required this.maxLines,
    required this.fieldHeight,
    required this.fieldType,
    required this.focusNode,
    required this.nextFocusNode,
    required this.isProvideLength,
    this.inputFormattersLength,
  });

  final TextEditingController controller;
  final String text;
  final int maxLines;
  final double fieldHeight;
  final TextInputType fieldType;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final bool isProvideLength;
  final int? inputFormattersLength;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 10, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: CustomText(
                  text,
                  black,
                  13,
                  FontWeight.w500,
                  TextOverflow.ellipsis,
                ),
              ),
            ),
            SizedBox(
              height: fieldHeight,
              child: TextFormField(
                onChanged: (value) {},
                onFieldSubmitted: (value) {
                  focusNode.unfocus();
                  FocusScope.of(context).requestFocus(nextFocusNode);
                },
                focusNode: focusNode,
                controller: controller,
                maxLines: maxLines,
                keyboardType: fieldType,
                cursorColor: black,
                readOnly: false,
                scrollPadding: EdgeInsets.zero,
                style: GoogleFonts.inter(
                    fontSize: 13, fontWeight: FontWeight.w500, color: black),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade600, width: 0.3),
                      borderRadius: BorderRadius.circular(14)),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade600, width: 0.3),
                      borderRadius: BorderRadius.circular(14)),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade600, width: 0.3),
                      borderRadius: BorderRadius.circular(14)),
                  hintText: text,
                  hintStyle: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade500),

                  // labelStyle: GoogleFonts.inter(
                  //     fontSize: 13, fontWeight: FontWeight.w500, color: black),
                  // label: CustomText(
                  //   text,
                  //   black,
                  //   13,
                  //   FontWeight.w500,
                  //   TextOverflow.ellipsis,
                  // ),
                ),
                inputFormatters: isProvideLength == true
                    ? [LengthLimitingTextInputFormatter(10)]
                    : null,
              ),
            ),
          ],
        ));
  }
}
