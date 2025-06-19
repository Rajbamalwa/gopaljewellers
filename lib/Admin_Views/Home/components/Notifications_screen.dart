import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../Widgets/button/gradient_button.dart';
import '../../../Widgets/custom/appBarWidget.dart';
import '../../../Widgets/custom/customtext.dart';
import '../../../Widgets/text_field/text_field_widget.dart';
import '../../../backend/supabase/models/user_model.dart';
import '../../../constants/color.dart';
import '../../../services/Apis.dart';
import '../../../utils/loading.dart';
import '../../../utils/utils.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  TextEditingController titleC = TextEditingController();
  TextEditingController bodyC = TextEditingController();
  List<UserRow> users = [];
  bool iSLoading = false;
  List tokens = [];
  int send = 0;
  getUsers() async {
    setState(() {
      iSLoading = true;
    });
    await UserTable()
        .queryRows(
      queryFn: (q) => q.order('id', ascending: false),
    )
        .then((value) {
      users.addAll(value);

      log(users.toString());
    });
    setState(() {
      iSLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: appBarWidget("Send Notification", true, [], () {
        Navigator.pop(context);
      }),
      body: iSLoading == true
          ? Center(
              child: showLoading(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                    child: ListTile(
                      title: CustomText2(
                        "Notification title",
                        bluish,
                        12,
                        FontWeight.w400,
                        TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  CustomTextField(
                    controller: titleC,
                    from: "FF",
                    hintText: "Title",
                    maxLines: 10,
                  ),
                  SizedBox(
                    height: 50,
                    child: ListTile(
                      title: CustomText2(
                        "Notification body",
                        bluish,
                        12,
                        FontWeight.w400,
                        TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  CustomTextField(
                    controller: bodyC,
                    from: "FF",
                    hintText: "Body",
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GradientButton(
                    width: width,
                    height: 50,
                    text: "Send",
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    fontColor: white,
                    onTap: () {
                      if (titleC.text.isEmpty || bodyC.text.isEmpty) {
                        Utils().toastMessage("Field is empty");
                      } else {
                        setState(() {
                          iSLoading = true;
                        });
                        for (var data in users) {
                          tokens.add(data.token['uid'].toString());
                        }

                        for (var token in tokens) {
                          log(token.toString());
                          setState(() {
                            send++;
                          });
                          ApiService.sendNotification(
                            token,
                            titleC.text,
                            bodyC.text,
                            "home",
                            "home_ID",
                          );
                        }
                        if (send == tokens.length) {
                          setState(() {
                            iSLoading = false;
                            titleC.clear();
                            bodyC.clear();
                            Utils().toastMessage("Notification Sent");
                          });
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
