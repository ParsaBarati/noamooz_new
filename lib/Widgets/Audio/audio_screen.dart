import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:noamooz/Controllers/Audio/audio_controller.dart';
import 'package:noamooz/Plugins/get/get.dart';
import 'package:noamooz/Utils/color_utils.dart';

class AudioScreen extends StatelessWidget {
  final AudioController controller;

  const AudioScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 10,
        sigmaY: 10,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: ColorUtils.white.withOpacity(0.4),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.close(1);
                    },
                    child: Icon(
                      Iconsax.close_circle,
                      color: ColorUtils.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 12,
                    ),
                  ],
                ),
                width: Get.width - 24,
                height: Get.width - 24,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    controller.course!.cover,
                    height: 150.0,
                    width: 150.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              Text(
                controller.file!.alt,
                style: TextStyle(
                  fontSize: 18.0,
                  color: ColorUtils.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                controller.course!.name,
                style: TextStyle(
                  color: ColorUtils.black,
                ),
              ),
              const SizedBox(height: 12.0),
              Row(
                textDirection: TextDirection.ltr,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Iconsax.backward_10_seconds,
                    ),
                    color: ColorUtils.black,
                    iconSize: 36.0,
                    onPressed: () {
                      controller.audioPlayer.seek(
                          controller.audioPlayer.position -
                              const Duration(seconds: 10));
                    },
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Obx(
                    () => IconButton(
                      icon: Icon(
                        controller.isPlaying.value
                            ? Iconsax.pause
                            : Iconsax.play,
                        size: 40.0,
                      ),
                      padding: const EdgeInsets.all(16),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => ColorUtils.orange)),
                      onPressed: () {
                        controller.playPause();
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  IconButton(
                    icon: const Icon(
                      Iconsax.forward_10_seconds,
                    ),
                    color: ColorUtils.black,
                    iconSize: 36.0,
                    onPressed: () {
                      controller.audioPlayer.seek(
                          controller.audioPlayer.position +
                              const Duration(seconds: 10));
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Obx(
                  () => Directionality(
                    textDirection: TextDirection.ltr,
                    child: Transform.scale(
                      scale: 0.8,
                      child: Slider(
                        value: controller.volume.value,
                        activeColor: ColorUtils.orange.withOpacity(0.5),
                        inactiveColor: ColorUtils.gray.withOpacity(0.1),
                        thumbColor: ColorUtils.orange,
                        onChanged: (value) {
                          controller.setVolume(value);
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4.0),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    textDirection: TextDirection.ltr,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${controller.position.inMinutes}:${(controller.position.inSeconds % 60).toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: ColorUtils.black,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '${controller.audioPlayer.duration!.inMinutes}:${(controller.audioPlayer.duration!.inSeconds % 60).toString().padLeft(2, '0')}',
                            style: TextStyle(
                              color: ColorUtils.black,
                            ),
                          ),
                          const SizedBox(
                            width: 24,
                            height: 12,
                            child: VerticalDivider(
                              thickness: 1,
                            ),
                          ),
                          DropdownButton<double>(
                            value: controller.playbackSpeed.value,
                            style: TextStyle(
                              color: ColorUtils.black,
                              fontFamily: 'iranSans',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              letterSpacing: 1.5,
                            ),
                            onChanged: (value) {
                              controller.setPlaybackSpeed(value!);
                            },
                            dropdownColor: ColorUtils.white,
                            borderRadius: BorderRadius.circular(5),
                            elevation: 5,
                            items: const [
                              DropdownMenuItem(
                                value: 0.5,
                                child: Text('0.5x'),
                              ),
                              DropdownMenuItem(
                                value: 1.0,
                                child: Text('1.0x'),
                              ),
                              DropdownMenuItem(
                                value: 1.5,
                                child: Text('1.5x'),
                              ),
                              DropdownMenuItem(
                                value: 2.0,
                                child: Text('2.0x'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Obx(
                () => (controller.audioPlayer.duration?.inSeconds ?? 0) > 0 ? Directionality(
                  textDirection: TextDirection.ltr,
                  child: Slider(
                    value: controller.positionInSeconds.value.toDouble(),
                    min: 0,
                    activeColor: ColorUtils.orange,
                    thumbColor: ColorUtils.orange,
                    inactiveColor: ColorUtils.gray.withOpacity(0.2),
                    max: controller.audioPlayer.duration?.inSeconds.toDouble() ?? 1.0,
                    onChanged: (value) async {
                      controller.positionInSeconds.value =
                          controller.audioPlayer.position.inSeconds;
                      print(value);
                      await controller.audioPlayer.seek(
                        Duration(
                          seconds: value.toInt(),
                        ),
                      );

                    },
                  )) : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
