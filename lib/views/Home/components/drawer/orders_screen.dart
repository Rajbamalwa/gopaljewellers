import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gopaljewellers/backend/authentication/auth_util.dart';

import '../../../../Widgets/custom/appBarWidget.dart';
import '../../../../Widgets/custom/customtext.dart';
import '../../../../backend/supabase/models/orders.dart';
import '../../../../constants/color.dart';
import '../../../../utils/flutter_flow/date_format.dart';
import '../../../../utils/flutter_flow/default_value.dart';
import '../../../../utils/flutter_flow/tab_bar_menu.dart';
import '../../../../utils/loading.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getOrders();
    });
  }

  bool iSLoading = false;

  List<OrdersRow> products = [];

  getOrders() async {
    setState(() {
      iSLoading = true;
    });
    await OrdersTable()
        .queryRows(
      queryFn: (q) =>
          q.eq("user_uid", currentUserUid).order('id', ascending: false),
    )
        .then((value) {
      log(value.toString());
      products.addAll(value);
      log(products.toString());
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
      appBar: appBarWidget("Orders", true, [], () {
        Navigator.pop(context);
      }),
      body: iSLoading == true
          ? Center(child: showLoading())
          : products.isEmpty
              ? Center(
                  child: CustomText2("No Orders placed", secondaryTextColor, 15,
                      FontWeight.w600, TextOverflow.clip),
                )
              : Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: DefaultTabController(
                        length: 3,
                        initialIndex: 0,
                        child: Column(
                          children: [
                            const TabBarMenu(
                              tabTitle: ["Completed", "Pending", "Cancel"],
                            ),
                            Expanded(
                              child: TabBarView(
                                physics: const BouncingScrollPhysics(),
                                children: [
                                  orderWidget(width, "Completed", products),
                                  orderWidget(width, "Pending", products),
                                  orderWidget(width, "Cancel", products),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget orderWidget(double width, from, List<OrdersRow> list) {
    List list1 = [];
    List list2 = [];
    List list3 = [];
    list.forEach((element) {
      if (element.delivered == false &&
          from == "Pending" &&
          element.cancel == false) {
        list1.add(element);
      } else if (element.delivered == true &&
          from == "Completed" &&
          element.cancel == false) {
        list2.add(element);
      } else if (element.delivered == false &&
          from == "Cancel" &&
          element.cancel == true) {
        list3.add(element);
      }
    });
    if (list1.isEmpty) {
    } else {
      return ListView.builder(
          itemCount: list1.length,
          itemBuilder: (c, i) {
            var data = list1[i];
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      // color: data.delivered == true ? green : red,
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
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    data.product_image.toString(),
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
                                    "Order Id - ${data.order_id.toString()}",
                                    secondaryTextColor,
                                    12,
                                    FontWeight.w500,
                                    TextOverflow.clip),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
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
                                    mainAxisAlignment: MainAxisAlignment.end,
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 8, right: 8),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          showOrderDetails(data, width);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: secondaryTextColor
                                                    .withOpacity(0.1)),
                                            color: white,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 7,
                                                bottom: 7),
                                            child: CustomText(
                                              "Details",
                                              black,
                                              14,
                                              FontWeight.w800,
                                              TextOverflow.clip,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: blue.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              top: 7,
                                              bottom: 7),
                                          child: CustomText(
                                            "Pending",
                                            blue,
                                            14,
                                            FontWeight.w800,
                                            TextOverflow.clip,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
    }
    if (list2.isEmpty) {
    } else {
      return ListView.builder(
          itemCount: list2.length,
          itemBuilder: (c, i) {
            var data = list2[i];
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      // color: data.delivered == true ? green : red,
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
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    data.product_image.toString(),
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
                                    "Order Id - ${data.order_id.toString()}",
                                    secondaryTextColor,
                                    12,
                                    FontWeight.w500,
                                    TextOverflow.clip),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
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
                                    mainAxisAlignment: MainAxisAlignment.end,
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 8, right: 8),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          showOrderDetails(data, width);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: secondaryTextColor
                                                    .withOpacity(0.1)),
                                            color: white,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 7,
                                                bottom: 7),
                                            child: CustomText(
                                              "Details",
                                              black,
                                              14,
                                              FontWeight.w800,
                                              TextOverflow.clip,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: green.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              top: 7,
                                              bottom: 7),
                                          child: CustomText(
                                            "Delivered",
                                            green,
                                            14,
                                            FontWeight.w800,
                                            TextOverflow.clip,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
    }
    if (list3.isEmpty) {
    } else {
      return ListView.builder(
          itemCount: list3.length,
          itemBuilder: (c, i) {
            var data = list3[i];
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      // color: data.delivered == true ? green : red,
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
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    data.product_image.toString(),
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
                                    "Order Id - ${data.order_id.toString()}",
                                    secondaryTextColor,
                                    12,
                                    FontWeight.w500,
                                    TextOverflow.clip),
                                // trailing: CustomText("1", secondaryTextColor,
                                //     18, FontWeight.w900, TextOverflow.clip),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
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
                                    mainAxisAlignment: MainAxisAlignment.end,
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 8, right: 8),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          showOrderDetails(data, width);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: secondaryTextColor
                                                    .withOpacity(0.1)),
                                            color: white,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 7,
                                                bottom: 7),
                                            child: CustomText(
                                              "Details",
                                              black,
                                              14,
                                              FontWeight.w800,
                                              TextOverflow.clip,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: red.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              top: 7,
                                              bottom: 7),
                                          child: CustomText(
                                            "Cancel",
                                            red,
                                            14,
                                            FontWeight.w800,
                                            TextOverflow.clip,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
    }
    return SizedBox();
  }

  showOrderDetails(OrdersRow data, width) {
    return showModalBottomSheet(
      isScrollControlled: false,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                  title: CustomText2(
                    data.product_name.toString(),
                    black,
                    20,
                    FontWeight.w900,
                    TextOverflow.clip,
                  ),
                  // subtitle: data.remark == null || data.remark!.isEmpty
                  //     ? Spacer()
                  //     : CustomText2(
                  //         valueOrDefault(data.remark, ""),
                  //         secondaryTextColor,
                  //         13,
                  //         FontWeight.w700,
                  //         TextOverflow.clip,
                  //       ),
                  trailing: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: CircleAvatar(
                      backgroundColor: red.withOpacity(0.1),
                      child: Icon(
                        Icons.clear,
                        color: red,
                      ),
                    ),
                  )),
              detils(width, "Order Id", data.order_id.toString()),
              showDivider(),
              detils(
                  width, "Product Quantity", data.product_quantity.toString()),
              showDivider(),
              detils(width, "Product Id", data.product_id.toString()),
              showDivider(),
              detils(width, "Type", data.product_type.toString()),
              showDivider(),
              detils(
                  width,
                  "Order Date",
                  dateTimeFormat("EEE, dd MMM y",
                      DateTime.parse(data.createdAt.toString()))),
              showDivider(),
              detils(
                  width,
                  "Delivery date",
                  data.delievery_date == null
                      ? "Not confirm"
                      : valueOrDefault(
                          dateTimeFormat("EEE, dd MMM y",
                              DateTime.parse(data.delievery_date.toString())),
                          "Not confirm")),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // height: 100,
                    width: width * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: secondaryTextColor.withOpacity(0.2),
                          width: 0.6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            data.product_weight.toString(),
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: green,
                            ),
                          ),
                          Text(
                            "Weight",
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      },
    );
  }

  showDivider() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Divider(
        color: secondaryTextColor.withOpacity(0.2),
        thickness: 0.5,
      ),
    );
  }

  Widget detils(width, title, value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: width * 0.35,
            child: Text(
              title.toString(),
              overflow: TextOverflow.clip,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: secondaryTextColor,
              ),
            ),
          ),
          SizedBox(
            width: width * 0.4,
            child: Text(
              value.toString(),
              overflow: TextOverflow.clip,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: primaryColor.withOpacity(0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
