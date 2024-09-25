import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:noamooz/Globals/Globals.dart';
import 'package:noamooz/Models/Courses/course_model.dart';
import 'package:noamooz/Models/Forums/forum_message_model.dart';
import 'package:noamooz/Models/Forums/forum_model.dart';
import 'package:noamooz/Plugins/get/get.dart';
import 'package:noamooz/Utils/Api/project_request_utils.dart';
import 'package:noamooz/Utils/logic_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Widgets/pdf_player_screen.dart';
import 'package:noamooz/Widgets/video_player_screen.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:photo_manager/photo_manager.dart';
import 'package:record/record.dart';

import '../../Models/file_model.dart';

class SingleForumController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isImagesShown = false.obs;
  final RxBool showScrollButton = false.obs;
  final RxBool showSendButton = false.obs;
  final RxBool isRecording = false.obs;
  final RxBool isRecorded = false.obs;
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  late ForumModel forum;
  DateTime? voiceTime;
  String voiceShowTime = "";
  int forumId = 0;
  ForumMessage? replyMessage;
  String voicePath = "";
  final AudioRecorder record = AudioRecorder();
  Timer? _timer;
  final FocusNode messageFocusNode = FocusNode();
  final ImagePicker picker = ImagePicker();

  // final List<AssetEntity> media = [];
  final RxBool isMultipleSelect = false.obs;
  final RxList<int> currentItems = List<int>.generate(0, (index) => index).obs;
  final RxInt currentIndex = 0.obs;
  List<CameraDescription> cameras = [];
  CameraController? cameraController;
  List<ForumMessage> messages = [];

  void fetchForum() async {
    isLoading.value = true;
    ApiResult result = await RequestsUtil.instance.forum.get(forumId);
    if (result.isDone) {
      forum = ForumModel.fromJson(result.data['forum']);
      cameras = await availableCameras();
      messages = List.from(result.data['messages'])
          .map((e) => ForumMessage.fromJson(e))
          .toList();
      for (var element in forum.files) {
        await element.checkFileExists();
      }
      isLoading.value = false;
    } else {
      Get.back();
      ViewUtils.showErrorDialog(result.data['message'].toString());
    }
  }

  void pickImage(ImageSource source) async {
    isImagesShown.value = false;
    XFile? image = await picker.pickImage(
      source: source,
    );
    if (image is XFile) {
      sendImage(
        "",
        File(image.path),
      );
    }
  }

  void sendImage(
    String caption,
    File image,
  ) async {
    EasyLoading.show();
    messages.add(
      ForumMessage(
        reply: replyMessage?.id ?? 0,
        id: 0,
        user: User(
          id: Globals.userStream.user!.id,
          image: Globals.userStream.user!.avatar,
          name:
              "${Globals.userStream.user!.firstName} ${Globals.userStream.user!.lastName}",
        ),
        content: {
          'path': image.path,
          'isLocal': true,
        },
        type: 'image',
        isMe: true,
        date: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      ),
    );

    isLoading.value = true;
    isLoading.value = false;
    Future.delayed(const Duration(milliseconds: 50), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 150),
        curve: Curves.ease,
        // duration: const Duration(milliseconds: 150),
        // curve: Curves.ease,
      );
    });
    ApiResult result = await RequestsUtil.instance.forum.sendMessage(
      content: {
        'file': image,
      },
      reply: messages.last.reply,
      forumId: forum.id,
      type: "image",
    );
    if (result.isDone) {
      EasyLoading.dismiss();

      messageController.clear();
    } else {
      messages.removeLast();
      isLoading.value = true;
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }

  void sendFile() async {
    FilePickerResult? res =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (res != null) {
      for (var f in res.files) {
        await sendSingleFile(File(f.path!));
      }
    } else {
      // User canceled the picker
    }
  }

  Future<void> sendSingleFile(File file) async {
    EasyLoading.show();
    String size = "0 B";
    int bytes = await file.length();
    if (bytes <= 0) {
      size = "0 B";
    } else {
      const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
      var i = (log(bytes) / log(1024)).floor();
      size = '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
    }
    messages.add(
      ForumMessage(
        id: 0,
        user: User(
          id: Globals.userStream.user!.id,
          image: Globals.userStream.user!.avatar,
          name:
              "${Globals.userStream.user!.firstName} ${Globals.userStream.user!.lastName}",
        ),
        content: {
          'type': file.path.split('.').last,
          'name': file.path.split('/').last.split('.').first,
          'size': size,
          'path': file.path,
          'isLocal': true,
        },
        reply: replyMessage?.id ?? 0,
        type: 'file',
        isMe: true,
        date: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      ),
    );

    isLoading.value = true;
    isLoading.value = false;
    Future.delayed(const Duration(milliseconds: 50), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 150),
        curve: Curves.ease,
        // duration: const Duration(milliseconds: 150),
        // curve: Curves.ease,
      );
    });
    ApiResult result = await RequestsUtil.instance.forum.sendMessage(
      content: {
        'file': file,
      },
      reply: messages.last.reply,
      forumId: forum.id,
      type: "file",
    );
    if (result.isDone) {
      EasyLoading.dismiss();

      messageController.clear();
    } else {
      messages.removeLast();
      isLoading.value = true;
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }

  void sendVoice() async {
    EasyLoading.show();
    File file = File(voicePath);
    messages.add(
      ForumMessage(
        reply: replyMessage?.id ?? 0,
        id: 0,
        user: User(
          id: Globals.userStream.user!.id,
          image: Globals.userStream.user!.avatar,
          name:
              "${Globals.userStream.user!.firstName} ${Globals.userStream.user!.lastName}",
        ),
        content: {
          'path': voicePath,
          'name': file.path.split('/').last,
          'size': file.lengthSync().toString(),
          'duration': 0,
          'isLocal': true,
        },
        type: 'audio',
        isMe: true,
        date: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      ),
    );

    isLoading.value = true;
    isLoading.value = false;
    Future.delayed(const Duration(milliseconds: 50), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 150),
        curve: Curves.ease,
        // duration: const Duration(milliseconds: 150),
        // curve: Curves.ease,
      );
    });
    ApiResult result = await RequestsUtil.instance.forum.sendMessage(
      content: {
        'file': File(voicePath),
      },
      reply: messages.last.reply,
      forumId: forum.id,
      type: "audio",
    );
    if (result.isDone) {
      EasyLoading.dismiss();
      if (result.data['type'] == 'audio') {
        messages.last.content = result.data['content'];
        isLoading.value = true;
        isLoading.value = false;
      }
      isRecorded.value = false;
      isRecording.value = false;
      messageController.clear();
    } else {
      messages.removeLast();
      isLoading.value = true;
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }

  void sendMessage() async {
    if (isRecorded.isTrue) {
      sendVoice();
    } else if (messageController.text.trim().isNotEmpty) {
      messages.add(
        ForumMessage(
          id: 0,
          content: {'text': messageController.text},
          type: 'text',
          user: User(
            id: Globals.userStream.user!.id,
            image: Globals.userStream.user!.avatar,
            name:
                "${Globals.userStream.user!.firstName} ${Globals.userStream.user!.lastName}",
          ),
          reply: replyMessage?.id ?? 0,
          isMe: true,
          date: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        ),
      );
      messageController.clear();
      showSendButton.value = false;
      isLoading.value = true;
      isLoading.value = false;
      Future.delayed(const Duration(milliseconds: 50), () {
        if (scrollController.positions.isNotEmpty) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 150),
            curve: Curves.ease,
            // duration: const Duration(milliseconds: 150),
            // curve: Curves.ease,
          );
        }
      });
      ApiResult result = await RequestsUtil.instance.forum.sendMessage(
        content: messages.last.content,
        reply: messages.last.reply,
        forumId: forum.id,
        type: 'text',
      );
      replyMessage = null;
      update(['reply']);
      if (result.isDone) {
        messages.last.id = result.data['id'] ?? 0;
      } else {
        messages.removeLast();
        isLoading.value = true;
        isLoading.value = false;
      }
    }
  }

  @override
  void onInit() {
    forumId = int.tryParse(Get.currentRoute.split('/').last) ?? 0;
    fetchForum();
    super.onInit();
  }

  void start() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    if (await record.hasPermission()) {
      // Start recording
      print('start');
      if (!(await record.isRecording())) {
        voicePath = "$tempPath/voice_${DateTime.now()}.m4a";
        await record.start(
          const RecordConfig(),
          path: voicePath,
        );
        isRecording.value = true;
        voiceTime = DateTime.now();
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          voiceShowTime = LogicUtils.durationToMinHour(
            DateTime.now().difference(voiceTime!),
          );
          update(['voice_timer']);
        });
      } else {
        await record.stop();
        isRecording.value = false;
      }
    }
  }

  void stop() async {
    _timer?.cancel();
    if (await record.isRecording()) {
      await record.stop();
      voiceShowTime = LogicUtils.durationToMinHour(
        DateTime.now().difference(voiceTime!),
      );

      isRecording.value = false;
      isRecorded.value = true;
    }
  }

  void openFile(FileModel fileModel) async {
    Directory dir = await getApplicationDocumentsDirectory();
    String fullPath = "${dir.path}/${fileModel.path.split('/').last}";
    File file = File(fullPath);
    if (!file.existsSync()) {
      EasyLoading.show(status: "در حال دانلود...");
      final http.Response responseData = await http.get(
        Uri.parse(fileModel.path),
      );
      Uint8List uint8list = responseData.bodyBytes;
      var buffer = uint8list.buffer;
      ByteData byteData = ByteData.view(buffer);
      file = await File(
        fullPath,
      ).writeAsBytes(
        buffer.asUint8List(
          byteData.offsetInBytes,
          byteData.lengthInBytes,
        ),
      );
      EasyLoading.dismiss();
    }
    if (file.existsSync()) {
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
          var item = MediaItem(
            id: file.path,
            album: forum.course!.name,
            title: fileModel.alt,
            artist: "نوآموز",
          );
          // Globals.audioHandler?.playMediaItem(item);
          // Globals.audioHandler?.play();

          Get.to(
            () => VideoPlayerScreen(
              path: file.path,
              isMusic: true,
              musicItem: item,
              title: fileModel.alt,
            ),
          );
          break;
      }
    } else {
      ViewUtils.showErrorDialog("متاسفانه فایل دانلود نشد، دوباره تلاش کنید");
    }
  }
}
