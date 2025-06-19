import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gopaljewellers/Widgets/button/gradient_button.dart';
import 'package:gopaljewellers/Widgets/custom/appBarWidget.dart';
import 'package:gopaljewellers/backend/authentication/auth_util.dart';
import 'package:gopaljewellers/utils/loading.dart';
import 'package:gopaljewellers/views/product_detail/components/image_zoom.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../Widgets/button/custom_button.dart';
import '../../Widgets/custom/customtext.dart';
import '../../backend/supabase/models/cart_model.dart';
import '../../backend/supabase/models/product_model.dart';
import '../../constants/color.dart';
import '../../utils/flutter_flow/default_value.dart';
import '../../utils/utils.dart';
import '../cart/cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  ProductsRows data;
  final loadData;

  ProductDetailScreen({required this.data, required this.loadData});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  List likes = [];

  // final Completer<GoogleMapController> _controller =
  //     Completer<GoogleMapController>();
  //
  // static const CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );
  //
  // static const CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);

  List<ProductsRows> products = [];
  bool isProductsLoading = false;

  getProducts() async {
    setState(() {
      isProductsLoading = true;
    });
    await ProductTables()
        .queryRows(
      queryFn: (q) => q
          .eq("product_type", widget.data.product_type)
          .neq("product_id", widget.data.product_id)
          .eq("product_material", widget.data.product_material)
          .limit(10)
          .order('id', ascending: false),
    )
        .then((value) {
      log(value.toString());

      products.addAll(value);
      log(products.toString());
    });

    setState(() {
      isProductsLoading = false;
    });
  }

  List<CartRow> cart = [];
  bool iSLoading = false;

  getCart() async {
    setState(() {
      iSLoading = true;
    });
    await CartTable()
        .queryRows(
      queryFn: (q) => q
          .eq("product_id", widget.data.product_id.toString())
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

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    likes = widget.data.product_likes;
    WidgetsBinding.instance.addPostFrameCallback((_) => getProducts());
    WidgetsBinding.instance.addPostFrameCallback((_) => getCart());
  }

  var selectedImage;

  List downloaded = [];
  // void _saveNetworkImage(url) async {
  //   GallerySaver.saveImage(url, albumName: "Gopal Jewellers").then((value) {
  //     if (downloaded.length == widget.data.product_images.length) {
  //       Utils().toastMessage("Images downloaded");
  //     }
  //     log("Value - ${value.toString()}");
  //   }).onError((error, stackTrace) {
  //     log("Error - ${error.toString()}");
  //   });
  // }
  Future<void> _saveNetworkImage(String imageUrl) async {
    try {
      final http.Response response = await http.get(Uri.parse(imageUrl));
      final Uint8List bytes = response.bodyBytes;
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath = '${tempDir.path}/temp_image.png';
      final File imageFile = File(filePath);
      await imageFile.writeAsBytes(bytes);

      final result = await GallerySaver.saveImage(
        filePath,
        albumName: 'Gopal Jewellers', // Replace with your desired album name
      );
      if (downloaded.length == widget.data.product_images.length) {
        // Utils().toastMessage("Images downloaded");
        if (result != null) {
          Utils().toastMessage("Images saved to gallery");

          // showSnackBar(context, 'Images saved to gallery');
        } else {
          Utils().toastMessage("Failed to save images to gallery");
          // showSnackBar(context, 'Failed to save images to gallery');
        }
      }
    } catch (e) {
      log(e.toString());
      // showDowloadMessage = 'Error saving images: $e';
    }
  }

  ScreenshotController screenshotController = ScreenshotController();

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
        appBar: appBarWidget(widget.data.product_name, true, [
          GestureDetector(
            onTap: () {
              String shareText =
                  "See this ${widget.data.product_name} its soo gorgeous. Checkout this at gopaljewellers.com";
              Utils().captureScreenShotAndText(screenshotController, shareText);
            },
            child: CircleAvatar(
              radius: 15,
              backgroundColor: primaryColor,
              child: Icon(
                Icons.share,
                size: 20,
                color: white,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ], () {
          widget.loadData();
          Navigator.pop(context);
        }),
        body: iSLoading == true || isProductsLoading == true
            ? Center(child: showLoading())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: height * 0.5,
                          child: PageView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.data.product_images.length,
                            onPageChanged: (i) {
                              selectedImage = widget.data.product_images[i];
                            },
                            itemBuilder: (context, index) {
                              var image = widget.data.product_images[index];
                              return Screenshot(
                                controller: screenshotController,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ImageZoomScreen(
                                          images: widget.data.product_images,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 300,
                                    width: width,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          image,
                                        ),
                                        fit: BoxFit.cover,
                                        filterQuality: FilterQuality.high,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: primaryColor,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: InkWell(
                                        onTap: likes.contains(
                                                currentPhoneNumber.toString())
                                            ? () {
                                                likes.remove(currentPhoneNumber
                                                    .toString());
                                                ProductTables().update(
                                                    data: {
                                                      "product_likes": likes,
                                                    },
                                                    matchingRows: (q) => q.eq(
                                                        "product_id",
                                                        widget.data
                                                            .product_id)).then(
                                                    (value) {
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
                                                if (currentPhoneNumber
                                                    .isEmpty) {
                                                  Utils().toastMessage(
                                                      "Please login");
                                                } else {
                                                  likes.add(currentPhoneNumber
                                                      .toString());

                                                  ProductTables().update(
                                                      data: {
                                                        "product_likes": likes,
                                                      },
                                                      matchingRows: (q) => q.eq(
                                                          "product_id",
                                                          widget.data
                                                              .product_id)).then(
                                                      (value) {
                                                    setState(() {});

                                                    Utils().toastMessage(
                                                        "Added to favourite");
                                                  }).onError(
                                                      (error, stackTrace) {
                                                    log(error.toString());
                                                    Utils().toastMessage(
                                                        "Something went wrong");
                                                  });
                                                }
                                              },
                                        child: Icon(
                                          likes.contains(
                                                  currentPhoneNumber.toString())
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          semanticLabel: "Favourite",
                                          color: likes.contains(
                                                  currentPhoneNumber.toString())
                                              ? red
                                              : red,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: Align(
                                  //     alignment: Alignment.bottomRight,
                                  //     child: InkWell(
                                  //       onTap: () {
                                  //         Navigator.push(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //             builder: (_) => ImageZoomScreen(
                                  //               images:
                                  //                   widget.data.product_images,
                                  //             ),
                                  //           ),
                                  //         );
                                  //       },
                                  //       child: Icon(
                                  //         Icons.crop_free,
                                  //         semanticLabel: "Open",
                                  //         color: white,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: InkWell(
                                        onTap: () {
                                          for (String url
                                              in widget.data.product_images) {
                                            downloaded.add("1");
                                            _saveNetworkImage(url);
                                          }
                                        },
                                        child: Icon(
                                          Icons.download_outlined,
                                          semanticLabel: "Download",
                                          color: green,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: Text(
                          widget.data.product_type.toString(),
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 20, 10),
                        child: Row(
                          children: [
                            Text(
                              "❤ ",
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w100,
                                color: red,
                              ),
                            ),
                            Text(
                              "${widget.data.product_likes.length.toString()} likes by users",
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                        child: Row(
                          children: [
                            Text(
                              "Product Id - ",
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: black,
                              ),
                            ),
                            Text(
                              widget.data.product_id.toString(),
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                        child: Text(
                          widget.data.product_description.toString(),
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: secondaryTextColor.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
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
                                  "${widget.data.product_weight} GM",
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
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Divider(
                        color: secondaryTextColor.withOpacity(0.2),
                        thickness: 0.5,
                      ),
                    ),
                    detils(width, "Material",
                        widget.data.product_material.toString()),
                    detils(width, "Type", widget.data.product_name.toString()),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Divider(
                        color: secondaryTextColor.withOpacity(0.2),
                        thickness: 0.5,
                      ),
                    ),
                    products.isEmpty
                        ? SizedBox()
                        : ListTile(
                            title: CustomText(
                              "Similar products",
                              black,
                              20,
                              FontWeight.w900,
                              TextOverflow.fade,
                            ),
                          ),
                    products.isEmpty
                        ? SizedBox()
                        : Container(
                            height: 290,
                            child: Row(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    controller: scrollController,
                                    itemCount: products.length,
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.only(left: 8),
                                    itemBuilder: (context, index) {
                                      var data = products[index];
                                      final inCart = cart.any((cartProduct) =>
                                          cartProduct.product_id ==
                                          data.product_id);
                                      log(inCart.toString());

                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          onLongPress: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Theme(
                                                  data: ThemeData(
                                                      canvasColor: transparent),
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
                                                          BorderRadius.circular(
                                                              0.0),
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
                                                                  ProductDetailScreen(
                                                                    data: data,
                                                                    loadData:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        cart.clear();
                                                                        products
                                                                            .clear();
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
                                                    builder: (_) =>
                                                        ProductDetailScreen(
                                                          data: data,
                                                          loadData: () {
                                                            setState(() {
                                                              cart.clear();
                                                              products.clear();
                                                              getCart();
                                                              getProducts();
                                                            });
                                                          },
                                                        )));
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: height * 0.25,
                                                width: width * 0.4,
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
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      inCart
                                                          ? SizedBox()
                                                          : Align(
                                                              alignment: Alignment
                                                                  .bottomRight,
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  if (currentPhoneNumber
                                                                      .isEmpty) {
                                                                    Utils().toastMessage(
                                                                        "Please login");
                                                                  } else {
                                                                    CartTable().insert({
                                                                      "product_id": data
                                                                          .product_id
                                                                          .toString(),
                                                                      "product_name": data
                                                                          .product_type
                                                                          .toString(),
                                                                      "product_material": data
                                                                          .product_material
                                                                          .toString(),
                                                                      "product_type": data
                                                                          .product_name
                                                                          .toString(),
                                                                      "product_weight": data
                                                                          .product_weight
                                                                          .toString(),
                                                                      "product_quantity":
                                                                          "1",
                                                                      "product_price": data
                                                                          .product_price
                                                                          .toString(),
                                                                      "user_name":
                                                                          currentUserDisplayName
                                                                              .toString(),
                                                                      "user_uid":
                                                                          currentUserUid
                                                                              .toString(),
                                                                      "user_phone":
                                                                          currentPhoneNumber
                                                                              .toString(),
                                                                      "added_time":
                                                                          DateTime.now()
                                                                              .toString(),
                                                                      "product_image": data
                                                                          .product_images[
                                                                              0]
                                                                          .toString()
                                                                          .toString(),
                                                                    }).then(
                                                                        (value) {
                                                                      Utils().toastMessage(
                                                                          "Added to Cart");
                                                                      setState(
                                                                          () {
                                                                        cart.clear();
                                                                        products
                                                                            .clear();
                                                                        getCart();
                                                                        getProducts();
                                                                      });
                                                                    }).onError(
                                                                        (error,
                                                                            stackTrace) {
                                                                      log(error
                                                                          .toString());
                                                                      Utils().toastMessage(
                                                                          "Something went wrong");
                                                                    });
                                                                  }
                                                                },
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: 15,
                                                                  backgroundColor:
                                                                      primaryColor3,
                                                                  child: Icon(
                                                                    Icons
                                                                        .add_shopping_cart,
                                                                    size: 15,
                                                                    color:
                                                                        white,
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
                                                width: width * 0.4,
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Text(
                                                        data.product_name
                                                            .toString(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.left,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w700,
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
                                                    padding: const EdgeInsets
                                                        .fromLTRB(8, 0, 8, 8),
                                                    child: Text(
                                                      data.product_weight
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.clip,
                                                      textAlign: TextAlign.left,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: primaryColor22,
                                                      ),
                                                    ),
                                                  ),
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
                  ],
                ),
              ),
        bottomNavigationBar: iSLoading == true || isProductsLoading == true
            ? SizedBox(
                height: 10,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  cart.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GradientButton(
                            width: width * 0.9,
                            height: 45,
                            text: "Go to Cart",
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            fontColor: primaryColor,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => CartScreen(
                                            loadData: () {
                                              setState(() {
                                                cart.clear();
                                                products.clear();
                                                getCart();
                                                getProducts();
                                              });
                                            },
                                          )));
                            },
                          ))
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GradientButton(
                            width: width * 0.9,
                            height: 45,
                            text: "Add to Cart",
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            fontColor: primaryColor,
                            onTap: () {
                              if (currentPhoneNumber.isEmpty) {
                                Utils().toastMessage("Please login");
                              } else {
                                CartTable().insert({
                                  "product_id":
                                      widget.data.product_id.toString(),
                                  "product_name":
                                      widget.data.product_name.toString(),
                                  "product_material":
                                      widget.data.product_material.toString(),
                                  "product_type":
                                      widget.data.product_type.toString(),
                                  "product_weight":
                                      widget.data.product_weight.toString(),
                                  "product_quantity": "1",
                                  "product_price":
                                      widget.data.product_price.toString(),
                                  "user_name":
                                      currentUserDisplayName.toString(),
                                  "user_uid": currentUserUid.toString(),
                                  "user_phone": currentPhoneNumber.toString(),
                                  "added_time": DateTime.now().toString(),
                                  "product_image":
                                      widget.data.product_images[0].toString()
                                }).then((value) {
                                  Utils().toastMessage("Added");
                                  setState(() {
                                    cart.clear();

                                    products.clear();
                                    getProducts();
                                    getCart();
                                  });
                                }).onError((error, stackTrace) {
                                  log(error.toString());
                                  Utils().toastMessage("Something went wrong");
                                });
                              }
                            },
                          ),
                        ),
                ],
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
                  child: CustomText2(
                    "View Details",
                    black,
                    16,
                    FontWeight.w800,
                    TextOverflow.clip,
                  ),
                  height: 50,
                  color: white,
                  radius: 4,
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

  Widget detils(width, title, value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
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
