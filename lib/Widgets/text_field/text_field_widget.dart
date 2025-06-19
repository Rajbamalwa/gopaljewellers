// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import '../../constants/color.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.lableStyle,
    this.hintText,
    this.obscureText,
    this.validator,
    this.controller,
    this.keyboardType,
    this.inputFormater,
    this.title,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.readOnly,
    this.onSaved,
    this.label,
    this.autofocus,
    this.fontWeight,
    this.onChanged,
    this.FocusNode,
    this.onTap,
    this.maxLines,
    this.from,
  }) : super(key: key);
  final labelText;
  final prefixIcon;
  final suffixIcon;
  final lableStyle;
  final maxLines;
  final hintText;
  final FocusNode;

  final obscureText;
  final controller;

  final validator;
  final keyboardType;
  final inputFormater;
  final onChanged;
  final title;
  final inputFormatters;
  final onFieldSubmitted;
  final readOnly;
  final onSaved;

  final label;
  final autofocus;
  final fontWeight;
  final onTap;
  final from;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: TextFormField(
        onTap: onTap,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        controller: controller,
        onChanged: onChanged,
        cursorWidth: 1.0,
        focusNode: FocusNode,
        readOnly: readOnly ?? false,
        onFieldSubmitted: onFieldSubmitted,
        onSaved: onSaved,
        minLines: 1,
        maxLines: maxLines,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: black,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,

          labelStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: from == "FF" ? black : secondaryTextColor,
          ),
          hintText: hintText,

          hintStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: from == "FF" ? black : secondaryTextColor,
          ),
          contentPadding:
              EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade600),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color:
                    from == "FF" ? Colors.grey.shade300 : Colors.grey.shade600),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade600),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          isDense: false,

          // border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
