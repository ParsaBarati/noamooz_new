import 'dart:io';

import 'package:noamooz/Plugins/get/get.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ChatSendImage extends StatelessWidget {
  final File image;
  final TextEditingController controller = TextEditingController();

  ChatSendImage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: Get.height / 2,
        width: Get.width / 1.1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Image.file(
                  image,
                  width: Get.width,
                  height: Get.height / 1.15,
                  fit: BoxFit.cover,
                ),
                buildTools(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSearch() {
    return SizedBox(
      height: Get.height / 18,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(
            width: 8.0,
          ),
          GestureDetector(
            onTap: () {
              Get.back(result: {
                'text': controller.text,
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: ColorUtils.black,
                ),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(11),
                child: Icon(
                  Icons.send_outlined,
                  color: ColorUtils.black,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTools() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        height: Get.height / 1,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorUtils.black.withOpacity(0.5),
                    ),
                    child: IconButton(
                      onPressed: () => Get.close(1),
                      icon: const Icon(
                        Ionicons.close_outline,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              buildSearch(),
            ],
          ),
        ),
      ),
    );
  }
}
