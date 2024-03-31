import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gopaljewellers/Widgets/custom/customtext.dart';
import 'package:gopaljewellers/backend/authentication/auth_util.dart';
import 'package:gopaljewellers/utils/loading.dart';
import 'package:gopaljewellers/views/cart/checkout/Checkout_Screen.dart';

import '../../Widgets/button/gradient_button.dart';
import '../../Widgets/custom/appBarWidget.dart';
import '../../backend/supabase/models/cart_model.dart';
import '../../backend/supabase/models/product_model.dart';
import '../../constants/color.dart';
import '../../utils/utils.dart';
import '../product_detail/product_detail.dart';

class CartScreen extends StatefulWidget {
  final loadData;
  CartScreen({required this.loadData});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartRow> cart = [];
  bool iSLoading = false;

  getCart() async {
    setState(() {
      iSLoading = true;
    });
    await CartTable()
        .queryRows(
      queryFn: (q) => q
          .eq("user_uid", currentUserUid.toString())
          // .in_("product_id", product_idß)
          .order('id', ascending: false),
    )
        .then((value) {
      log(value.toString());
      cart.addAll(value);
      getProducts();
      log(cart.toString());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCart();
    });
  }

  List<ProductsRows> products = [];

  getProducts() async {
    setState(() {
      iSLoading = true;
    });
    List<String> productIdList =
        cart.map((map) => map.product_id.toString()).toList();
    await ProductTables()
        .queryRows(
      queryFn: (q) =>
          q.in_("product_id", productIdList).order('id', ascending: false),
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
        appBar: appBarWidget("My Cart", true, [], () {
          widget.loadData();
          Navigator.pop(context);
        }),
        body: iSLoading == true
            ? showLoading()
            : products.isEmpty
                ? Center(
                    child: CustomText2("No Item in cart", secondaryTextColor,
                        15, FontWeight.w600, TextOverflow.clip),
                  )
                : Column(
                    children: [
                      ListTile(
                        title: CustomText(
                          "Cart Items",
                          black,
                          20,
                          FontWeight.w900,
                          TextOverflow.fade,
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            var data = products[index];
                            return Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: secondaryTextColor
                                                .withOpacity(0.15),
                                            blurRadius: 3,
                                            spreadRadius: 3,
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    ProductDetailScreen(
                                                  data: data,
                                                  loadData: () {
                                                    setState(() {
                                                      cart.clear();
                                                      products.clear();
                                                      getCart();
                                                    });
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              ListTile(
                                                leading: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                    data.product_images[0]
                                                        .toString(),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                title: CustomText(
                                                    data.product_name
                                                        .toString(),
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
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
                                                          data.product_weight
                                                              .toString(),
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
                                                          data.product_type
                                                              .toString(),
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
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(0),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: InkWell(
                                        onTap: () {
                                          CartTable()
                                              .delete(
                                                  matchingRows: (q) => q
                                                      .eq("product_id",
                                                          data.product_id)
                                                      .eq(
                                                          "user_uid",
                                                          currentUserUid
                                                              .toString()))
                                              .then((value) {
                                            setState(() {
                                              cart.clear();
                                              products.clear();
                                              getCart();
                                            });

                                            Utils().toastMessage(
                                                "Removed from Cart");
                                          }).onError((error, stackTrace) {
                                            log(error.toString());
                                            Utils().toastMessage(
                                                "Something went wrong");
                                          });
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: red,
                                          radius: 12,
                                          child: Icon(
                                            Icons.clear,
                                            color: white,
                                            size: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
        bottomNavigationBar: products.isEmpty
            ? SizedBox()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GradientButton(
                      width: width * 0.9,
                      height: 45,
                      text: "CheckOut",
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontColor: primaryColor,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => CheckOutScreen(
                                      orders: products,
                                      loadData: () {
                                        setState(() {
                                          cart.clear();
                                          products.clear();
                                          getCart();
                                        });
                                      },
                                    )));
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget detils(width, title, value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: width * 0.4,
            child: Text(
              title.toString(),
              overflow: TextOverflow.clip,
              textAlign: TextAlign.left,
              style: GoogleFonts.dmSerifDisplay(
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
              style: GoogleFonts.syne(
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
