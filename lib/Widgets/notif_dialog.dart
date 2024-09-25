import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../Plugins/get/get.dart';

class NotifDialog extends StatelessWidget {
  final RemoteMessage event;

  NotifDialog({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(event.notification?.android?.imageUrl);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: ColorUtils.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        if (event.notification?.android?.imageUrl != null &&
                            event.notification?.android?.imageUrl
                                    .toString()
                                    .trim()
                                    .isNotEmpty ==
                                true) ...[
                          SizedBox(
                            width: 50,
                            child: Image.network(
                              event.notification!.android!.imageUrl!,
                              width: 50,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                        ],
                        Expanded(
                          child: Text(
                            event.notification?.title ?? "",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ColorUtils.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 24,
                      width: Get.width / 2,
                      child: const Divider(
                        thickness: 1.5,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            event.notification?.body ?? "",
                            style: TextStyle(
                              color: ColorUtils.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (event.data['link']?.toString().isURL == true) ...[
                          GestureDetector(
                            onTap: () {
                              launchUrlString(event.data['link'] ?? "");
                            },
                            child: Text(
                              "مشاهده لینک",
                              style: TextStyle(
                                color: ColorUtils.blue,
                                decoration: TextDecoration.underline,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 12,
                            child: VerticalDivider(
                              color: ColorUtils.orange,
                              thickness: 1,
                            ),
                            height: 15,
                          ),
                        ],
                        GestureDetector(
                          onTap: () {
                            Get.back(
                              result: false,
                            );
                          },
                          child: Text(
                            "فهمیدم",
                            style: TextStyle(
                              color: ColorUtils.textGray,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
