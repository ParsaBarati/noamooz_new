import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:noamooz/Globals/Globals.dart';
import 'package:noamooz/Models/Courses/course_model.dart';
import 'package:noamooz/Models/file_model.dart';
import 'package:noamooz/Utils/storage_utils.dart';

import '../../Plugins/get/get.dart';

class AudioController extends GetxController {
  AudioPlayer get audioPlayer => Globals.audioHandler!.player;
  RxString currentUrl = ''.obs;

  RxBool isLoading = true.obs;
  RxBool isPlaying = false.obs;
  RxDouble volume = 1.0.obs;
  RxDouble playbackSpeed = 1.0.obs;

  FileModel? file;
  CourseModel? course;

  final RxInt positionInSeconds = 0.obs;

  StreamSubscription<Duration>? _sub;
  StreamSubscription<int?>? _sub2;

  Duration get position => Duration(seconds: positionInSeconds.value);
  StreamSubscription<FGBGType>? subscription;

  @override
  void onInit() {
    super.onInit();
    audioPlayer.setVolume(volume.value);
    audioPlayer.setSpeed(playbackSpeed.value);
    subscription = FGBGEvents.stream.listen((event) {
      if (event == FGBGType.background){
        _sub?.cancel();
      } else {
        listen();
      }
    });
  }

  void setVolume(double value) {
    volume.value = value;
    audioPlayer.setVolume(value);
  }


  @override
  void dispose() {
    Globals.audioHandler?.pause();
    Globals.audioHandler?.player.dispose();
    audioPlayer.dispose();
    _sub?.cancel();
    subscription?.cancel();
    currentUrl.value = "";
    super.dispose();
  }
  @override
  void onClose() {
    audioPlayer.dispose();
    _sub?.cancel();
    subscription?.cancel();
    currentUrl.value = "";
    super.onClose();
  }

  void setPlaybackSpeed(double value) {
    playbackSpeed.value = value;
    audioPlayer.setSpeed(value);
  }

  void playPause() async {
    if (isPlaying.value) {
      audioPlayer.pause();
      _sub?.cancel();
    } else {
      print('play');
      Globals.audioHandler?.play();
      listen();
    }
    isPlaying.toggle();
  }

  void listen() {
    _sub?.cancel();
    _sub = audioPlayer.positionStream.listen((event) async {
      print(event.inSeconds);
      if (event.inSeconds % 10 == 0) {
        await StorageUtils.savePosition(
          file!.path,
          event.inSeconds,
        );
      }
      if (event.inSeconds >= audioPlayer.duration!.inSeconds){
        playPause();
      }
      positionInSeconds.value = event.inSeconds;
    });
  }

  void seek(double value) {
    audioPlayer.seek(Duration(seconds: value.toInt()));
  }

  void rewind() {
    audioPlayer.seek(audioPlayer.position - const Duration(seconds: 10));
  }

  void fastForward() {
    audioPlayer.seek(audioPlayer.position + const Duration(seconds: 10));
  }
}
