import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:noamooz/Globals/Globals.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:video_player/video_player.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
class VideoPlayerScreen extends StatefulWidget {
  final String path;
  final String title;
  final bool isMusic;
  final MediaItem? musicItem;

  const VideoPlayerScreen({
    Key? key,
    required this.path,
    required this.title,
    required this.isMusic,
    this.musicItem,
  }) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  Chewie? playerWidget;

  VideoPlayerController? videoPlayerController;

  ChewieController? chewieController;

  @override
  void initState() {
    WakelockPlus.enable();

    init();
    super.initState();
  }

  @override
  void dispose() {
    WakelockPlus.disable();

    videoPlayerController?.dispose();
    chewieController?.dispose();
    ScreenProtector.protectDataLeakageOff();
    ScreenProtector.preventScreenshotOff();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorUtils.white,
          elevation: 0,
          foregroundColor: ColorUtils.black,
          centerTitle: true,
          title: Text(
            widget.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: ColorUtils.white,
        body: playerWidget ??
            const Center(
              child: CircularProgressIndicator(),
            ),
      ),
    );
  }

  void init() async {
    await ScreenProtector.protectDataLeakageOn();
    await ScreenProtector.preventScreenshotOn()  ;

    videoPlayerController = VideoPlayerController.file(
      File(widget.path),
    );

    await videoPlayerController?.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController!,
      autoPlay: false,
      showOptions: true,
      looping: true,
      optionsTranslation: OptionsTranslation(
        playbackSpeedButtonText: "سرعت پخش",
        cancelButtonText: "ادامه تماشا",
      ),
    );

    playerWidget = Chewie(
      controller: chewieController!,
    );

    setState(() {});
  }
}
