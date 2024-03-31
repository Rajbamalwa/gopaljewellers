import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gopaljewellers/Widgets/button/gradient_button.dart';
import 'package:gopaljewellers/Widgets/custom/appBarWidget.dart';
import 'package:gopaljewellers/backend/authentication/auth_util.dart';
import 'package:gopaljewellers/utils/utils.dart';

import '../../../../backend/schema/users_record.dart';
import '../../../../constants/color.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  bool _isEditing = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _numberController.text = "+91 $currentPhoneNumber";
    _nameController.text = currentUserDisplayName.toString();
  }

  bool updating = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: appBarWidget("Profile", true, [
        Transform.scale(
          scale: 0.6,
          child: Container(
            width: 50,
            height: 45,
            decoration: ShapeDecoration(
              color: transparent,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 0.50,
                    color: _isEditing == false
                        ? primaryColor22.withOpacity(0.6)
                        : secondaryTextColor.withOpacity(0.6)),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: IconButton(
                tooltip:
                    _isEditing == true ? "Enable Editing" : "Disable Editing",
                onPressed: () {
                  setState(() {
                    _isEditing = !_isEditing;
                  });
                },
                icon: Icon(
                  Icons.edit,
                  color:
                      _isEditing == false ? primaryColor22 : secondaryTextColor,
                )),
          ),
        ),
      ], () {
        Navigator.pop(context);
      }),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // GestureDetector(onTap: () {}, child: _buildProfileWidget()),
              // SizedBox(height: 20),
              Container(
                height: 60,
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _nameController,
                  onChanged: (value) {},
                  cursorWidth: 1.0,
                  readOnly: _isEditing,
                  onFieldSubmitted: (value) {},
                  style: GoogleFonts.alata(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: black,
                  ),
                  decoration: InputDecoration(
                    suffixIcon: updating == true
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              color: primaryColor,
                              strokeWidth: 1,
                            ),
                          )
                        : null,
                    labelStyle: GoogleFonts.alata(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: secondaryTextColor,
                    ),
                    hintText: "Name",

                    hintStyle: GoogleFonts.alata(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: secondaryTextColor,
                    ),
                    contentPadding: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 10, right: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor22),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: secondaryTextColor.withOpacity(0.4)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor22),
                    ),

                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    isDense: false,

                    // border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 60,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _numberController,
                  onChanged: (value) {},
                  cursorWidth: 1.0,
                  readOnly: true,
                  onFieldSubmitted: (value) {},
                  style: GoogleFonts.alata(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: black,
                  ),
                  decoration: InputDecoration(
                    labelStyle: GoogleFonts.alata(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: secondaryTextColor,
                    ),
                    hintText: "Mobile Number",
                    hintStyle: GoogleFonts.alata(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: secondaryTextColor,
                    ),
                    contentPadding: EdgeInsets.only(
                        top: 10, bottom: 10, left: 10, right: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor22),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: secondaryTextColor.withOpacity(0.4)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor22),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    isDense: false,
                  ),
                ),
              ),
              SizedBox(height: 20),
              _isEditing == true
                  ? SizedBox()
                  : GradientButton(
                      width: width,
                      height: 50,
                      text: "Update",
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      fontColor: white,
                      onTap: () {
                        if (_nameController.text.isEmpty ||
                            _nameController.text == "") {
                          Utils().toastMessage("Name field is empty");
                        } else {
                          setState(() {
                            updating = true;
                          });
                          FirebaseAuth.instance.currentUser!
                              .updateDisplayName(
                                  _nameController.text.toString())
                              .onError((error, stackTrace) {
                            setState(() {
                              updating = false;
                            });
                            Utils().toastMessage(error.toString());
                          });
                          UsersRecord.updateDocument({
                            "display_name": _nameController.text.toString(),
                          }).then((value) {
                            setState(() {
                              _isEditing = true;
                              updating = false;
                            });
                            Utils().toastMessage("Updated");
                          }).onError((error, stackTrace) {
                            setState(() {
                              updating = false;
                            });
                          });
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileWidget() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue,
        ),
        child: Icon(
          Icons.account_circle,
          size: 100,
          color: Colors.white,
        ),
      ),
    );
  }
}
