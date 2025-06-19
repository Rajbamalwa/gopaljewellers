import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../Widgets/custom/appBarWidget.dart';
import '../../../Widgets/custom/customtext.dart';
import '../../../backend/supabase/models/user_model.dart';
import '../../../constants/color.dart';
import '../../../utils/flutter_flow/date_format.dart';
import '../../../utils/loading.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUsers();
    });
  }

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

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: appBarWidget("All Users", true, [], () {
        Navigator.pop(context);
      }),
      body: iSLoading == true
          ? Center(child: showLoading())
          : users.isEmpty
              ? Center(
                  child: CustomText2("No user found", secondaryTextColor, 15,
                      FontWeight.w600, TextOverflow.clip),
                )
              : RawScrollbar(
                  interactive: true,
                  thumbVisibility: true,
                  thumbColor: primaryColor,
                  radius: const Radius.circular(4),
                  crossAxisMargin: 1,
                  controller: scrollController,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: users.length,
                          padding: EdgeInsets.only(top: 10),
                          itemBuilder: (context, index) {
                            var user = users[index];
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, bottom: 10, right: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          secondaryTextColor.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                    )
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          user.photo_url == null
                                              ? "https://as1.ftcdn.net/v2/jpg/03/46/83/96/1000_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg"
                                              : user.photo_url.toString(),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      title: CustomText(
                                          user.user_name.toString(),
                                          black,
                                          20,
                                          FontWeight.w900,
                                          TextOverflow.clip),
                                      subtitle: CustomText2(
                                          user.user_phone.toString(),
                                          secondaryTextColor,
                                          12,
                                          FontWeight.w500,
                                          TextOverflow.clip),
                                      // trailing: IconButton(
                                      //   onPressed: () {},
                                      //   icon: Icon(
                                      //     Icons.delete_outline_outlined,
                                      //     color: red,
                                      //   ),
                                      // ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          CustomText2(
                                              dateTimeFormat("EEE, dd MMM y",
                                                  user.createdAt),
                                              secondaryTextColor,
                                              12,
                                              FontWeight.w500,
                                              TextOverflow.clip),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
