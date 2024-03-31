import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gopaljewellers/Widgets/custom/appBarWidget.dart';
import 'package:gopaljewellers/Widgets/text_field/text_field_widget.dart';
import 'package:gopaljewellers/backend/authentication/auth_util.dart';
import 'package:gopaljewellers/backend/schema/users_record.dart';
import 'package:gopaljewellers/backend/supabase/models/cart_model.dart';
import 'package:gopaljewellers/backend/supabase/models/orders.dart';
import 'package:gopaljewellers/backend/supabase/models/product_model.dart';
import 'package:gopaljewellers/services/helper.dart';
import 'package:gopaljewellers/utils/loading.dart';
import 'package:gopaljewellers/utils/utils.dart';
import 'package:gopaljewellers/views/Home/home_screen.dart';

import '../../../Widgets/button/gradient_button.dart';
import '../../../Widgets/custom/customtext.dart';
import '../../../constants/color.dart';
import '../../../services/notification.dart';

class CheckOutScreen extends StatefulWidget {
  List<ProductsRows> orders;
  final loadData;
  CheckOutScreen({required this.orders, required this.loadData});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  bool ordering = false;

  late TextEditingController n_controller;
  late TextEditingController m_controller;
  late TextEditingController a_controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    n_controller = TextEditingController(
      text: currentUserDisplayName,
    );
    m_controller = TextEditingController(
      text: currentPhoneNumber,
    );
    a_controller = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    n_controller.dispose();
    m_controller.dispose();
    a_controller.dispose();

    super.dispose();
  }

  List ordered = [];
  final NotificationService _notifications = NotificationService();

  void uploadToDatabase(List<ProductsRows> products) {
    // for (int i = 0; i < widget.orders.length; i++) {
    //   // Access each element of widget.orders using widget.orders[i]
    // }
    setState(() {
      ordering = true;
    });
    // for (CartRow product in widget.orders) {}
    int completedOrders = 0;

    // Iterate through each product and upload it to the database
    for (ProductsRows product in products) {
      // For each product in the list, upload it to the database
      // using the product's ID as the key under the 'products' node.
      OrdersTable().insert({
        "user_name": n_controller.text,
        "user_number": m_controller.text,
        "user_uid": currentUserUid.toString(),
        "product_id": product.product_id.toString(),
        "product_type": product.product_type.toString(),
        "product_name": product.product_name.toString(),
        "product_image": product.product_images[0].toString(),
        "product_weight": product.product_weight.toString(),
        "product_quantity": "1",
        "product_price": product.product_price.toString(),
        "delivered": false,
        "delievery_date": null,
        "remark": a_controller.text,
        "cancel": false,
        "order_id": Helpers.getOrderId(),
      }).then((value) {
        completedOrders++;
        if (completedOrders == widget.orders.length) {
          setState(() {
            ordering = false;
          });
          CartTable().delete(
              matchingRows: (q) => q
                  .eq("product_id", product.product_id)
                  .eq("user_uid", currentUserUid.toString()));
          _notifications.scheduleNotification(
            title: Helpers().randomTitle().toString(),
            body: product.product_name.toString(),
            scheduledNotificationDateTime: DateTime.now().add(
              Duration(seconds: 2),
            ),
          );
        }
        log("Successfully ordered");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      }).onError((error, stackTrace) {
        log("Successfully error - ${error.toString()}");
      });
    }
    if (ordered.length == widget.orders.length) {
      setState(() {
        ordering = false;
      });
    }
  }

  ScrollController scrollController = ScrollController();

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
        appBar: appBarWidget("CheckOut", true, [], () {
          widget.loadData();
          Navigator.pop(context);
        }),
        body: ordering == true
            ? SizedBox(
                child: showLoading(),
              )
            : RawScrollbar(
                interactive: true,
                thumbVisibility: true,
                thumbColor: primaryColor,
                radius: const Radius.circular(4),
                crossAxisMargin: 1,
                controller: scrollController,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomTextField(
                        controller: n_controller,
                        hintText: "Name",
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          FirebaseAuth.instance.currentUser!
                              .updateDisplayName(value.toString());
                          UsersRecord.updateDocument({
                            "display_name": value.toString(),
                          }).then((value) {}).onError((error, stackTrace) {});
                        },
                      ),
                      CustomTextField(
                        controller: m_controller,
                        hintText: "Phone Number",
                        keyboardType: TextInputType.number,
                      ),
                      CustomTextField(
                        controller: a_controller,
                        hintText: "Remark ( Optional )",
                        maxLines: 5,
                      ),
                      ListTile(
                        title: CustomText(
                          "Total products",
                          black,
                          20,
                          FontWeight.w900,
                          TextOverflow.fade,
                        ),
                      ),
                      ListView.builder(
                        controller: scrollController,
                        itemCount: widget.orders.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var data = widget.orders[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 5, bottom: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                color: white,
                                boxShadow: [
                                  BoxShadow(
                                    color: secondaryTextColor.withOpacity(0.15),
                                    blurRadius: 3,
                                    spreadRadius: 3,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          data.product_images[0].toString(),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      title: CustomText(
                                          data.product_name.toString(),
                                          black,
                                          20,
                                          FontWeight.w900,
                                          TextOverflow.clip),
                                      subtitle: CustomText2(
                                          data.product_id.toString(),
                                          secondaryTextColor,
                                          14,
                                          FontWeight.w500,
                                          TextOverflow.clip),
                                      trailing: CustomText(
                                          "1",
                                          secondaryTextColor,
                                          18,
                                          FontWeight.w900,
                                          TextOverflow.clip),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            CustomText(
                                                "Weight : ",
                                                secondaryTextColor,
                                                12,
                                                FontWeight.w400,
                                                TextOverflow.clip),
                                            CustomText2(
                                                data.product_weight.toString(),
                                                black,
                                                12,
                                                FontWeight.w700,
                                                TextOverflow.clip),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            CustomText(
                                                "Type : ",
                                                secondaryTextColor,
                                                12,
                                                FontWeight.w400,
                                                TextOverflow.clip),
                                            CustomText2(
                                                data.product_type.toString(),
                                                black,
                                                12,
                                                FontWeight.w700,
                                                TextOverflow.clip)
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GradientButton(
                width: width * 0.9,
                height: 45,
                text: "Place Order",
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontColor: primaryColor,
                onTap: () {
                  if (n_controller.text.isEmpty) {
                    Utils().toastMessage("Name is Empty");
                  } else if (m_controller.text.isEmpty) {
                    Utils().toastMessage("Phone Number is Empty");
                  } else {
                    uploadToDatabase(widget.orders);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
