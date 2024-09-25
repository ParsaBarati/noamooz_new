import 'package:noamooz/Utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../Plugins/get/get.dart';

class ChooseSourceAlert extends StatelessWidget {
  final String type;
  final bool lockAspectRatio;
  final int x;
  final int y;

  const ChooseSourceAlert({
    super.key,
    this.type = 'image',
    this.lockAspectRatio = true,
    this.x = 16,
    this.y = 9,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(12),
        width: Get.width,
        height: Get.height / 4.2,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => pickImage(
                  ImageSource.gallery,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorUtils.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10.0),
                      onTap: () => pickImage(
                        ImageSource.gallery,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Iconsax.gallery,
                              color: ColorUtils.orange,
                              size: 50,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              "گالری",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorUtils.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: ColorUtils.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10.0),
                    onTap: () => pickImage(
                      ImageSource.camera,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.camera,
                            color: ColorUtils.orange,
                            size: 50,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            "دوربین",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ColorUtils.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    XFile? image;
    if (type == 'video') {
      image = await picker.pickVideo(
        source: source,
      );
    } else {
      image = await picker.pickImage(
        source: source,
        maxHeight: 700,
        maxWidth: 700,
        imageQuality: lockAspectRatio ? 50 : 100,
      );
    }
    if (image is XFile) {
      CroppedFile? croppedFile = await ImageCropper.platform.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        aspectRatio: CropAspectRatio(
          ratioX: x.toDouble(),
          ratioY: y.toDouble(),
        ),
        compressQuality: lockAspectRatio ? 50 : 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'برش تصویر',
            toolbarColor: ColorUtils.orange,
            backgroundColor: ColorUtils.white,
            toolbarWidgetColor: ColorUtils.black,
            initAspectRatio: y == x
                ? CropAspectRatioPreset.square
                : CropAspectRatioPreset.ratio16x9,
            lockAspectRatio: lockAspectRatio,
          ),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
          ),
        ],
      );
      if (croppedFile != null) {
        Get.back(
          result: XFile(
            croppedFile.path,
          ),
        );
      }
    } else {
      Get.back();
    }
  }
}
