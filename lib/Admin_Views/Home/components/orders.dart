import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Widgets/custom/customtext.dart';
import '../../../../constants/color.dart';
import '../../../Widgets/custom/appBarWidget.dart';
import '../../../backend/supabase/models/orders.dart';
import '../../../backend/supabase/models/user_model.dart';
import '../../../services/Apis.dart';
import '../../../utils/flutter_flow/date_format.dart';
import '../../../utils/flutter_flow/default_value.dart';
import '../../../utils/flutter_flow/tab_bar_menu.dart';
import '../../../utils/loading.dart';
import '../../../utils/utils.dart';

class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({super.key});

  @override
  State<AdminOrderScreen> createState() => _AdminOrderScreenState();
}

class _AdminOrderScreenState extends State<AdminOrderScreen> {
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
      queryFn: (q) => q.order('id', ascending: false),
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
  List<UserRow> users = [];

  getUsers(uid, from) async {
    setState(() {
      iSLoading = true;
    });
    await UserTable()
        .queryRows(
      queryFn: (q) => q.eq("uid", uid).limit(1).order('id', ascending: false),
    )
        .then((value) {
      log(value.toString());
      users.addAll(value);
      if (from == "delivery") {
        ApiService.sendNotification(
          value[0].token['uid'].toString(),
          "Delivery Date Schedule",
          "Check when your order will delivered!!",
          "order",
          "order_ID",
        );
      } else if (from == "delivered") {
        ApiService.sendNotification(
          value[0].token['uid'].toString(),
          "Product Delivered",
          "How was the product!!",
          "order",
          "order_ID",
        );
      } else if (from == "cancel") {
        ApiService.sendNotification(
          value[0].token['uid'].toString(),
          "Order Cancel",
          "Your order has been cancel by admin!!",
          "order",
          "order_ID",
        );
      }
      log(users.toString());
    });

    setState(() {
      iSLoading = false;
    });
  }

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
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 4, top: 8, left: 10, right: 10),
                                    child: InkWell(
                                      onTap: () async {
                                        String url = Platform.isIOS
                                            ? 'tel://${data.user_number}'
                                            : 'tel:${data.user_number}';

                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {
                                          print(' could not launch ${url}');
                                        }
                                      },
                                      child: Icon(
                                        Icons.call_outlined,
                                        color: green,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 4, top: 8, left: 10, right: 10),
                                    child: InkWell(
                                      onTap: () async {
                                        DateTime selectedDate = data
                                                    .delievery_date !=
                                                null
                                            ? DateTime.parse(
                                                data.delievery_date.toString())
                                            : DateTime.now();

                                        final DateTime? picked =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: selectedDate,
                                                firstDate: DateTime(2015, 8),
                                                lastDate: DateTime(2101));
                                        if (picked != null &&
                                            picked != selectedDate) {
                                          setState(() {
                                            selectedDate = picked;
                                          });
                                          OrdersTable().update(
                                              data: {
                                                "delievery_date":
                                                    picked.toString(),
                                              },
                                              matchingRows: (q) => q.eq(
                                                  'order_id',
                                                  data.order_id
                                                      .toString())).then(
                                              (value) {
                                            setState(() {
                                              products.clear();
                                              getOrders();
                                              getUsers(
                                                  data.user_uid, "delivery");
                                            });
                                            Utils().toastMessage(
                                                "Delivery Date Added");
                                          }).onError((error, stackTrace) {
                                            Utils().toastMessage(
                                                "Something went wrong");
                                          });
                                        }
                                      },
                                      child: Icon(
                                        Icons.calendar_month,
                                        color: Colors.blueGrey.shade600,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 4, top: 8, left: 10, right: 10),
                                    child: InkWell(
                                      onTap: () async {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                content: SizedBox(
                                                  height: 120,
                                                  child: Column(
                                                    children: [
                                                      ListTile(
                                                        onTap: () {
                                                          OrdersTable().update(
                                                              data: {
                                                                "delivered":
                                                                    true,
                                                              },
                                                              matchingRows: (q) => q.eq(
                                                                  'order_id',
                                                                  data.order_id
                                                                      .toString())).then(
                                                              (value) {
                                                            setState(() {
                                                              products.clear();
                                                              getOrders();
                                                              getUsers(
                                                                  data.user_uid,
                                                                  "delivered");
                                                            });
                                                            Navigator.pop(
                                                                context);

                                                            Utils().toastMessage(
                                                                "Delieverd");
                                                          }).onError((error,
                                                              stackTrace) {
                                                            Utils().toastMessage(
                                                                "Something went wrong");
                                                          });
                                                        },
                                                        title: CustomText2(
                                                          "Completed",
                                                          black,
                                                          14,
                                                          FontWeight.w700,
                                                          TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      ListTile(
                                                        onTap: () {
                                                          OrdersTable().update(
                                                              data: {
                                                                "delivered":
                                                                    false,
                                                                "cancel": true
                                                              },
                                                              matchingRows: (q) => q.eq(
                                                                  'order_id',
                                                                  data.order_id
                                                                      .toString())).then(
                                                              (value) {
                                                            setState(() {
                                                              products.clear();
                                                              getOrders();
                                                              getUsers(
                                                                  data.user_uid,
                                                                  "cancel");
                                                            });
                                                            Navigator.pop(
                                                                context);

                                                            Utils().toastMessage(
                                                                "Order Cancel");
                                                          }).onError((error,
                                                              stackTrace) {
                                                            Utils().toastMessage(
                                                                "Something went wrong");
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        title: CustomText2(
                                                          "Cancel",
                                                          black,
                                                          14,
                                                          FontWeight.w700,
                                                          TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: CustomText2(
                                                      "Back",
                                                      red,
                                                      14,
                                                      FontWeight.w500,
                                                      TextOverflow.ellipsis,
                                                    ),
                                                  )
                                                ],
                                              );
                                            });
                                      },
                                      child: Icon(
                                        Icons.more_vert,
                                        color: Colors.blueGrey.shade600,
                                        size: 25,
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
      shape: RoundedRectangleBorder(
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
              detils(width, "Customer Name", data.user_name.toString()),
              showDivider(),
              detils(width, "Customer No.", data.user_number.toString()),
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
              Center(
                child: Container(
                  // height: 100,
                  width: width * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: secondaryTextColor.withOpacity(0.2), width: 0.6),
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
