import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gopaljewellers/Widgets/button/custom_button.dart';
import 'package:gopaljewellers/backend/supabase/models/productype_model.dart';
import 'package:gopaljewellers/provider/provider.dart';
import 'package:gopaljewellers/services/Apis.dart';
import 'package:gopaljewellers/services/helper.dart';
import 'package:gopaljewellers/utils/flutter_flow/default_value.dart';
import 'package:gopaljewellers/utils/loading.dart';
import 'package:gopaljewellers/utils/utils.dart';
import 'package:gopaljewellers/views/Home/components/drawer/about_us_screen.dart';
import 'package:gopaljewellers/views/product_detail/product_detail.dart';
import 'package:marquee/marquee.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../Admin_Views/Login/LoginScreen.dart';
import '../../Widgets/custom/customtext.dart';
import '../../backend/authentication/auth_util.dart';
import '../../backend/supabase/models/cart_model.dart';
import '../../backend/supabase/models/product_model.dart';
import '../../constants/color.dart';
import '../../services/internet.dart';
import '../../services/notification.dart';
import '../../utils/Filter_Widget.dart';
import '../cart/cart_screen.dart';
import '../login/login_screen.dart';
import 'components/drawer/drawer.dart';
import 'components/drawer/orders_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  final NotificationService _notifications = NotificationService();
  CheckInternet? _checkInternet;
  drawerProvider? _drawerProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestNotificationPermissions();
    // Initialize notification service
    _notifications.requestNotificationPermission();
    _notifications.forgroundMessage();
    _notifications.firebaseInit(context);
    _notifications.setupInteractMessage(context);
    // Start the periodic timer
    startTimer();

    _checkInternet = Provider.of<CheckInternet>(context, listen: false);
    _drawerProvider = Provider.of<drawerProvider>(context, listen: false);
    _checkInternet?.checkRealtimeConnection();
    if (FirebaseAuth.instance.currentUser == null) {
    } else {
      setupToken();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProductsType();

      getCart();
    });
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startTimer() {
    Timer.periodic(const Duration(hours: 20), (timer) {
      ApiService.sendNotification(
        fcmToken,
        Helpers().getRandomCatalogMessage(),
        "You have one new order",
        "home",
        "home_Id",
      );

      // Reschedule the timer
      timer.cancel();
      startTimer();
    });
  }

  void _toggleSlide() {
    // if (_controller.isDismissed) {
    _controller.forward();
    // } else {
    //   _controller.reverse();
    // }
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

  // 'Necklaces',
  // 'Earrings',
  // 'Bracelets',
  // 'Rings',
  // 'Brooches',
  // 'Watches',
  // 'Anklets',

  bool iSLoading = false;
  List<ProductsRows> products = [];

  getProducts() async {
    log("1");
    setState(() {
      products.clear();
      selectedMaterial = null;

      cart.clear();
      iSLoading = true;
    });

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
    if (FirebaseAuth.instance.currentUser == null) {
      _toggleSlide();
    } else {
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
        _toggleSlide();
      });

      setState(() {
        iSLoading = false;
      });
    }
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

      getProducts();
      types.addAll(value);
    });

    setState(() {
      iSLoading = false;
    });
  }

  Future<void> setupToken() async =>
      await FirebaseMessaging.instance.getToken().then((token) async {
        await _notifications.saveFcmToFireBase(token!);
        FirebaseMessaging.instance.onTokenRefresh
            .listen(_notifications.saveFcmToFireBase);
      });

  ScreenshotController screenshotController = ScreenshotController();
  ScrollController scrollController = ScrollController();
  List<String> productMaterial = ["GOLD", "SILVER", "PLATINUM"];
  var selectedMaterial;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        log(fcmToken.toString());
        Utils().showBackAlert(context, check: true);
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
            style: GoogleFonts.ebGaramond(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: primaryColor22,
            ),
          ),
          actions: [
            Theme(
              data: Theme.of(context).copyWith(
                  cardColor: primaryColor3,
                  iconTheme: IconThemeData(color: white)),
              child: PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    onTap: () {
                      if (currentPhoneNumber.isEmpty) {
                        Utils().toastMessage("Please login");
                      } else {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => SignInPage()));
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (_) => ProfileScreen()));
                      }
                    },
                    child: CustomText("Profile", white, 16, FontWeight.w700,
                        TextOverflow.ellipsis),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => OrdersScreen()));
                    },
                    child: CustomText("Orders", white, 16, FontWeight.w700,
                        TextOverflow.ellipsis),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => AbountUsScreen()));
                    },
                    child: CustomText("About us", white, 16, FontWeight.w700,
                        TextOverflow.ellipsis),
                  ),
                  PopupMenuItem(
                    onTap: FirebaseAuth.instance.currentUser == null
                        ? () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (_) => PhoneView()));
                          }
                        : () async {
                            await FirebaseAuth.instance.signOut().then((value) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => PhoneView()));
                            });
                          },
                    child: CustomText(
                        FirebaseAuth.instance.currentUser == null
                            ? "Login"
                            : "Logout",
                        white,
                        16,
                        FontWeight.w700,
                        TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CartScreen(
                      loadData: () {
                        setState(() {
                          getProducts();
                        });
                      },
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: white,
              ),
            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
        drawer: iSLoading == true
            ? showLoading()
            : homeDrawer(_drawerProvider!, () {
                setState(() {
                  getProducts();
                });
              }, types),
        body: iSLoading == true
            ? showLoading()
            : SlideTransition(
                position: _offsetAnimation,
                child: Consumer<drawerProvider>(
                  builder: (context, pro, child) {
                    return RawScrollbar(
                      interactive: true,
                      thumbVisibility: true,
                      thumbColor: primaryColor,
                      radius: const Radius.circular(4),
                      crossAxisMargin: 1,
                      controller: scrollController,
                      child: Column(
                        children: [
                          pro.items == ""
                              ? SizedBox()
                              : ListTile(
                                  title: CustomText(
                                    pro.items.toString(),
                                    black,
                                    20,
                                    FontWeight.w900,
                                    TextOverflow.fade,
                                  ),
                                ),
                          products.isEmpty
                              ? Expanded(
                                  child: Center(
                                    child: CustomText2(
                                        "No products found",
                                        secondaryTextColor,
                                        15,
                                        FontWeight.w600,
                                        TextOverflow.clip),
                                  ),
                                )
                              : Expanded(
                                  child: GridView.builder(
                                    controller: scrollController,
                                    padding: EdgeInsets.zero,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 2,
                                      crossAxisSpacing: 2,
                                      childAspectRatio: 0.74,
                                    ),
                                    itemCount: products.length,
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      var data = products[index];
                                      final inCart = cart.any((cartProduct) =>
                                          cartProduct.product_id ==
                                          data.product_id);
                                      log(inCart.toString());
                                      return gridWidget(
                                          context, data, height, width, inCart);
                                    },
                                  ),
                                ),
                          Container(
                            decoration: BoxDecoration(
                                color: primaryColor3,
                                border: Border.fromBorderSide(BorderSide.none)),
                            height: 25,
                            child: Marquee(
                              text:
                                  'Download our BBC Gold application for live gold and silver rates.',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor22),
                              scrollAxis: Axis.horizontal,
                              blankSpace: 40.0,
                              startPadding: 10.0,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
        floatingActionButton: FloatingActionButton(
          // elevation: 0,
          backgroundColor: primaryColor22,
          tooltip: "Filter",
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Theme(
                  data: ThemeData(canvasColor: transparent),
                  child: AlertDialog(
                    backgroundColor: transparent,
                    insetPadding: EdgeInsets.all(16),
                    contentPadding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    elevation: 0,
                    // backgroundColor: Colors.transparent,
                    content: SizedBox(
                      height: 260,
                      child: FilterWidget(
                        load: () {
                          setState(
                            () {
                              _drawerProvider = Provider.of<drawerProvider>(
                                  context,
                                  listen: false);

                              setState(() {
                                products = products
                                    .where((element) => (double.parse(element
                                                .product_weight
                                                .toString()) >=
                                            double.parse(_drawerProvider!.fromGm
                                                .toString()) &&
                                        double.parse(element.product_weight
                                                .toString()) <=
                                            double.parse(_drawerProvider!.toGM
                                                .toString())))
                                    .toList();

                                // getProducts();
                              });
                            },
                          );
                        },
                        loadWithOutFilter: () {
                          _drawerProvider = Provider.of<drawerProvider>(context,
                              listen: false);
                          _drawerProvider!.updateFilter(null, null);
                          setState(() {
                            getProducts();
                          });
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },

          child: Icon(
            Icons.filter_alt_outlined,
            color: primaryColor,
          ),
        ),
      ),
    );
  }

  Padding gridWidget(BuildContext context, ProductsRows data, double height,
      double width, bool inCart) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onLongPress: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Theme(
                data: ThemeData(canvasColor: transparent),
                child: AlertDialog(
                  backgroundColor: transparent,
                  insetPadding: EdgeInsets.all(16),
                  contentPadding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  elevation: 0,
                  // backgroundColor: Colors.transparent,
                  content: contentBox(context, data, height, width, () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProductDetailScreen(
                                  data: data,
                                  loadData: () {
                                    setState(() {
                                      getProducts();
                                    });
                                  },
                                )));
                  }),
                ),
              );
            },
          );
        },
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProductDetailScreen(
                        data: data,
                        loadData: () {
                          setState(() {
                            getProducts();
                          });
                        },
                      )));
        },
        child: Container(
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: secondaryTextColor.withOpacity(0.05),
                spreadRadius: 3,
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: height * 0.2,
                width: width * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(
                      data.product_images[0].toString(),
                    ),
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      inCart
                          ? SizedBox()
                          : Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: () {
                                  if (currentPhoneNumber.isEmpty) {
                                    Utils().toastMessage("Please login");
                                  } else {
                                    CartTable().insert({
                                      "product_id": data.product_id.toString(),
                                      "product_name":
                                          data.product_type.toString(),
                                      "product_material":
                                          data.product_material.toString(),
                                      "product_type":
                                          data.product_name.toString(),
                                      "product_weight":
                                          data.product_weight.toString(),
                                      "product_quantity": "1",
                                      "product_price":
                                          data.product_price.toString(),
                                      "user_name":
                                          currentUserDisplayName.toString(),
                                      "user_uid": currentUserUid.toString(),
                                      "user_phone":
                                          currentPhoneNumber.toString(),
                                      "added_time": DateTime.now().toString(),
                                      "product_image": data.product_images[0]
                                          .toString()
                                          .toString(),
                                    }).then((value) {
                                      Utils().toastMessage("Added to Cart");
                                      setState(() {
                                        getProducts();
                                      });
                                    }).onError((error, stackTrace) {
                                      log(error.toString());
                                      Utils()
                                          .toastMessage("Something went wrong");
                                    });
                                  }
                                },
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: primaryColor3,
                                  child: Icon(
                                    Icons.add_shopping_cart,
                                    size: 15,
                                    color: white,
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
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        data.product_type.toString(),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
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
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: Text(
                      "${data.product_weight.toString()} GM",
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: primaryColor22,
                      ),
                    ),
                  ),
                ),
              ),
              // Center(
              //   child: Container(
              //     height: 35,
              //     width: width * 0.38,
              //     decoration: BoxDecoration(
              //       color: blue.withOpacity(0.4),
              //       borderRadius: BorderRadius.circular(14),
              //     ),
              //     child: Center(
              //       child: CustomText(
              //         "Add to Cart",
              //         black.withOpacity(0.6),
              //         14,
              //         FontWeight.w700,
              //         TextOverflow.ellipsis,
              //       ),
              //     ),
              //   ),
              // ),
            ],
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
                          SizedBox(
                            width: width * 0.65,
                            child: CustomText(
                              valueOrDefault(data.product_name, "Jewellery"),
                              black,
                              20,
                              FontWeight.w900,
                              TextOverflow.ellipsis,
                            ),
                          ),
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
                    "View Details",
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
