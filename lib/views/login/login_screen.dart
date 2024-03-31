import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gopaljewellers/Widgets/custom/appBarWidget.dart';
import 'package:gopaljewellers/views/Home/home_screen.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../../utils/snacbar_widget.dart';
import '../../Widgets/button/gradient_button.dart';
import '../../Widgets/custom/customtext.dart';
import '../../backend/supabase/Supabase.dart';
import '../../constants/color.dart';
import '../../utils/loading.dart';
import '../../utils/utils.dart';

class PhoneView extends StatefulWidget {
  const PhoneView({super.key});

  @override
  State<PhoneView> createState() => _PhoneViewState();
}

class _PhoneViewState extends State<PhoneView> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool isPhoneVisible = false;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(() {
      if (controller.text.length == 10) {
        setState(() {
          isPhoneVisible = true;
        });
      } else {
        setState(() {
          isPhoneVisible = false;
        });
      }
    });
  }

  final key = GlobalKey<ScaffoldState>();
  String userNumber = '';

  FirebaseAuth auth = FirebaseAuth.instance;

  var otpFieldVisibility = false;
  var receivedID = '';

  void verifyUserPhoneNumber() {
    auth.verifyPhoneNumber(
      phoneNumber: userNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then(
              (value) => print('Logged In Successfully'),
            );
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        receivedID = verificationId;
        otpFieldVisibility = true;
        setState(() {});
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  bool isOtpSent = false;
  var vId;

  CountdownController countdownController =
      CountdownController(autoStart: true);
  OtpFieldController otpbox = OtpFieldController();

  String _otpvalue = "";
  bool timeout = false;
  bool readOnly = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: key,
      backgroundColor: white,
      appBar: appBarWidget(
          isOtpSent == true ? "Otp" : "Login",
          isOtpSent == true ? true : false,
          [
            isOtpSent == true
                ? SizedBox()
                : Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => HomeScreen()));
                      },
                      child: CustomText(
                        "Skip",
                        primaryColor22,
                        12,
                        FontWeight.w600,
                        TextOverflow.clip,
                      ),
                    ),
                  ),
            const SizedBox(
              width: 10,
            ),
          ],
          isOtpSent == true
              ? () {
                  Navigator.pop(context);
                }
              : () {}),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: Image.asset(
                        "assets/images/logo.png",
                        scale: 5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: CustomText(
                            isOtpSent == true
                                ? "Verification code has been sent to +91 ${controller.text}"
                                : 'Please provide your mobile number for OTP verification.',
                            white.withOpacity(0.5),
                            14,
                            FontWeight.w800,
                            TextOverflow.clip),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 0, right: 20),
                child: Container(
                  width: width,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(20),
                    // border: Border.all(color: black, width: 1.2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20, top: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        isOtpSent == true
                            ? SizedBox()
                            : Container(
                                height: 60,
                                // width: width * 0.8,
                                decoration: BoxDecoration(
                                  border: Border.all(color: black),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                ),
                                child: TextField(
                                  readOnly: readOnly,
                                  focusNode: focusNode,
                                  onSubmitted: (value) {
                                    focusNode.unfocus();
                                  },
                                  style: GoogleFonts.roboto(
                                    color: black,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                  ),
                                  keyboardType: TextInputType.number,
                                  controller: controller,
                                  cursorHeight: 15,
                                  cursorColor: black,
                                  decoration: InputDecoration(
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        "+91",
                                        style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14,
                                          color: black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.only(
                                        left: 7, top: 20, bottom: 20),
                                    hintStyle: TextStyle(color: Colors.black54),
                                    hintText: " Enter your mobile number",
                                    focusedBorder: InputBorder.none,
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    isDense: false,
                                  ),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        isOtpSent == true
                            ? OTPTextField(
                                outlineBorderRadius: 10,
                                controller: otpbox,
                                length: 6,
                                width: MediaQuery.of(context).size.width,
                                fieldWidth: 40,
                                style: GoogleFonts.inter(
                                  color: black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                                textFieldAlignment:
                                    MainAxisAlignment.spaceAround,
                                fieldStyle: FieldStyle.box,
                                otpFieldStyle: OtpFieldStyle(
                                  focusBorderColor: primaryColor,
                                  borderColor: primaryColor,
                                  disabledBorderColor: secondaryTextColor,
                                  enabledBorderColor: primaryColor22,
                                ),
                                onChanged: (pin) {
                                  setState(() {
                                    _otpvalue = pin;
                                  });
                                },
                                onCompleted: (pin) async {
                                  setState(() {
                                    _otpvalue = pin;
                                  });
                                  // verifyOTPCode(
                                  //     _otpvalue, vId, controller.text);
                                },
                              )
                            : SizedBox(),
                        loading == true
                            ? SizedBox()
                            : isOtpSent == true
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 20,
                                        right: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Countdown(
                                          controller: countdownController,
                                          interval: const Duration(
                                              milliseconds: 1000),
                                          seconds: 60,
                                          build: (_, remainingTime) => CustomText(
                                              "00:${(remainingTime.toString().length == 4) ? remainingTime.toString().substring(0, 2) : "0${remainingTime.toString().substring(0, 1)}"}",
                                              black,
                                              14,
                                              FontWeight.w700,
                                              TextOverflow.clip),
                                          onFinished: () {
                                            setState(() {
                                              timeout = true;
                                            });
                                          },
                                        ),
                                        TextButton(
                                            onPressed: timeout == false
                                                ? () {}
                                                : () async {
                                                    if (controller
                                                        .text.isEmpty) {
                                                      Utils().toastMessage(
                                                          "Please add mobile number");
                                                    } else {
                                                      setState(() {
                                                        loading = true;
                                                      });
                                                      // FirebaseAuth.instance.currentUser!.updatePhoneNumber();
                                                      await FirebaseAuth
                                                          .instance
                                                          .verifyPhoneNumber(
                                                        phoneNumber:
                                                            '+91 ${controller.text}',
                                                        verificationCompleted:
                                                            (PhoneAuthCredential
                                                                credential) {},
                                                        verificationFailed:
                                                            (FirebaseAuthException
                                                                e) {
                                                          showSnackBar(
                                                              context,
                                                              e.toString(),
                                                              true,
                                                              () {});
                                                        },
                                                        codeSent: (String
                                                                verificationId,
                                                            int? resendToken) {
                                                          Utils().toastMessage(
                                                              "Please check your default message app for otp.");
                                                          setState(() {
                                                            isOtpSent = true;
                                                            loading = false;
                                                            readOnly = true;
                                                            vId =
                                                                verificationId;
                                                            countdownController
                                                                .autoStart;
                                                          });
                                                          // Navigator.push(
                                                          //     context,
                                                          //     MaterialPageRoute(
                                                          //         builder: (_) => OtpScreen(
                                                          //             vid: verificationId,
                                                          //             num: controller.text)));
                                                        },
                                                        codeAutoRetrievalTimeout:
                                                            (String
                                                                verificationId) {
                                                          // setState(() {
                                                          //   loading = false;
                                                          // });
                                                        },
                                                      )
                                                          .then((value) {
                                                        // setState(() {
                                                        //   loading = false;
                                                        // });
                                                      }).onError((error,
                                                              stackTrace) {
                                                        setState(() {
                                                          loading = false;
                                                        });
                                                        showSnackBar(
                                                            context,
                                                            error.toString(),
                                                            true,
                                                            () {});
                                                      });
                                                    }
                                                  },
                                            child: CustomText(
                                                "Resend",
                                                timeout == true
                                                    ? primaryColor
                                                    : secondaryTextColor,
                                                14,
                                                FontWeight.w700,
                                                TextOverflow.clip)),
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              loading == true
                  ? Center(child: showLoading())
                  : Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: GradientButton(
                        width: width,
                        height: 60,
                        text: isOtpSent == false ? "Get Otp" : "Verify",
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontColor: black,
                        onTap: isPhoneVisible == true
                            ? () async {
                                if (isOtpSent == false) {
                                  if (controller.text.isEmpty) {
                                    Utils().toastMessage(
                                        "Please add mobile number");
                                  } else {
                                    setState(() {
                                      loading = true;
                                      // timeout = false;
                                    });
                                    // FirebaseAuth.instance.currentUser!.updatePhoneNumber();
                                    await FirebaseAuth.instance
                                        .verifyPhoneNumber(
                                      phoneNumber: '+91 ${controller.text}',
                                      verificationCompleted:
                                          (PhoneAuthCredential credential) {},
                                      verificationFailed:
                                          (FirebaseAuthException e) {
                                        log(e.toString());
                                        showSnackBar(
                                            context, e.toString(), true, () {});
                                      },
                                      codeSent: (String verificationId,
                                          int? resendToken) {
                                        log("message");
                                        Utils().toastMessage(
                                            "Please check your default message app for otp.");
                                        setState(() {
                                          isOtpSent = true;
                                          loading = false;
                                          readOnly = true;
                                          vId = verificationId;
                                          countdownController.restart();
                                        });
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (_) => OtpScreen(
                                        //             vid: verificationId,
                                        //             num: controller.text)));
                                      },
                                      codeAutoRetrievalTimeout:
                                          (String verificationId) {
                                        // setState(() {
                                        //   loading = false;
                                        // });
                                      },
                                    )
                                        .then((value) {
                                      // setState(() {
                                      //   loading = false;
                                      // });
                                    }).onError((error, stackTrace) {
                                      setState(() {
                                        loading = false;
                                      });
                                      log(error.toString());

                                      showSnackBar(context, error.toString(),
                                          true, () {});
                                    });
                                  }
                                } else {
                                  verifyOTPCode(
                                      _otpvalue, vId, controller.text);
                                }
                              }
                            : () {},
                      ),
                    ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> verifyOTPCode(value, vid, nu) async {
    setState(() {
      loading = true;
    });
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: vid,
      smsCode: value,
    );
    await auth.signInWithCredential(credential).then((value) {
      SupaFlow.client.from('users').insert({
        'display_name': value.user!.toString(),
        'email': value.user!.email ?? "",
        'photo_url': value.user!.photoURL ??
            "https://cdn-icons-png.flaticon.com/512/149/149071.png",
        'uid': value.user!.uid.toString(),
        'user_number': nu.toString(),
        "users": "Customer",
        "created_time": DateTime.now(),
      });

      FirebaseFirestore.instance
          .collection("users")
          .doc(value.user!.uid.toString())
          .set({
        'display_name': value.user!.displayName ?? "",
        'email': value.user!.email ?? "",
        'photo_url': value.user!.photoURL ??
            "https://cdn-icons-png.flaticon.com/512/149/149071.png",
        'uid': value.user!.uid.toString(),
        'phone_number': nu.toString(),
        "users": "Customer",
        "created_time": DateTime.now(),
        "fcmTokens": "",
      }).then((value) {
        setState(() {
          loading = false;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomeScreen()));
      });
    }).onError((FirebaseAuthException error, stackTrace) {
      log(error.toString());
      log(error.toString());
      setState(() {
        loading = false;
      });
      showSnackBar(context, error.message.toString(), true, () {});
    });
  }
}
