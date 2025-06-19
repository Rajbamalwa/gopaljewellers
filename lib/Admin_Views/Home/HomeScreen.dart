import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../Widgets/button/custom_button.dart';
import '../../Widgets/custom/customtext.dart';
import '../../backend/authentication/auth_util.dart';
import '../../backend/supabase/models/cart_model.dart';
import '../../backend/supabase/models/product_model.dart';
import '../../backend/supabase/models/productype_model.dart';
import '../../constants/color.dart';
import '../../provider/provider.dart';
import '../../services/internet.dart';
import '../../services/notification.dart';
import '../../utils/flutter_flow/default_value.dart';
import '../../utils/loading.dart';
import '../../utils/utils.dart';
import '../../views/login/login_screen.dart';
import '../Product/Add_Product.dart';
import 'components/drawer.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  final NotificationService _notifications = NotificationService();
  CheckInternet? _checkInternet;
  drawerProvider? _drawerProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestNotificationPermissions();
    _notifications.requestNotificationPermission();
    _notifications.forgroundMessage();
    _notifications.firebaseInit(context);
    _notifications.setupInteractMessage(context);
    _checkInternet = Provider.of<CheckInternet>(context, listen: false);
    _drawerProvider = Provider.of<drawerProvider>(context, listen: false);
    _checkInternet?.checkRealtimeConnection();
    setupToken();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProducts();
      getCart();
      getProductsType();
    });
  }

  Future<void> requestNotificationPermissions() async {
    final PermissionStatus status = await Permission.notification.status;

    if (status.isGranted) {
    } else if (status.isDenied) {
      await Permission.notification.request();
    } else if (status.isPermanentlyDenied) {
      await Permission.notification.request();
    }
  }

  final List categories = [
    {"image": "assets/images/necklace.png", "name": "Necklace", "id": "1"},
    {"image": "assets/images/earing.png", "name": "Earring", "id": "2"},
  ];

  // 'Necklaces',
  // 'Earrings',
  // 'Bracelets',
  // 'Rings',
  // 'Brooches',
  // 'Watches',
  // 'Anklets',

  final List product = [
    {
      "id": "3984938",
      "product_image": [
        "https://content.jdmagicbox.com/comp/bangalore/l3/080pxx80.xx80.140107123547.k9l3/catalogue/madhu-jewellers-shivaji-nagar-bangalore-gold-buyers-zo4upq5xsw.jpg",
        "https://content.jdmagicbox.com/comp/bangalore/l3/080pxx80.xx80.140107123547.k9l3/catalogue/madhu-jewellers-shivaji-nagar-bangalore-gold-buyers-zo4upq5xsw.jpg",
      ],
      "product_id": "SFD20020",
      "product_type": "Necklace",
      "product_name": "Necklaces",
      "product_description":
          "Necklaces Necklaces Necklaces Necklaces Necklaces Necklaces Necklaces Necklaces Necklaces Necklaces Necklaces Necklaces",
      "product_weight": "22.30",
      "product_material": "Gold",
      "product_price": 220000,
      "product_likes": 100,
      "product_stock": 100,
    },
  ];
  bool iSLoading = false;
  List<ProductsRows> products = [];

  getProducts() async {
    setState(() {
      iSLoading = true;
    });
    products.clear();

    cart.clear();
    _drawerProvider = Provider.of<drawerProvider>(context, listen: false);
    log(_drawerProvider!.items.toString());
    await ProductTables()
        .queryRows(
      queryFn: (q) => q
          .eq("product_type", _drawerProvider!.items.toString())
          .order('id', ascending: false),
    )
        .then((value) {
      log(value.toString());
      products.addAll(value);
      getCart();
      log(products.toString());
    });

    setState(() {
      iSLoading = false;
    });
  }

  List<CartRow> cart = [];

  getCart() async {
    cart.clear();
    setState(() {
      iSLoading = true;
    });
    await CartTable()
        .queryRows(
      queryFn: (q) => q
          .eq(
            "user_phone",
            currentPhoneNumber.toString(),
          )
          .order('id', ascending: false),
    )
        .then((value) {
      log(value.toString());
      cart.addAll(value);
      log(cart.toString());
    });

    setState(() {
      iSLoading = false;
    });
  }

  List<ProductTypeRows> types = [];

  getProductsType() async {
    setState(() {
      iSLoading = true;
    });
    _drawerProvider = Provider.of<drawerProvider>(context, listen: false);

    await ProductTypeTable()
        .queryRows(
      queryFn: (q) => q.order('id', ascending: true),
    )
        .then((value) {
      log(value.toString());
      _drawerProvider!.updateScreen(value[0].product_type[0].toString());

      types.addAll(value);
    });

    setState(() {
      iSLoading = false;
    });
  }

  ScrollController scrollController = ScrollController();
  Future<void> setupToken() async =>
      await FirebaseMessaging.instance.getToken().then((token) async {
        await _notifications.saveFcmToFireBase(token!);
        FirebaseMessaging.instance.onTokenRefresh
            .listen(_notifications.saveFcmToFireBase);
      });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => PhoneView()));

        return true;
      },
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
            onPressed: () {
              _key.currentState!.openDrawer();
            },
            icon: Icon(
              Icons.menu_rounded,
              color: white,
            ),
          ),
          elevation: 2,
          title: Text(
            "Gopal Jewellers",
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.rakkas(
              fontSize: 30,
              fontWeight: FontWeight.w100,
              color: primaryColor22,
            ),
          ),
          actions: [],
        ),
        drawer: homeDrawer(categories, _drawerProvider!, () {
          setState(() {
            products.clear();
            getProducts();
          });
        }, types),
        body: iSLoading == true
            ? showLoading()
            : Consumer<drawerProvider>(
                builder: (context, pro, child) {
                  return Column(
                    children: [
                      // Container(
                      //   decoration: BoxDecoration(
                      //       color: primaryColor,
                      //       border: Border.fromBorderSide(BorderSide.none)),
                      //   height: 25,
                      //   child: Marquee(
                      //     text:
                      //         'Get live gold and silver prices with BBC Gold.',
                      //     style: TextStyle(
                      //         fontWeight: FontWeight.bold,
                      //         color: primaryColor22),
                      //     scrollAxis: Axis.horizontal,
                      //     blankSpace: 40.0,
                      //     startPadding: 10.0,
                      //   ),
                      // ),
                      pro.items == ""
                          ? SizedBox()
                          : ListTile(
                              // leading: Image.asset(
                              //   pro.itemImages.toString(),
                              //   height: 40,
                              // ),
                              title: CustomText(
                                pro.items.toString(),
                                black,
                                20,
                                FontWeight.w900,
                                TextOverflow.fade,
                              ),
                              trailing: IconButton(
                                tooltip: pro.layout == "grid"
                                    ? "Grid Layout"
                                    : "List Layout",
                                onPressed: () {
                                  pro.updateLayout();
                                },
                                icon: Icon(
                                  pro.layout == "grid"
                                      ? Icons.view_list
                                      : Icons.grid_view,
                                ),
                              ),
                            ),
                      products.isEmpty
                          ? Center(
                              child: CustomText2(
                                  "No products found",
                                  secondaryTextColor,
                                  15,
                                  FontWeight.w600,
                                  TextOverflow.clip),
                            )
                          : pro.layout == "grid"
                              ? Expanded(
                                  child: RawScrollbar(
                                    interactive: true,
                                    thumbVisibility: true,
                                    thumbColor: primaryColor,
                                    radius: const Radius.circular(4),
                                    crossAxisMargin: 1,
                                    controller: scrollController,
                                    child: GridView.builder(
                                      controller: scrollController,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              mainAxisSpacing: 2,
                                              crossAxisSpacing: 2,
                                              childAspectRatio: 0.7),
                                      itemCount: products.length,
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        var data = products[index];
                                        final inCart = cart.any((cartProduct) =>
                                            cartProduct.product_id ==
                                            data.product_id);
                                        log(inCart.toString());
                                        return Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            onLongPress: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Theme(
                                                    data: ThemeData(
                                                        canvasColor:
                                                            transparent),
                                                    child: AlertDialog(
                                                      backgroundColor:
                                                          transparent,
                                                      insetPadding:
                                                          EdgeInsets.all(16),
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0.0),
                                                      ),
                                                      elevation: 0,
                                                      // backgroundColor: Colors.transparent,
                                                      content: contentBox(
                                                          context,
                                                          data,
                                                          height,
                                                          width, () {
                                                        Navigator.pop(context);
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (_) =>
                                                                AddProduct(
                                                              product: data,
                                                              load: () {
                                                                setState(() {
                                                                  product
                                                                      .clear();
                                                                  types.clear();

                                                                  getProductsType();
                                                                  getProducts();
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: secondaryTextColor
                                                        .withOpacity(0.05),
                                                    spreadRadius: 3,
                                                    blurRadius: 4,
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: height * 0.2,
                                                    width: width * 0.5,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                          data.product_images[0]
                                                              .toString(),
                                                        ),
                                                        fit: BoxFit.cover,
                                                        filterQuality:
                                                            FilterQuality.high,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          inCart
                                                              ? SizedBox()
                                                              : Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomRight,
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (_) =>
                                                                              AddProduct(
                                                                            product:
                                                                                data,
                                                                            load:
                                                                                () {
                                                                              setState(() {
                                                                                product.clear();
                                                                                types.clear();

                                                                                getProductsType();
                                                                                getProducts();
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                    child:
                                                                        CircleAvatar(
                                                                      radius:
                                                                          15,
                                                                      backgroundColor:
                                                                          primaryColor22,
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .edit_outlined,
                                                                        size:
                                                                            15,
                                                                        color:
                                                                            primaryColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    // color: primaryColor22,
                                                    // width: width * 0.38,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        child:
                                                            SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: Text(
                                                            data.product_name
                                                                .toString(),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: black,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: width * 0.38,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                8, 0, 8, 8),
                                                        child: Text(
                                                          data.product_weight
                                                              .toString(),
                                                          overflow:
                                                              TextOverflow.clip,
                                                          textAlign:
                                                              TextAlign.left,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color:
                                                                primaryColor22,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: RawScrollbar(
                                    interactive: true,
                                    thumbVisibility: true,
                                    thumbColor: primaryColor,
                                    radius: const Radius.circular(4),
                                    crossAxisMargin: 1,
                                    controller: scrollController,
                                    child: ListView.builder(
                                      controller: scrollController,
                                      itemCount: products.length,
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        var data = products[index];
                                        final inCart = cart.any((cartProduct) =>
                                            cartProduct.product_id ==
                                            data.product_id);

                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: secondaryTextColor
                                                      .withOpacity(0.05),
                                                  spreadRadius: 3,
                                                  blurRadius: 4,
                                                ),
                                              ],
                                            ),
                                            child: ListTile(
                                              onLongPress: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Theme(
                                                      data: ThemeData(
                                                          canvasColor:
                                                              transparent),
                                                      child: AlertDialog(
                                                        backgroundColor:
                                                            transparent,
                                                        insetPadding:
                                                            EdgeInsets.all(16),
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      0.0),
                                                        ),
                                                        elevation: 0,
                                                        // backgroundColor: Colors.transparent,
                                                        content: contentBox(
                                                            context,
                                                            data,
                                                            height,
                                                            width, () {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (_) =>
                                                                  AddProduct(
                                                                product: data,
                                                                load: () {
                                                                  setState(() {
                                                                    product
                                                                        .clear();
                                                                    types
                                                                        .clear();

                                                                    getProductsType();
                                                                    getProducts();
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              leading: Container(
                                                height: 70,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      data.product_images[0]
                                                          .toString(),
                                                    ),
                                                    fit: BoxFit.cover,
                                                    filterQuality:
                                                        FilterQuality.high,
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                data.product_name.toString(),
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                maxLines: 2,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: black,
                                                ),
                                              ),
                                              subtitle: Text(
                                                data.product_weight.toString(),
                                                overflow: TextOverflow.clip,
                                                textAlign: TextAlign.left,
                                                maxLines: 2,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: primaryColor22,
                                                ),
                                              ),
                                              trailing: inCart
                                                  ? SizedBox()
                                                  : GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (_) =>
                                                                AddProduct(
                                                              product: data,
                                                              load: () {
                                                                setState(() {
                                                                  product
                                                                      .clear();
                                                                  types.clear();

                                                                  getProductsType();
                                                                  getProducts();
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: CircleAvatar(
                                                          radius: 15,
                                                          backgroundColor:
                                                              primaryColor3,
                                                          child: Icon(
                                                            Icons.edit_outlined,
                                                            size: 15,
                                                            color: white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                    ],
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor22,
          tooltip: "Add Product",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddProduct(
                  load: () {
                    setState(() {
                      product.clear();
                      types.clear();

                      getProductsType();
                      getProducts();
                    });
                  },
                ),
              ),
            );
          },
          child: Icon(
            Icons.add,
            color: primaryColor,
          ),
        ),
      ),
    );
  }

  contentBox(context, ProductsRows data, height, width, onTap) {
    List likes = data.product_likes;

    return StatefulBuilder(builder: (context, setState) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              color: white,
              child: Container(
                margin: EdgeInsets.all(4),
                height: height * 0.5,
                width: width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(data.product_images[0].toString()),
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                              valueOrDefault(data.product_name, "Jewellery"),
                              black,
                              25,
                              FontWeight.w900,
                              TextOverflow.ellipsis),
                          Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                              onTap: likes
                                      .contains(currentPhoneNumber.toString())
                                  ? () {
                                      likes.remove(
                                          currentPhoneNumber.toString());
                                      ProductTables().update(
                                          data: {
                                            "product_likes": likes,
                                          },
                                          matchingRows: (q) => q.eq(
                                              "product_id",
                                              data.product_id)).then((value) {
                                        Utils().toastMessage(
                                            "Removed from favourite");
                                        setState(() {});
                                      }).onError((error, stackTrace) {
                                        log(error.toString());
                                        Utils().toastMessage(
                                            "Something went wrong");
                                      });
                                    }
                                  : () {
                                      if (currentPhoneNumber.isEmpty) {
                                        Utils().toastMessage("Please login");
                                      } else {
                                        likes
                                            .add(currentPhoneNumber.toString());

                                        ProductTables().update(
                                            data: {
                                              "product_likes": likes,
                                            },
                                            matchingRows: (q) => q.eq(
                                                "product_id",
                                                data.product_id)).then((value) {
                                          setState(() {});

                                          Utils().toastMessage(
                                              "Added to favourite");
                                        }).onError((error, stackTrace) {
                                          log(error.toString());
                                          Utils().toastMessage(
                                              "Something went wrong");
                                        });
                                      }
                                    },
                              child: Icon(
                                likes.contains(currentPhoneNumber.toString())
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                semanticLabel: "Favourite",
                                color: likes
                                        .contains(currentPhoneNumber.toString())
                                    ? red
                                    : white,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Buttons(
                  onPress: onTap,
                  height: 50,
                  color: white,
                  radius: 4,
                  child: CustomText2(
                    "Edit Products",
                    black,
                    16,
                    FontWeight.w800,
                    TextOverflow.clip,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: red.withOpacity(0.1),
                    child: Icon(
                      Icons.clear,
                      color: red,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
