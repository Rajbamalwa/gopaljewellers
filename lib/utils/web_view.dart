import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({required this.url});

  final String url;

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  // WebViewController? controller;
  // @override
  // void initState() {
  //   super.initState();
  //   controller = WebViewController()
  //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //     ..setNavigationDelegate(
  //       NavigationDelegate(
  //         onProgress: (int progress) {
  //           // Update loading bar.
  //         },
  //         onPageStarted: (String url) {},
  //         onPageFinished: (String url) {},
  //         onWebResourceError: (WebResourceError error) {},
  //       ),
  //     )
  //     ..loadRequest(Uri.parse(widget.url.toString()));
  // }
  late InAppWebViewController _webViewController;
  int _stackIndex = 1;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.all(12),
      child: Expanded(
        child: IndexedStack(
          index: _stackIndex,
          children: [
            InAppWebView(
              initialUrlRequest:
                  URLRequest(url: WebUri.uri(Uri.parse(widget.url))),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                    useShouldOverrideUrlLoading: true, incognito: true),
              ),
              onLoadStop: (_, __) {
                setState(() {
                  _stackIndex = 0;
                });
              },
              onLoadError: (_, __, ___, ____) {
                setState(() {
                  _stackIndex = 0;
                });
                //TODO: Show error alert message (Error in receive data from server)
              },
              onLoadHttpError: (_, __, ___, ____) {
                setState(() {
                  _stackIndex = 0;
                });
                //TODO: Show error alert message (Error in receive data from server)
              },
            ),
            const SizedBox(
              height: 50,
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    ));
    // return WebViewWidget(controller: controller!);
  }
}
