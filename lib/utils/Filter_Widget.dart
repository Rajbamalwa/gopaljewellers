import 'package:flutter/material.dart';
import 'package:gopaljewellers/Widgets/button/gradient_button.dart';
import 'package:gopaljewellers/Widgets/custom/customtext.dart';
import 'package:gopaljewellers/Widgets/text_field/text_field_widget.dart';
import 'package:gopaljewellers/utils/utils.dart';
import 'package:provider/provider.dart';

import '../constants/color.dart';
import '../provider/provider.dart';

class FilterWidget extends StatefulWidget {
  final load;
  final loadWithOutFilter;
  const FilterWidget({this.load, this.loadWithOutFilter});

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  drawerProvider? _drawerProvider;

  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  List<String> productMaterial = ["GOLD", "SILVER", "PLATINUM"];
  var selectedMaterial;
  bool fieldEmpty = true;
  String selectedProductMaterial = "GOLD";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _drawerProvider = Provider.of<drawerProvider>(context, listen: false);

    fromController.text = _drawerProvider!.fromGm == null
        ? ""
        : _drawerProvider!.fromGm.toString();
    toController.text =
        _drawerProvider!.toGM == null ? "" : _drawerProvider!.toGM.toString();
    // selectedMaterial = _drawerProvider!.material;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Consumer<drawerProvider>(builder: (context, pro, child) {
        return Container(
          color: white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: CustomText(
                    "Filter",
                    primaryColor22,
                    22,
                    FontWeight.w900,
                    TextOverflow.clip,
                  ),
                ),
                const Divider(),
                Row(
                  children: [
                    CustomText(
                      "Weight  ",
                      primaryColor,
                      16,
                      FontWeight.w600,
                      TextOverflow.clip,
                    ),
                    CustomText(
                      "( GM )",
                      grey,
                      13,
                      FontWeight.w600,
                      TextOverflow.clip,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: CustomTextField(
                          maxLines: 1,
                          from: "Fi",
                          hintText: "From gm",
                          keyboardType: TextInputType.number,
                          controller: fromController,
                          // suffixIcon: Align(
                          //   alignment: Alignment.centerRight,
                          //   child: SizedBox(
                          //     width: 20,
                          //     child: CustomText(
                          //       "gm",
                          //       primaryColor,
                          //       10,
                          //       FontWeight.w600,
                          //       TextOverflow.clip,
                          //     ),
                          //   ),
                          // ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: CustomTextField(
                          maxLines: 1,
                          from: "Fi",
                          hintText: "To gm", keyboardType: TextInputType.number,
                          controller: toController,
                          // suffixIcon: Align(
                          //   alignment: Alignment.centerRight,
                          //   child: SizedBox(
                          //     width: 20,
                          //     child: CustomText(
                          //       "gm",
                          //       primaryColor,
                          //       10,
                          //       FontWeight.w600,
                          //       TextOverflow.clip,
                          //     ),
                          //   ),
                          // ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                // CustomText(
                //   "Material",
                //   primaryColor,
                //   16,
                //   FontWeight.w600,
                //   TextOverflow.clip,
                // ),
                // SizedBox(
                //   height: 50,
                //   width: width,
                //   child: ListView.builder(
                //     itemCount: productMaterial.length,
                //     shrinkWrap: true,
                //     scrollDirection: Axis.horizontal,
                //     itemBuilder: (context, index) {
                //       var data = productMaterial[index];
                //       return Padding(
                //         padding: const EdgeInsets.all(4.0),
                //         child: InkWell(
                //           onTap: () {
                //             setState(() {
                //               selectedMaterial = data;
                //             });
                //           },
                //           child: Container(
                //             decoration: BoxDecoration(
                //               color: selectedMaterial == data
                //                   ? primaryColor22.withOpacity(0.1)
                //                   : white,
                //               borderRadius: BorderRadius.circular(16),
                //               border: Border.all(
                //                 color: selectedMaterial == data
                //                     ? primaryColor22
                //                     : secondaryTextColor.withOpacity(0.6),
                //                 width: selectedMaterial == data ? 1 : 0.5,
                //               ),
                //             ),
                //             child: Center(
                //               child: Padding(
                //                 padding:
                //                     const EdgeInsets.only(left: 8, right: 8),
                //                 child: CustomText(
                //                   data.toString(),
                //                   primaryColor,
                //                   14,
                //                   FontWeight.w800,
                //                   TextOverflow.clip,
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                GradientButton(
                  width: width,
                  height: 40,
                  text: "Show",
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontColor: white,
                  onTap: () {
                    if (fromController.text.isNotEmpty) {
                      if (toController.text.isEmpty) {
                        Utils().toastMessage("To gm field is empty");
                      } else {
                        pro.updateFilter(
                          double.parse(fromController.text),
                          double.parse(toController.text),
                        );
                        widget.load();
                      }
                    } else {
                      pro.updateFilter(null, null);
                    }
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: IconButton(
                    splashColor: red.withOpacity(0.2),
                    splashRadius: 30,
                    tooltip: "Clear Filter",
                    onPressed: () {
                      widget.loadWithOutFilter();
                      pro.updateFilter(null, null);
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.clear,
                      color: red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
