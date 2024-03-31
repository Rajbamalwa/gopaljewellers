import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gopaljewellers/Widgets/button/gradient_button.dart';
import 'package:gopaljewellers/Widgets/custom/appBarWidget.dart';
import 'package:gopaljewellers/Widgets/custom/customtext.dart';
import 'package:gopaljewellers/Widgets/text_field/text_field_widget.dart';
import 'package:gopaljewellers/backend/authentication/auth_util.dart';
import 'package:gopaljewellers/backend/supabase/models/feedback_model.dart';
import 'package:gopaljewellers/utils/utils.dart';
import 'package:marquee/marquee.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/color.dart';

// import 'package:google_maps_flutter/google_maps_flutter.dart';
class AbountUsScreen extends StatefulWidget {
  const AbountUsScreen({super.key});

  @override
  State<AbountUsScreen> createState() => _AbountUsScreenState();
}

class _AbountUsScreenState extends State<AbountUsScreen> {
  // final Completer<GoogleMapController> _controller =
  //     Completer<GoogleMapController>();
  //
  // static const CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );
  //
  // static const CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);

  late TextEditingController nameC;
  late TextEditingController phoneC;
  late TextEditingController emailC;
  late TextEditingController subjectC;
  late TextEditingController messageC;

  FocusNode nameF = FocusNode();
  FocusNode phoneF = FocusNode();
  FocusNode emailF = FocusNode();
  FocusNode subjectF = FocusNode();
  FocusNode messageF = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameC = TextEditingController(
      text: currentUserDisplayName.toString(),
    );
    emailC = TextEditingController(
      text: currentUserEmail.toString(),
    );
    phoneC = TextEditingController(
      text: currentPhoneNumber.toString(),
    );
    subjectC = TextEditingController();
    messageC = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: appBarWidget("About us", true, [], () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: primaryColor,
                  border: Border.fromBorderSide(BorderSide.none)),
              height: 25,
              child: Marquee(
                text: 'Download BBC Gold for live gold and silver prices.',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: primaryColor22),
                scrollAxis: Axis.horizontal,
                blankSpace: 40.0,
                startPadding: 10.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () async {
                  var lat = "19.145489";
                  var lng = "77.325166";
                  String url = Platform.isIOS
                      ? 'https://maps.apple.com/?q=$lat,$lng'
                      : 'https://maps.apple.com/?q=$lat,$lng';

                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    print(' could not launch $url');
                  }
                },
                child: Container(
                  width: width,
                  decoration: BoxDecoration(
                    color: primaryColor3,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: primaryColor22, width: 10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: primaryColor22,
                        child: Icon(
                          Icons.location_on_outlined,
                          color: primaryColor,
                          size: 30,
                          weight: 30,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomText2(
                        "ADDRESS",
                        primaryColor22,
                        22,
                        FontWeight.w800,
                        TextOverflow.clip,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          "Gopal Jewellers Opps. Sonya Maruti, Sarafa Bazar, Nanded - 431604",
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: InkWell(
                onTap: () async {
                  String url = Platform.isIOS
                      ? 'mailto://app.jewellery@gmail.com'
                      : 'mailto:app.jewellery@gmail.com';

                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    print(' could not launch mailto://app.jewellery@gmail.com');
                  }
                },
                child: Container(
                  width: width,
                  decoration: BoxDecoration(
                    color: primaryColor3,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: primaryColor22, width: 10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: primaryColor22,
                        child: Icon(
                          Icons.email_outlined,
                          color: primaryColor,
                          size: 30,
                          weight: 30,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomText2(
                        "EMAIL",
                        primaryColor22,
                        22,
                        FontWeight.w800,
                        TextOverflow.clip,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          "app.jewellery@gmail.com",
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () async {
                  String url =
                      Platform.isIOS ? 'tel://8888888888' : 'tel:8888888888';

                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    print(' could not launch tel://8888888888');
                  }
                },
                child: Container(
                  width: width,
                  decoration: BoxDecoration(
                    color: primaryColor3,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: primaryColor22, width: 10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: primaryColor22,
                        child: Icon(
                          Icons.phone_outlined,
                          color: primaryColor,
                          size: 30,
                          weight: 30,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomText2(
                        "Contact Number",
                        primaryColor22,
                        22,
                        FontWeight.w800,
                        TextOverflow.clip,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          "+91 88888888888",
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
              child: Container(
                width: width,
                decoration: BoxDecoration(
                  color: primaryColor3,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: primaryColor22, width: 10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    CustomText2(
                      "FEEDBACK FORM",
                      primaryColor22,
                      22,
                      FontWeight.w600,
                      TextOverflow.clip,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      controller: nameC,
                      from: "FF",
                      hintText: "Name",
                      maxLines: 1,
                      keyboardType: TextInputType.name,
                      FocusNode: nameF,
                      onFieldSubmitted: (value) {
                        onSubmitted(nameF, phoneF);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      controller: phoneC,
                      from: "FF",
                      hintText: "Phone Number",
                      maxLines: 1,
                      keyboardType: TextInputType.phone,
                      FocusNode: phoneF,
                      onFieldSubmitted: (value) {
                        onSubmitted(phoneF, emailF);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      controller: emailC,
                      from: "FF",
                      hintText: "Email",
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      FocusNode: emailF,
                      onFieldSubmitted: (value) {
                        onSubmitted(emailF, subjectF);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      controller: subjectC,
                      from: "FF",
                      hintText: "Subject",
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      FocusNode: subjectF,
                      onFieldSubmitted: (value) {
                        onSubmitted(subjectF, messageF);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      controller: messageC,
                      from: "FF",
                      hintText: "Message",
                      keyboardType: TextInputType.name,
                      FocusNode: messageF,
                      onFieldSubmitted: (value) {
                        messageF.unfocus();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GradientButton(
                        width: width,
                        height: 40,
                        text: "Submit",
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        fontColor: black,
                        onTap: () {
                          if (nameC.text.isEmpty ||
                              phoneC.text.isEmpty ||
                              emailC.text.isEmpty ||
                              subjectC.text.isEmpty ||
                              messageC.text.isEmpty) {
                            Utils().toastMessage("Field is empty");
                          } else if (!emailC.text.contains("@gmail.com")) {
                            Utils().toastMessage("Email is invalid");
                          } else {
                            FeedBacktable().insert({
                              "name": nameC.text,
                              "phone": phoneC.text,
                              "email": emailC.text,
                              "user_uid": currentUserUid,
                              "subject": subjectC.text,
                              "message": messageC.text,
                            }).then((value) {
                              setState(() {
                                nameC.clear();
                                phoneC.clear();
                                emailC.clear();
                                subjectC.clear();
                                messageC.clear();
                              });
                              Utils().toastMessage("Thankyou");
                            }).onError((error, stackTrace) {
                              Utils().toastMessage("Something went wrong!!");
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  onSubmitted(FocusNode cF, FocusNode nF) {
    cF.unfocus();
    FocusScope.of(context).requestFocus(nF);
  }
}
