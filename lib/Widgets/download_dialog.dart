import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:noamooz/Controllers/Audio/audio_controller.dart';
import 'package:noamooz/Globals/Globals.dart';
import 'package:noamooz/Models/Courses/course_model.dart';
import 'package:noamooz/Models/file_model.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/storage_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Widgets/Audio/audio_screen.dart';
import 'package:noamooz/Widgets/pdf_player_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:screen_protector/screen_protector.dart';

import '../Plugins/get/get.dart';
import 'video_player_screen.dart';

class DownloadController extends GetxController {
  RxInt progress = 0.obs;
  Timer? timer;
  ValueNotifier downloadProgressNotifier = ValueNotifier(0);

  void startDownload() {
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (progress.value < 100) {
        progress.value += 1;
      } else {
        timer.cancel();
        progress.value = 0;
        // Get.close(1);
      }
    });
  }

  downloadFileFromServer(FileModel fileModel, CourseModel courseModel) async {
    downloadProgressNotifier.value = 0;
    Directory dir = await getApplicationDocumentsDirectory();
    String fullPath = "${dir.path}/${fileModel.path.split('/').last}";
    File file = File(fullPath);
    print(file.existsSync());
    if (!file.existsSync()) {
      await Dio().download(fileModel.path, fullPath,
          onReceiveProgress: (actualBytes, int totalBytes) {
        print(actualBytes);
        downloadProgressNotifier.value =
            (actualBytes / totalBytes * 100).floor();
      });

      timer?.cancel();
      Get.close(1);
    }
    if (file.existsSync()) {
      print(file.path);
      switch (file.path.split('.').last) {
        case "pdf":
          Get.to(
            () => PdfPlayerScreen(
              path: file.path,
              title: fileModel.alt,
            ),
          );
          break;
        case "mp4":
        case "avi":
        case "wmv":
        case "rmvb":
        case "mpg":
        case "mpeg":
        case "3gp":
          Get.to(
            () => VideoPlayerScreen(
              path: file.path,
              isMusic: false,
              title: fileModel.alt,
            ),
          );
          break;
        case "mp3":
        case "ogg":
        case "wav":
        case "wma":
        case "amr":
          if ((fileModel.fileExists.isTrue &&
                  Globals.offlineStream.isOffline) ||
              (!Globals.offlineStream.isOffline)) {
            var item = MediaItem(
              id: file.path,
              album: courseModel.name,
              title: fileModel.alt,
              artist: "نوآموز",
            );

            // Globals.audioHandler?.playMediaItem(item);

            AudioController controller = Get.find();
            controller.refresh();

            controller.file = fileModel;
            controller.course = courseModel;

            print('item.title');
            print(item.title);
            print(fileModel.fileExists);
            if (controller.currentUrl.value != fileModel.path &&
                controller.audioPlayer.playing) {
              await Globals.audioHandler?.stop();
              // await controller.audioPlayer.setAudioSource(
              //   fileModel.fileExists.isTrue
              //       ? AudioSource.file(file.path)
              //       : AudioSource.uri(
              //           Uri.parse(
              //             fileModel.path,
              //           ),
              //         ),
              // );
            }
            controller.isPlaying.value = false;

            print(file.path);
            print(File(file.path).existsSync());
            print(fileModel.path);
            print('files');
            controller.positionInSeconds.value = 0;
            int? seconds = await StorageUtils.lastPosition(
              fileModel.path,
            );
            print('controller.currentUrl.value');
            print(controller.currentUrl.value);
            print(file.path);
            if (controller.audioPlayer.duration is! Duration ||
                controller.currentUrl.value.split('/').last !=
                    file.path.split('/').last) {
              await Globals.audioHandler?.init(item);
            }
            if (seconds is int && seconds > 0) {
              if (seconds < controller.audioPlayer.duration!.inSeconds) {
                await controller.audioPlayer.seek(
                  Duration(seconds: seconds),
                );
                controller.positionInSeconds.value = seconds;
              } else {
                controller.positionInSeconds.value = 0;
                await controller.audioPlayer.seek(
                  Duration(seconds: 0),
                );
              }
            }
            await ScreenProtector.protectDataLeakageOn();
            await ScreenProtector.preventScreenshotOn();
            await Get.dialog(
              AudioScreen(
                controller: controller,
              ),
            );
            controller.currentUrl.value = file.path;
            print(controller.audioPlayer.position.inSeconds);
            await StorageUtils.savePosition(
              fileModel.path,
              controller.audioPlayer.position.inSeconds,
            );
            ScreenProtector.protectDataLeakageOff();
            ScreenProtector.preventScreenshotOff();
          } else {
            ViewUtils.showErrorDialog(
              "فایل به درستی باز نشد",
            );
          }
          //
          // Get.to(
          //   () => VideoPlayerScreen(
          //     path: file.path,
          //     isMusic: true,
          //     musicItem: item,
          //     title: fileModel.alt,
          //   ),
          // );
          break;
      }
    } else {
      ViewUtils.showErrorDialog(
        "متاسفانه فایل دانلود نشد، دوباره تلاش کنید",
      );
    }
  }
}

class DownloadDialog extends StatelessWidget {
  final DownloadController downloadController = Get.find();

  DownloadDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: ColorUtils.white,
        title: Text(
          'در حال دانلود...',
          style: TextStyle(
            color: ColorUtils.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Container(
          height: 150,
          child: Center(
            child: ValueListenableBuilder(
                valueListenable: downloadController.downloadProgressNotifier,
                builder: (context, value, snapshot) {
                  return CircularPercentIndicator(
                    radius: 50.0,
                    lineWidth: 10.0,
                    // animation: true,
                    percent:
                        downloadController.downloadProgressNotifier.value / 100,
                    center: Text(
                      "${downloadController.downloadProgressNotifier.value}%",
                      style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    backgroundColor: Colors.grey.shade300,
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: ColorUtils.orange,
                  );
                }),
          ),
        ));
  }
}
