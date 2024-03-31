import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gopaljewellers/Widgets/custom/customtext.dart';
import 'package:gopaljewellers/provider/provider.dart';
import 'package:gopaljewellers/views/Home/components/drawer/profile_screen.dart';
import 'package:provider/provider.dart';

import '../../../../backend/authentication/auth_util.dart';
import '../../../../constants/color.dart';
import '../../../../utils/utils.dart';
import '../../../login/login_screen.dart';
import 'about_us_screen.dart';
import 'orders_screen.dart';

Widget homeDrawer(List categories, drawerProvider _drawerProvider, loadData) {
  return Consumer<drawerProvider>(builder: (context, pro, child) {
    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: primaryColor3,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              height: MediaQuery.of(context).size.height * 0.3,
              color: primaryColor,
              child: Center(
                child: Image.asset(
                  "assets/images/logo.png",
                  scale: 4,
                ),
              ),
            ),
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                maintainState: true,
                initiallyExpanded: true,
                // backgroundColor: white,
                collapsedBackgroundColor: white,
                leading: Icon(
                  Icons.category_outlined,
                  color: black,
                ),
                collapsedIconColor: secondaryTextColor,
                iconColor: black,
                title: CustomText(
                  "Category",
                  black,
                  13,
                  FontWeight.w600,
                  TextOverflow.fade,
                ),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      var data = categories[index];
                      return ListTile(
                        onTap: () {
                          pro.updateScreen(data);
                          loadData();
                          Navigator.pop(context);
                        },
                        tileColor: pro.items == data['name'].toString()
                            ? white
                            : primaryColor,
                        leading: Image.asset(
                          data['image'].toString(),
                          height: 40,
                        ),
                        title: CustomText(
                          data['name'].toString(),
                          pro.items == data['name'].toString()
                              ? primaryColor
                              : white,
                          13,
                          FontWeight.w600,
                          TextOverflow.fade,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () {
                if (currentPhoneNumber.isEmpty) {
                  Utils().toastMessage("Please login");
                } else {
                  Navigator.pop(context);

                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => ProfileScreen()));
                }
              },
              leading: Icon(
                Icons.person_2_outlined,
                color: white,
              ),
              title: CustomText(
                "Profile",
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
                    context, MaterialPageRoute(builder: (_) => OrdersScreen()));
              },
              leading: Icon(
                Icons.local_shipping_outlined,
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

                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => AbountUsScreen()));
              },
              leading: Icon(
                Icons.info_outline,
                color: white,
              ),
              title: CustomText(
                "About us",
                white,
                13,
                FontWeight.w600,
                TextOverflow.fade,
              ),
            ),
            ListTile(
              onTap: FirebaseAuth.instance.currentUser == null
                  ? () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => PhoneView()));
                    }
                  : () async {
                      await FirebaseAuth.instance.signOut().then((value) {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => PhoneView()));
                      });
                    },
              leading: Icon(
                FirebaseAuth.instance.currentUser == null
                    ? Icons.login
                    : Icons.logout,
                color: white,
              ),
              title: CustomText(
                FirebaseAuth.instance.currentUser == null ? "Login" : "Logout",
                white,
                13,
                FontWeight.w600,
                TextOverflow.fade,
              ),
            ),
          ],
        ),
      ),
    );
  });
}
