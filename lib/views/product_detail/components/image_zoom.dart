import 'package:flutter/material.dart';
import 'package:gopaljewellers/constants/color.dart';
import 'package:zoom_widget/zoom_widget.dart';

import '../../../Widgets/custom/appBarWidget.dart';

class ImageZoomScreen extends StatefulWidget {
  var images;
  ImageZoomScreen({required this.images});

  @override
  State<ImageZoomScreen> createState() => _ImageZoomScreenState();
}

class _ImageZoomScreenState extends State<ImageZoomScreen> {
  PageController controller = PageController();
  List img = [];
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: appBarWidget("Zoom Image", true, [], () {
        Navigator.pop(context);
      }),
      body: Stack(
        children: [
          // Zoom(
          //   initTotalZoomOut: true,
          //   maxZoomWidth: 1800,
          //   maxZoomHeight: 1800,
          //   initScale: 1,
          //   colorScrollBars: primaryColor22,
          //   backgroundColor: primaryColor,
          //   canvasColor: primaryColor,
          //   child: Image.network(
          //     widget.images,
          //     fit: BoxFit.cover,
          //   ),
          // ),
          PageView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.images.length,
            controller: controller,
            onPageChanged: (i) {},
            pageSnapping: true,
            itemBuilder: (context, index) {
              var image = widget.images[index];
              return Zoom(
                initTotalZoomOut: true,
                maxZoomWidth: 1000,
                maxZoomHeight: 1000,
                initScale: 0,
                colorScrollBars: primaryColor22,
                backgroundColor: primaryColor,
                onScaleUpdate: (a, b) {
                  setState(() {});
                },
                onMinZoom: (b) {},
                child: Container(
                  // height: height,
                  // width: width,
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
              );
            },
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      controller.previousPage(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_outlined,
                      size: 30,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      controller.nextPage(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn);
                    },
                    child: Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 30,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
