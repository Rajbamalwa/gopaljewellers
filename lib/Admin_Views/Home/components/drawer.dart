import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gopaljewellers/Admin_Views/Home/components/orders.dart';
import 'package:gopaljewellers/Admin_Views/Home/components/users.dart';
import 'package:provider/provider.dart';

import '../../../../constants/color.dart';
import '../../../Widgets/custom/customtext.dart';
import '../../../backend/supabase/models/productype_model.dart';
import '../../../provider/provider.dart';
import '../../Feedback/FeedBacks.dart';
import '../../Product/Types_Screen.dart';
import 'Notifications_screen.dart';

Widget homeDrawer(List categories, drawerProvider _drawerProvider, loadData,
    List<ProductTypeRows> typesList) {
  return Consumer<drawerProvider>(builder: (context, pro, child) {
    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: primaryColor3,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 20),
            height: MediaQuery.of(context).size.height * 0.2,
            color: primaryColor,
            child: Center(
              child: Image.asset(
                "assets/images/logo.png",
                scale: 5,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => TypesScreen()));
            },
            leading: Icon(
              Icons.format_list_bulleted,
              color: white,
            ),
            title: CustomText(
              "Product Types",
              white,
              13,
              FontWeight.w600,
              TextOverflow.fade,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);

              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => AdminOrderScreen()));
            },
            leading: Icon(
              Icons.fire_truck,
              color: white,
            ),
            title: CustomText(
              "Orders",
              white,
              13,
              FontWeight.w600,
              TextOverflow.fade,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => AllUsers()));
            },
            leading: Icon(
              Icons.person_2_outlined,
              color: white,
            ),
            title: CustomText(
              "Users",
              white,
              13,
              FontWeight.w600,
              TextOverflow.fade,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);

              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => NotificationScreen()));
            },
            leading: Icon(
              Icons.notification_add_outlined,
              color: white,
            ),
            title: CustomText(
              "Notifications",
              white,
              13,
              FontWeight.w600,
              TextOverflow.fade,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => FeedBack()));
            },
            leading: Icon(
              Icons.feedback_outlined,
              color: white,
            ),
            title: CustomText(
              "Feedbacks",
              white,
              13,
              FontWeight.w600,
              TextOverflow.fade,
            ),
          ),
          typesList.isEmpty
              ? SizedBox()
              : Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    itemCount: typesList.length,
                    itemBuilder: (context, index) {
                      var data = typesList[index];
                      return Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          maintainState: true,
                          initiallyExpanded: false,
                          // backgroundColor: white,
                          //  collapsedBackgroundColor: primaryColor,
                          // leading: Icon(
                          //   Icons.category_outlined,
                          //   color: white,
                          // ),
                          collapsedIconColor: Colors.grey,
                          iconColor: white,
                          title: CustomText(
                            data.type.toString(),
                            white,
                            13,
                            FontWeight.w600,
                            TextOverflow.fade,
                          ),
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: data.product_type.length,
                              itemBuilder: (context, index) {
                                var dat = data.product_type[index];
                                // return ListTile(
                                //   onTap: () {
                                //     log(data.product_type[index].toString());
                                //     pro.updateScreen(
                                //         data.product_type[index].toString());
                                //     loadData();
                                //     Navigator.pop(context);
                                //   },
                                //   tileColor: pro.items ==
                                //           data.product_type[index].toString()
                                //       ? white
                                //       : primaryColor,
                                //   title: CustomText(
                                //     dat.toString(),
                                //     pro.items ==
                                //             data.product_type[index].toString()
                                //         ? primaryColor
                                //         : white,
                                //     13,
                                //     FontWeight.w600,
                                //     TextOverflow.fade,
                                //   ),
                                // );
                                return InkWell(
                                  onTap: () {
                                    log(dat.toString());
                                    pro.updateScreen(dat.toString());
                                    loadData();
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: 40,
                                    color: pro.items ==
                                            data.product_type[index].toString()
                                        ? white
                                        : Colors.transparent,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: CustomText(
                                          dat.toString(),
                                          pro.items ==
                                                  data.product_type[index]
                                                      .toString()
                                              ? primaryColor
                                              : white,
                                          13,
                                          FontWeight.w600,
                                          TextOverflow.fade,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  });
}
