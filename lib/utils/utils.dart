import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Widgets/custom/customtext.dart';
import '../constants/color.dart';

class Utils {
  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: black,
        textColor: white,
        fontSize: 15);
  }

  void toastStop() async {
    await Fluttertoast.cancel();
  }

  captureScreenShotAndText(screenshotController, text) async {
    await screenshotController
        .capture(delay: const Duration(milliseconds: 10))
        .then((image) async {
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/image.png').create();
        await imagePath.writeAsBytes(image);

        /// Share Plugin
        await Share.shareFilesWithResult([imagePath.path], text: text);
      }
    });
  }

  launchEP(scheme, String path) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: path,
    );
    await launchUrl(emailLaunchUri);
  }

  launch(String link) async {
    final Uri url = Uri.parse(link.toString());
    await launchUrl(url);
  }

  Future<void> showBackAlert(context, {required bool check}) async {
    return check == false
        ? showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                contentPadding: EdgeInsets.only(top: 15),
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: CustomText("Are you sure you want cancel booking?",
                        black, 14, FontWeight.w600, TextOverflow.clip),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: CustomText("Cancel", black, 14, FontWeight.w600,
                        TextOverflow.clip),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: CustomText(
                      "Sure",
                      red,
                      14,
                      FontWeight.w600,
                      TextOverflow.ellipsis,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          )
        : showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                contentPadding: EdgeInsets.only(top: 15),
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    child: Align(
                      alignment: Alignment.center,
                      child: CustomText("Are you sure you want quit?", black,
                          14, FontWeight.w600, TextOverflow.clip),
                    ),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: CustomText("Cancel", black, 14, FontWeight.w600,
                        TextOverflow.clip),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      // backgroundColor: red.withOpacity(0.2),
                      splashFactory: InkSplash.splashFactory,
                      foregroundColor: red.withOpacity(0.2),
                    ),
                    child: CustomText(
                      "Sure",
                      red,
                      14,
                      FontWeight.w600,
                      TextOverflow.ellipsis,
                    ),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                ],
              );
            },
          );
  }
}

notificationPermission() async {
  // Pushing Notification Permission
  final PermissionStatus status = await Permission.notification.status;
  if (status.isDenied) {
    await Permission.notification.request();
  }
}
