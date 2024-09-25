import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:audio_service/audio_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:noamooz/Controllers/Audio/audio_controller.dart';
import 'package:noamooz/Globals/Globals.dart';
import 'package:noamooz/Plugins/refresher/pull_to_refresh.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/routing_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Views/Splash/splash_screen.dart';
import 'package:noamooz/Widgets/download_dialog.dart';

import 'Plugins/get/get.dart';

class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final player = AudioPlayer();
  @override
  Future<void> onNotificationDeleted() async {
    print('deleted');
    await player.stop();
    await player.dispose();
  }

  Future<void> init(item) async {
    print('INIT');
    await player.stop();
    // player.playbackEventStream.map(_transformEvent).pipe(playbackState);
    // ... and also the current media item via mediaItem.
    //
    // Load the player.
    if (File(item.id).existsSync()) {
      await player.setAudioSource(AudioSource.file(item.id));
    } else {
      await player.setAudioSource(AudioSource.uri(Uri.parse(item.id)));
    }
    mediaItem.add(item);
  }

  /// Initialise our audio handler.
  MyAudioHandler([MediaItem? item]) {
    // what state to display, here we set up our audio handler to broadcast all
    // playback state changes as they happen via playbackState...
    if (item != null) {
      player.playbackEventStream.map(_transformEvent).pipe(playbackState);
      // ... and also the current media item via mediaItem.
      mediaItem.add(item);

      // Load the player.
      player.setAudioSource(AudioSource.uri(Uri.parse(item.id)));
    }
  }

  // In this simple example, we handle only 4 actions: play, pause, seek and
  // stop. Any button press from the Flutter UI, notification, lock screen or
  // headset will be routed through to these 4 methods so that you can handle
  // your audio playback logic in one place.

  @override
  Future<void> play() => player.play();

  @override
  Future<void> pause() => player.pause();

  @override
  Future<void> seek(Duration position) => player.seek(position);

  @override
  Future<void> stop() {
    // player.playbackEventStream.map(_transformEvent).pipe(playbackState);

    return player.stop();
  }

  /// Transform a just_audio event into an audio_service state.
  ///
  /// This method is used from the constructor. Every event received from the
  /// just_audio player will be transformed into an audio_service state so that
  /// it can be broadcast to audio_service clients.
  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[player.processingState]!,
      playing: player.playing,
      updatePosition: player.position,
      bufferedPosition: player.bufferedPosition,
      speed: player.speed,
      queueIndex: event.currentIndex,
    );
  }
}

Future<void> initUniLinks() async {
  final appLinks = AppLinks(); // AppLinks is singleton

  appLinks.uriLinkStream.listen((Uri uri) {
    String link = uri.path;
    if (link.contains('payment') == true) {
      if (link.contains('fail') == true) {
        ViewUtils.showErrorDialog("پرداخت با خطا مواجه شد!");
      } else {
        ViewUtils.showSuccessDialog(
        "خرید شما با موفقیت انجام شد",
      );
      }

    }
  }, onError: (err) {});
}

class Handler extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print(state);
    print(Globals.audioHandler?.player);
    if (state == AppLifecycleState.detached) {
      await Globals.audioHandler?.player.stop();
      await Globals.audioHandler?.player.dispose();
      exit(0);
    }
  }
}

void main() async {
  Globals.audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.lexaplus.noamooz.channel.audio',
        androidNotificationChannelName: 'توآموز',
        androidNotificationOngoing: false,
        androidStopForegroundOnPause: true),
  );
  await GetStorage.init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyAkoga5qcDELS8Mp34T3YdTeRgz9bjqNsA',
      appId: '1:622957675894:android:1c2be2f23c7caa80792657',
      messagingSenderId: '622957675894',
      projectId: 'noamooz',
    ),
  ).whenComplete(() => print('FIREBASE INITIALIZED================>'));
  // await FlutterDownloader.initialize(
  //     debug: true,
  //     optional: set to false to disable printing logs to console (default: true)
  // ignoreSsl:
  //     true // option: set to false to disable working with http links (default: false)
  // );
  // Globals.toggleDarkMode(false);

  if (!kIsWeb) {
    initUniLinks();
  }

  Get.put(
    AudioController(),
  );
  Get.put(
    DownloadController(),
  );

  runApp(
    RefreshConfiguration(
      footerTriggerDistance: 10,
      child: StreamBuilder(
        stream: Globals.darkModeStream.getStream,
        builder: (context, snapshot) {
          return GetMaterialApp(
            textDirection: TextDirection.rtl,
            debugShowCheckedModeBanner: false,
            defaultTransition: Transition.cupertino,
            theme: ThemeData(
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: ColorUtils.orange,
              ),
              disabledColor: ColorUtils.gray,
              tabBarTheme: TabBarTheme(
                labelStyle: TextStyle(
                  color: ColorUtils.black,
                  fontFamily: 'iranSans',
                  fontWeight: FontWeight.bold,
                ),
                labelColor: ColorUtils.black,
                unselectedLabelStyle: TextStyle(
                  color: ColorUtils.black,
                  fontFamily: 'iranSans',
                ),
              ),
              cardColor: ColorUtils.black,
              textTheme: TextTheme(
                headlineMedium: TextStyle(
                  color: ColorUtils.white,
                ),
                bodyMedium: TextStyle(
                  color: ColorUtils.white,
                ),
                bodySmall: TextStyle(
                  color: ColorUtils.white,
                ),
              ),
              iconTheme: IconThemeData(
                color: ColorUtils.white,
              ),
              fontFamily: 'iranSans',
              canvasColor: ColorUtils.black,
              primaryColor: ColorUtils.orange,
              primarySwatch: ColorUtils.orange,
            ),
            getPages: [
              RoutingUtils.splash,
              RoutingUtils.main,
              RoutingUtils.login,
              RoutingUtils.profile,
              RoutingUtils.onBoarding,
              RoutingUtils.blog,
              RoutingUtils.posts,
              RoutingUtils.post,
              RoutingUtils.partnership,
              RoutingUtils.categories,
              RoutingUtils.courses,
              RoutingUtils.freeCourses,
              RoutingUtils.singleCourse,
              RoutingUtils.myCourses,
              RoutingUtils.quizzes,
              RoutingUtils.lotteries,
              RoutingUtils.lottery,
              RoutingUtils.support,
              RoutingUtils.faq,
              RoutingUtils.forums,
              RoutingUtils.forum,
              RoutingUtils.installments,
            ],
            builder: EasyLoading.init(),
            home: SplashScreen(),
          );
        },
      ),
    ),
  );
}
