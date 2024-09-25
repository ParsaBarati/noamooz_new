import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/widget_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../Plugins/get/get.dart';

class TermsDialog extends StatelessWidget {
  WebViewController controller = WebViewController();

  TermsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          // onNavigationRequest: (NavigationRequest request) {
          //   if (request.url.startsWith('https://www.youtube.com/')) {
          //     return NavigationDecision.prevent;
          //   }
          //   return NavigationDecision.navigate;
          // },
        ),
      )
      ..loadRequest(
        Uri.parse("https://online-kiosk.ir/privacy.html"),



      );
    return Center(
      child: SizedBox(
        height: Get.height / 1.3,
        width: Get.width / 1.1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: ColorUtils.white,
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Text(
                          "قوانین و مقررات",
                          style: TextStyle(
                            color: ColorUtils.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Get.close(1),
                          child: Icon(
                            Ionicons.chevron_back_outline,
                            size: 25,
                            color: ColorUtils.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: WebViewWidget(controller: controller),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        WidgetUtils.softButton(
                          title: "تایید قوانین",
                          widthFactor: 3.5,
                          onTap: () => Get.back(
                            result: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
