import 'dart:developer';

import 'package:flutter/material.dart';

import '../../Widgets/custom/appBarWidget.dart';
import '../../Widgets/custom/customtext.dart';
import '../../backend/supabase/models/user_model.dart';
import '../../constants/color.dart';
import '../../utils/flutter_flow/default_value.dart';
import '../../utils/loading.dart';

class UserScreens extends StatefulWidget {
  var loadData;
  UserScreens({this.loadData});

  @override
  State<UserScreens> createState() => _UserScreensState();
}

class _UserScreensState extends State<UserScreens> {
  bool iSLoading = false;

  List<UserRow> users = [];
  getUsers() async {
    setState(() {
      iSLoading = true;
    });
    await UserTable()
        .queryRows(
      queryFn: (q) => q.order('id', ascending: false),
    )
        .then((value) {
      log(value.toString());
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        widget.loadData();
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        appBar: appBarWidget(
          "All Users",
          true,
          [],
          () {
            Navigator.pop(context);
          },
        ),
        body: iSLoading == true
            ? showLoading()
            : users.isEmpty
                ? Center(
                    child: CustomText2("No Users Found", secondaryTextColor, 15,
                        FontWeight.w600, TextOverflow.clip),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            var data = users[index];
                            return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: primaryColor,
                                  backgroundImage: NetworkImage(data
                                              .photo_url ==
                                          null
                                      ? "https://as1.ftcdn.net/v2/jpg/03/46/83/96/1000_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg"
                                      : data.photo_url.toString()),
                                ),
                                title: CustomText(
                                  valueOrDefault(data.user_name, "user"),
                                  black,
                                  16,
                                  FontWeight.w800,
                                  TextOverflow.ellipsis,
                                ),
                                subtitle: CustomText(
                                  valueOrDefault(data.user_phone, "Number"),
                                  secondaryTextColor,
                                  12,
                                  FontWeight.w600,
                                  TextOverflow.ellipsis,
                                ),
                                trailing: IconButton(
                                  splashRadius: 25,
                                  splashColor: red.withOpacity(0.1),
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.delete_outline_outlined,
                                    color: red,
                                  ),
                                ));
                          },
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
