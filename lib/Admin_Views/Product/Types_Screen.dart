import 'dart:developer';

import 'package:flutter/material.dart';

import '../../Widgets/custom/appBarWidget.dart';
import '../../Widgets/custom/customtext.dart';
import '../../backend/supabase/models/productype_model.dart';
import '../../constants/color.dart';
import '../../utils/loading.dart';
import '../../utils/utils.dart';
import 'AddTypes.dart';

class TypesScreen extends StatefulWidget {
  const TypesScreen({super.key});

  @override
  State<TypesScreen> createState() => _TypesScreenState();
}

class _TypesScreenState extends State<TypesScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        "Product Types",
        true,
        [],
        () {
          Navigator.pop(context);
        },
      ),
      body: iSLoading == true
          ? Center(
              child: showLoading(),
            )
          : types.isEmpty
              ? Center(
                  child: CustomText(
                    "No product types found",
                    secondaryTextColor,
                    14,
                    FontWeight.w800,
                    TextOverflow.fade,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: types.length,
                        itemBuilder: (context, index) {
                          var data = types[index];
                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddTypes(
                                    load: () {
                                      setState(() {
                                        types.clear();
                                        getProductsType();
                                      });
                                    },
                                    types: data,
                                  ),
                                ),
                              );
                            },
                            title: CustomText(
                              data.type.toString(),
                              black,
                              18,
                              FontWeight.w800,
                              TextOverflow.fade,
                            ),
                            trailing: IconButton(
                                splashRadius: 20,
                                splashColor: primaryColor22,
                                tooltip:
                                    "Update ${data.type.toString().toLowerCase()} list",
                                onPressed: () {
                                  ProductTypeTable()
                                      .delete(
                                          matchingRows: (q) => q.eq(
                                              'product_type_id',
                                              data.product_type_id.toString()))
                                      .then((value) {
                                    Utils().toastMessage("Item removed");
                                    types.clear();
                                    getProductsType();
                                  }).onError((error, stackTrace) {
                                    Utils()
                                        .toastMessage("Something went wrong");
                                  });
                                },
                                icon: Icon(
                                  Icons.delete_outline_outlined,
                                  color: red,
                                )),
                          );
                        },
                      ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Product Type",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddTypes(
                load: () {
                  setState(() {
                    types.clear();
                    getProductsType();
                  });
                },
                types: null,
              ),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: primaryColor,
        ),
        backgroundColor: primaryColor22,
      ),
    );
  }
}
