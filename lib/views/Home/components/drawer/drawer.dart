import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gopaljewellers/Widgets/custom/customtext.dart';
import 'package:gopaljewellers/backend/supabase/models/productype_model.dart';
import 'package:gopaljewellers/provider/provider.dart';
import 'package:provider/provider.dart';

import '../../../../constants/color.dart';

Widget homeDrawer(
    drawerProvider _drawerProvider, loadData, List<ProductTypeRows> typesList) {
  return Consumer<drawerProvider>(builder: (context, pro, child) {
    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: primaryColor3,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 20),
            height: MediaQuery.of(context).size.height * 0.25,
            color: primaryColor,
            child: Center(
              child: Image.asset(
                "assets/images/logo.png",
                scale: 5,
              ),
            ),
          ),
          // ListTile(
          //   tileColor: white,
          //   onTap: () {
          //     Navigator.pop(context);
          //
          //     Navigator.push(
          //         context, MaterialPageRoute(builder: (_) => AbountUsScreen()));
          //   },
          //   leading: Icon(
          //     Icons.info_outline,
          //     color: primaryColor,
          //   ),
          //   title: CustomText(
          //     "About us",
          //     black,
          //     13,
          //     FontWeight.w600,
          //     TextOverflow.fade,
          //   ),
          // ),
          // Theme(
          //   data: Theme.of(context).copyWith(dividerColor: transparent),
          //   child: ExpansionTile(
          //     maintainState: true,
          //     initiallyExpanded: false,
          //     // backgroundColor: white,
          //     //  collapsedBackgroundColor: primaryColor,
          //     // leading: Icon(
          //     //   Icons.category_outlined,
          //     //   color: white,
          //     // ),
          //
          //     collapsedIconColor: Colors.grey,
          //     iconColor: white,
          //     title: CustomText(
          //       "My Account",
          //       white,
          //       13,
          //       FontWeight.w600,
          //       TextOverflow.fade,
          //     ),
          //     children: [
          //       ListTile(
          //         onTap: () {
          //           if (currentPhoneNumber.isEmpty) {
          //             Utils().toastMessage("Please login");
          //           } else {
          //             Navigator.pop(context);
          //
          //             Navigator.push(context,
          //                 MaterialPageRoute(builder: (_) => ProfileScreen()));
          //           }
          //         },
          //         leading: Icon(
          //           Icons.person_2_outlined,
          //           color: white,
          //         ),
          //         title: CustomText(
          //           "Profile",
          //           white,
          //           13,
          //           FontWeight.w600,
          //           TextOverflow.fade,
          //         ),
          //       ),
          //       ListTile(
          //         onTap: () {
          //           Navigator.pop(context);
          //
          //           Navigator.push(context,
          //               MaterialPageRoute(builder: (_) => OrdersScreen()));
          //         },
          //         leading: Icon(
          //           Icons.local_shipping_outlined,
          //           color: white,
          //         ),
          //         title: CustomText(
          //           "Orders",
          //           white,
          //           13,
          //           FontWeight.w600,
          //           TextOverflow.fade,
          //         ),
          //       ),
          //       ListTile(
          //         onTap: FirebaseAuth.instance.currentUser == null
          //             ? () {
          //                 Navigator.pushReplacement(context,
          //                     MaterialPageRoute(builder: (_) => PhoneView()));
          //               }
          //             : () async {
          //                 await FirebaseAuth.instance.signOut().then((value) {
          //                   Navigator.pushReplacement(context,
          //                       MaterialPageRoute(builder: (_) => PhoneView()));
          //                 });
          //               },
          //         leading: Icon(
          //           FirebaseAuth.instance.currentUser == null
          //               ? Icons.login
          //               : Icons.logout,
          //           color: white,
          //         ),
          //         title: CustomText(
          //           FirebaseAuth.instance.currentUser == null
          //               ? "Login"
          //               : "Logout",
          //           white,
          //           13,
          //           FontWeight.w600,
          //           TextOverflow.fade,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          typesList.isEmpty
              ? SizedBox()
              : Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    physics: ScrollPhysics(),
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
                          collapsedIconColor: Colors.grey.withOpacity(0.5),
                          iconColor: white,
                          title: CustomText(
                            data.type.toString(),
                            white,
                            14,
                            FontWeight.w800,
                            TextOverflow.fade,
                          ),
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: data.product_type.length,
                              itemBuilder: (context, i) {
                                var dat = data.product_type[i];
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
                                    pro.updateFilter(null, null);

                                    pro.updateScreen(dat.toString());
                                    loadData();
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: 40,
                                    color: pro.items == dat.toString()
                                        ? white
                                        : Colors.transparent,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: CustomText(
                                          dat.toString(),
                                          pro.items == dat.toString()
                                              ? black
                                              : grey,
                                          12,
                                          FontWeight.w500,
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
