import 'dart:io';

import 'package:noamooz/Models/Forums/forum_message_model.dart';
import 'package:noamooz/Models/Forums/forum_model.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../../Plugins/get/get.dart';

class ViewPhotoWidget extends StatelessWidget {
  final ForumMessage message;

  final void Function(String)? download;

  const ViewPhotoWidget({
    Key? key,
    required this.message,
    this.download,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
        ),
        height: Get.height / 1,
        width: Get.width / 1,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PhotoView(
                imageProvider: buildImage(),
                backgroundDecoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.0),
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.close,
                      size: 40,
                      color: ColorUtils.white,
                    ),
                  ),
                ],
              ),
            ),
            if (!(message.content['isLocal'] == true) && download != null)
            Positioned(
              top: 12,
              left: 12,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      download?.call(message.content['path']);
                    },
                    child: Icon(
                      Icons.download,
                      size: 40,
                      color: ColorUtils.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider buildImage() {
    return message.content['isLocal'] == true
        ? FileImage(
            File(
              message.content['path'],
            ),
          )
        : NetworkImage(message.content['path']) as ImageProvider;
  }
}
