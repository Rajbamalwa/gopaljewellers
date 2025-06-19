import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../Widgets/button/gradient_button.dart';
import '../../Widgets/custom/appBarWidget.dart';
import '../../Widgets/custom/customtext.dart';
import '../../Widgets/text_field/text_field_widget.dart';
import '../../backend/supabase/models/product_model.dart';
import '../../backend/supabase/models/productype_model.dart';
import '../../constants/color.dart';
import '../../services/helper.dart';
import '../../utils/loading.dart';
import '../../utils/utils.dart';

class AddProduct extends StatefulWidget {
  /*ProductsRows*/ final product;
  final load;
  AddProduct({super.key, this.product, required this.load});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  var selectedType;
  var selectedSubtype;
  var selectedIndex;
  String selectedProductType = "Temple Haar";
  String selectedProductMaterial = "GOLD";
  bool isProductUploading = false;
  bool isProductUpdating = false;
  var generatedProductId;

  List<String> productMaterial = ["GOLD", "SILVER", "PLATINUM"];

  double val = 0;
  late CollectionReference imgRef;
  var ref;
  List imageList = [];
  bool imageUploading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkEdit();
    getProductsType();
  }

  bool iSLoading = false;
  List<ProductTypeRows> types = [];

  getProductsType() async {
    setState(() {
      iSLoading = true;
    });
    await ProductTypeTable()
        .queryRows(
      queryFn: (q) => q.order('id', ascending: false),
    )
        .then((value) {
      log(value.toString());
      types.addAll(value);
    });

    setState(() {
      iSLoading = false;
    });
  }

  checkEdit() {
    if (widget.product == null) {
      generatedProductId = Helpers.genearateProductId();
    } else {
      log(widget.product.toString());
      selectedType = widget.product.product_name.toString();
      selectedSubtype = widget.product.product_type.toString();
      generatedProductId = widget.product.product_id.toString();
      selectedProductMaterial = widget.product.product_material.toString();
      descriptionController.text =
          widget.product.product_description.toString();
      weightController.text = widget.product.product_weight.toString();
      imageList = widget.product.product_images;
    }
  }

  List selectedImages = [];
  final picker = ImagePicker();

  Future getImages() async {
    final pickedFile = await picker.pickMultiImage();
    selectedImages.clear();
    if (pickedFile != null) {
      List<XFile> xfilePick = pickedFile;

      // Add new images
      for (var i = 0; i < xfilePick.length; i++) {
        setState(() {
          selectedImages.add(File(xfilePick[i].path));
        });
      }
    }
  }

  // uploadImages() async {
  //   int i = 1;
  //   if (selectedImages.isEmpty) {
  //   } else {
  //     setState(() {
  //       imageUploading = true;
  //     });
  //     for (var img in selectedImages) {
  //       setState(() {
  //         val = i / selectedImages.length;
  //       });
  //       ref = FirebaseStorage.instance
  //           .ref()
  //           .child('${"Products"}/${generatedProductId.toString()}');
  //       await ref.putFile(img).whenComplete(() async {
  //         await ref.getDownloadURL().then((value) {
  //           imageList.add(value.toString());
  //
  //           i++;
  //         });
  //         if (imageList.length == selectedImages.length) {
  //           setState(() {
  //             imageUploading = false;
  //           });
  //         }
  //       }).onError((error, stackTrace) {
  //         log(error.toString());
  //
  //         setState(() {
  //           imageUploading = false;
  //         });
  //         log(error.toString());
  //         Utils().toastMessage("Something went wrong!!");
  //       });
  //     }
  //   }
  // }
  Future<void> uploadImages() async {
    int i = 1;
    if (selectedImages.isEmpty) {
      return; // No images to upload
    } else {
      setState(() {
        imageUploading = true;
      });
      for (var img in selectedImages) {
        setState(() {
          val = i / selectedImages.length;
        });
        // Convert HEIF image to JPEG format
        List<int> imageBytes = await img.readAsBytes();
        String tempImagePath = '${img.path}.jpg';
        File tempImage = File(tempImagePath);
        await tempImage.writeAsBytes(imageBytes);

        ref = FirebaseStorage.instance
            .ref()
            .child('Products/${generatedProductId.toString()}/image_$i');
        try {
          await ref.putFile(tempImage);
          var downloadUrl = await ref.getDownloadURL();
          imageList.add(downloadUrl);
          log(imageList.toString());
          i++;
        } catch (error) {
          log(error.toString());
          setState(() {
            imageUploading = false;
          });
          Utils().toastMessage("Something went wrong!!");
          return; // Exit the function if error occurs
        }
      }
      setState(() {
        imageUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        widget.load();

        Navigator.pop(context);

        return false;
      },
      child: Scaffold(
        appBar: appBarWidget(
          widget.product == null
              ? "Add Product"
              : "Edit Product - ${widget.product.product_id.toString()}",
          true,
          [],
          () {
            widget.load();

            Navigator.pop(context);
          },
        ),
        body: isProductUploading == true ||
                isProductUpdating == true ||
                iSLoading == true
            ? Center(
                child: showLoading(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                      child: ListTile(
                        title: CustomText2(
                          "Select Product Type",
                          bluish,
                          12,
                          FontWeight.w400,
                          TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            showModalBottomSheet(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                  ),
                                ),
                                context: context,
                                builder: (context) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        title: CustomText2(
                                          "Select Product Type",
                                          primaryColor,
                                          15,
                                          FontWeight.w800,
                                          TextOverflow.ellipsis,
                                        ),
                                        trailing: IconButton(
                                          splashColor: red.withOpacity(0.3),
                                          splashRadius: 20,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: Icon(
                                            Icons.clear,
                                            color: red,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: types.length,
                                          itemBuilder: (context, index) {
                                            var data = types[index];
                                            return ListTile(
                                              tileColor:
                                                  selectedType == data.type
                                                      ? primaryColor22
                                                      : white,
                                              title: CustomText2(
                                                data.type.toString(),
                                                primaryColor,
                                                15,
                                                FontWeight.w800,
                                                TextOverflow.ellipsis,
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  selectedType = data.type;
                                                  selectedSubtype = null;
                                                  selectedIndex = index;
                                                });
                                                Navigator.pop(context);
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Container(
                            height: 50,
                            width: width,
                            decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.grey.shade600, width: 0.3)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: selectedType != null
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CustomText2(
                                          selectedType,
                                          primaryColor,
                                          15,
                                          FontWeight.w700,
                                          TextOverflow.ellipsis,
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CustomText2(
                                          "Select Product Type",
                                          secondaryTextColor,
                                          15,
                                          FontWeight.w700,
                                          TextOverflow.ellipsis,
                                        ),
                                        const Icon(Icons.arrow_drop_down_sharp)
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: ListTile(
                        title: CustomText2(
                          "Select Product Subtype",
                          bluish,
                          12,
                          FontWeight.w400,
                          TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: selectedType != null
                              ? () {
                                  showModalBottomSheet(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          topLeft: Radius.circular(20),
                                        ),
                                      ),
                                      context: context,
                                      builder: (context) {
                                        return Column(
                                          children: [
                                            ListTile(
                                              title: CustomText2(
                                                "Select Product Subtype",
                                                primaryColor,
                                                15,
                                                FontWeight.w800,
                                                TextOverflow.ellipsis,
                                              ),
                                              trailing: IconButton(
                                                splashColor:
                                                    red.withOpacity(0.3),
                                                splashRadius: 20,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: Icon(
                                                  Icons.clear,
                                                  color: red,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: ListView.builder(
                                                itemCount: types[selectedIndex]
                                                    .product_type
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  var data =
                                                      types[selectedIndex]
                                                          .product_type[index];
                                                  return ListTile(
                                                    tileColor:
                                                        selectedSubtype == data
                                                            ? primaryColor22
                                                            : white,
                                                    title: CustomText2(
                                                      data.toString(),
                                                      primaryColor,
                                                      15,
                                                      FontWeight.w800,
                                                      TextOverflow.ellipsis,
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        selectedSubtype = data;
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                }
                              : () {
                                  Utils().toastMessage("Please select type");
                                },
                          child: Container(
                            height: 50,
                            width: width,
                            decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.grey.shade600, width: 0.3)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: selectedSubtype != null
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CustomText2(
                                          selectedSubtype,
                                          primaryColor,
                                          15,
                                          FontWeight.w700,
                                          TextOverflow.ellipsis,
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CustomText2(
                                          "Select Product Type",
                                          secondaryTextColor,
                                          15,
                                          FontWeight.w700,
                                          TextOverflow.ellipsis,
                                        ),
                                        const Icon(Icons.arrow_drop_down_sharp)
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: ListTile(
                        title: CustomText2(
                          "Select Product Material",
                          bluish,
                          12,
                          FontWeight.w400,
                          TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Colors.grey.shade600, width: 0.3),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton<String>(
                              alignment: Alignment.topLeft,
                              isExpanded: false,
                              borderRadius: BorderRadius.circular(10.0),
                              underline: SizedBox(),
                              elevation: 10,
                              menuMaxHeight: 300,
                              value: selectedProductMaterial,
                              items: productMaterial.map((value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: CustomText(
                                      value,
                                      black,
                                      13,
                                      FontWeight.w500,
                                      TextOverflow.ellipsis,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (accountType) {
                                setState(() {
                                  selectedProductMaterial = accountType!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: ListTile(
                        title: CustomText2(
                          "Product Description",
                          bluish,
                          12,
                          FontWeight.w400,
                          TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    CustomTextField(
                      controller: descriptionController,
                      from: "FF",
                      hintText: "Description ( Optional )",
                      maxLines: 10,
                    ),
                    SizedBox(
                      height: 50,
                      child: ListTile(
                        title: CustomText2(
                          "Product Weight",
                          bluish,
                          12,
                          FontWeight.w400,
                          TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    CustomTextField(
                      controller: weightController,
                      from: "FF",
                      hintText: "Weight ( Required )",
                      maxLines: 1,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      onTap: () {
                        getImages().then((value) {
                          uploadImages();
                        });
                      },
                      title: CustomText2(
                        "Select Product Images",
                        primaryColor,
                        15,
                        FontWeight.w800,
                        TextOverflow.ellipsis,
                      ),
                      trailing: Icon(
                        Icons.add,
                        color: primaryColor,
                      ),
                    ),
                    imageUploading == true
                        ? Center(
                            child: showLoading(),
                          )
                        : imageList.isEmpty || imageList == []
                            ? SizedBox()
                            : Container(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ...imageList.map(
                                        (item) => Stack(
                                          alignment:
                                              AlignmentDirectional.topEnd,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 8, 20, 10),
                                              child: Container(
                                                height: 50,
                                                width: 50,
                                                child: Image.network(
                                                  item,
                                                  filterQuality:
                                                      FilterQuality.high,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 0, 15, 10),
                                              child: CircleAvatar(
                                                backgroundColor: red,
                                                radius: 10,
                                                child: Center(
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        imageList.remove(item);
                                                      });
                                                    },
                                                    child: Icon(
                                                      Icons.clear,
                                                      size: 15,
                                                      color: white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                  ],
                ),
              ),
        bottomNavigationBar: isProductUploading == true ||
                isProductUpdating == true ||
                iSLoading == true
            ? Center(
                child: showLoading(),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GradientButton(
                      width: width * 0.9,
                      height: 50,
                      text: widget.product == null
                          ? "Add Product"
                          : "Edit Product",
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      fontColor: Colors.black54,
                      onTap: () {
                        if (weightController.text.isEmpty) {
                          Utils().toastMessage("Please Add Weight");
                        } else if (imageList.isEmpty) {
                          Utils().toastMessage("Please Select Images");
                        } else if (selectedType == null) {
                          Utils().toastMessage("Please Select Product Type");
                        } else if (selectedSubtype == null) {
                          Utils().toastMessage("Please Select Product Subtype");
                        } else {
                          if (widget.product == null) {
                            addProduct();
                          } else {
                            editProduct();
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  editProduct() {
    setState(() {
      isProductUpdating = true;
    });
    ProductTables().update(
        data: {
          "product_name": selectedType.toString(),
          "product_description": descriptionController.text.toString(),
          "product_images": imageList,
          "product_weight": weightController.text.toString(),
          "product_type": selectedSubtype.toString(),
          "product_material": selectedProductMaterial.toString(),
          "product_likes": widget.product.product_likes,
        },
        matchingRows: (q) => q.eq(
            'product_id', widget.product.product_id.toString())).then((value) {
      setState(() {
        isProductUpdating = false;
      });
      Utils().toastMessage("Product Updated");
      widget.load();
      Navigator.pop(context);
    }).onError((error, stackTrace) {
      setState(() {
        isProductUpdating = false;
      });
      Utils().toastMessage("Something went wrong");
    });
  }

  addProduct() {
    setState(() {
      isProductUploading = true;
    });
    ProductTables().insert({
      "product_id": generatedProductId.toString(),
      "product_name": selectedType.toString(),
      "product_description": descriptionController.text.toString(),
      "product_images": imageList,
      "product_weight": weightController.text.toString(),
      "product_type": selectedSubtype.toString(),
      "product_material": selectedProductMaterial.toString(),
      "product_likes": [],
    }).then((value) {
      setState(() {
        isProductUploading = false;
      });
      widget.load();

      Navigator.pop(context);
      Utils().toastMessage("Product published");
    }).onError((error, stackTrace) {
      setState(() {
        isProductUploading = false;
      });
      Utils().toastMessage("Something went wrong");
    });
  }
}
