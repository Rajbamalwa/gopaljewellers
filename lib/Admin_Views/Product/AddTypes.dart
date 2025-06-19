import 'package:flutter/material.dart';

import '../../Widgets/button/gradient_button.dart';
import '../../Widgets/custom/appBarWidget.dart';
import '../../Widgets/custom/customtext.dart';
import '../../Widgets/text_field/text_field_widget.dart';
import '../../backend/supabase/models/productype_model.dart';
import '../../constants/color.dart';
import '../../services/helper.dart';
import '../../utils/loading.dart';
import '../../utils/utils.dart';

class AddTypes extends StatefulWidget {
  final load;
  final types;

  AddTypes({required this.load, required this.types});

  @override
  State<AddTypes> createState() => _AddTypesState();
}

class _AddTypesState extends State<AddTypes> {
  TextEditingController type = TextEditingController();
  TextEditingController type_2 = TextEditingController();
  bool isUploading = false;
  bool updating = false;
  bool nameUpdating = false;
  List list = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.types != null) {
      type.text = widget.types.type.toString();
      list = widget.types.product_type;
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
        appBar: appBarWidget("Add product types", true, [], () {
          widget.load();
          Navigator.pop(context);
        }),
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            CustomTextField(
              controller: type,
              from: "FF",
              hintText: "Type ( Required )",
              maxLines: 1,
              keyboardType: TextInputType.name,
              onChanged: (value) {
                if (widget.types != null) {
                  setState(() {
                    nameUpdating = true;
                  });
                  ProductTypeTable().update(
                      data: {
                        "type": value.toString(),
                      },
                      matchingRows: (q) => q.eq('product_type_id',
                          widget.types.product_type_id.toString())).then(
                      (value) {
                    setState(() {
                      nameUpdating = false;
                    });
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                    setState(() {
                      nameUpdating = false;
                    });
                  });
                }
              },
              suffixIcon: nameUpdating == true
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    )
                  : SizedBox(),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  var data = list[index];
                  return ListTile(
                    title: CustomText(
                      data.toString(),
                      black,
                      15,
                      FontWeight.w800,
                      TextOverflow.fade,
                    ),
                    trailing: IconButton(
                        splashRadius: 20,
                        splashColor: red.withOpacity(0.2),
                        tooltip: "Update ${data.toString().toLowerCase()} list",
                        onPressed: widget.types == null
                            ? () {
                                setState(() {
                                  list.remove(list[index]);
                                });
                              }
                            : () {
                                setState(() {
                                  updating = true;

                                  list.remove(list[index]);
                                });
                                ProductTypeTable().update(
                                    data: {
                                      "product_type": list,
                                    },
                                    matchingRows: (q) => q.eq(
                                        'product_type_id',
                                        widget.types.product_type_id
                                            .toString())).then((value) {
                                  Utils().toastMessage("Item removed");
                                }).onError((error, stackTrace) {
                                  Utils().toastMessage("Something went wrong");
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
            SizedBox(
              height: 10,
            ),
            widget.types != null
                ? SizedBox()
                : isUploading == true
                    ? Center(
                        child: showLoading(),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: GradientButton(
                          width: width,
                          height: 50,
                          text: "Add to types",
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          fontColor: Colors.black87,
                          onTap: () {
                            if (type.text.isEmpty) {
                              Utils().toastMessage("Type is Empty");
                            } else if (list.isEmpty) {
                              Utils().toastMessage("Sub is Empty");
                            } else {
                              setState(() {
                                isUploading = true;
                              });
                              ProductTypeTable().insert({
                                "product_type_id":
                                    Helpers.genearateProductTypeId(),
                                "type": type.text.toUpperCase(),
                                "product_type": list
                              }).then((value) {
                                Utils().toastMessage("Product Type Added");
                                setState(() {
                                  type.clear();
                                  type_2.clear();
                                  list.clear();
                                  isUploading = false;
                                });
                              }).onError((error, stackTrace) {
                                Utils().toastMessage("Something went wrong");
                                setState(() {
                                  isUploading = false;
                                });
                              });
                            }
                          },
                        ),
                      )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: "Add new subtype",
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Theme(
                  data: ThemeData(canvasColor: white),
                  child: AlertDialog(
                    backgroundColor: white,
                    insetPadding: EdgeInsets.all(16),
                    // contentPadding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 0,
                    // backgroundColor: Colors.transparent,
                    content: Container(
                      height: 60,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: type_2,
                            from: "FF",
                            hintText: "Subtype ( Required )",
                            maxLines: 1,
                            keyboardType: TextInputType.name,
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: CustomText(
                          "Cancel",
                          red,
                          15,
                          FontWeight.w800,
                          TextOverflow.fade,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (type_2.text.isEmpty) {
                            Utils().toastMessage("Field is Empty");
                          } else {
                            setState(() {
                              list.add(type_2.text);
                              type_2.clear();
                            });
                            if (widget.types == null) {
                              Navigator.pop(context);
                            } else {
                              ProductTypeTable().update(
                                  data: {"product_type": list},
                                  matchingRows: (q) => q.eq(
                                      'product_type_id',
                                      widget.types.product_type_id
                                          .toString())).then((value) {
                                Utils().toastMessage("Product Type Added");
                                setState(() {
                                  type_2.clear();

                                  isUploading = false;
                                });
                                Navigator.pop(context);
                              }).onError((error, stackTrace) {
                                Utils().toastMessage("Something went wrong");
                                setState(() {
                                  isUploading = false;
                                });
                              });
                            }
                          }
                        },
                        child: CustomText(
                          "Add",
                          blue,
                          15,
                          FontWeight.w800,
                          TextOverflow.fade,
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          },
          backgroundColor: primaryColor22,
          child: Icon(
            Icons.add,
            color: primaryColor,
          ),
        ),
      ),
    );
  }
}
