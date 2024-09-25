import 'dart:io';
import 'dart:isolate';

import 'package:better_open_file/better_open_file.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ionicons/ionicons.dart';
import 'package:noamooz/Controllers/Forum/single_forum_controller.dart';
import 'package:noamooz/Models/Forums/forum_message_model.dart';
import 'package:noamooz/Plugins/voice/src/voice_message.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/logic_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Views/Forum/Widgets/view_photo_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../Plugins/get/get.dart';

class ChatBubble extends StatefulWidget {
  ChatBubble({
    super.key,
    required this.isCurrentUser,
    required this.message,
    this.replyMessage,
    required this.scrollController,
    this.replyIndex = -1,
  });

  final ScrollController scrollController;
  final bool isCurrentUser;
  final int replyIndex;
  final ForumMessage message;
  final ForumMessage? replyMessage;

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  final RxInt downloadId = 0.obs;
  final RxInt downloadProgress = 0.obs;
  // final Rx<DownloadTaskStatus> downloadStatus =
  //     DownloadTaskStatus.undefined.obs;
  final ReceivePort _port = ReceivePort();
  ValueNotifier downloadProgressNotifier = ValueNotifier(0);

  // @override
  // void dispose() {
  //   super.dispose();
  //   IsolateNameServer.removePortNameMapping('downloader_send_port');
  // }

  // @pragma('vm:entry-point')
  // static void downloadCallback(String id, int status, int progress) {
  //   final SendPort send =
  //       IsolateNameServer.lookupPortByName('downloader_send_port')!;
  //   send.send([id, status, progress]);
  // }

  void _showPopupMenu(Offset offset, String text) async {
    double left = offset.dx;
    if (left < 50) {
      left = 50;
    }
    double top = offset.dy;
    var value = await showMenu(
      context: context,
      position: widget.isCurrentUser
          ? RelativeRect.fromLTRB(
              Get.width / 8,
              top - 70,
              0,
              left,
            )
          : RelativeRect.fromLTRB(
              Get.width / 8,
              top - 70,
              left,
              0,
            ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35),
      ),
      constraints: BoxConstraints(
        minWidth: 2.0 * 24.0,
        maxWidth: MediaQuery.of(context).size.width / 3,
      ),
      color: ColorUtils.white,
      items: [
        PopupMenuItem<String>(
          value: 'Copy',
          height: 36,
          child: Text(
            'کپی',
            style: TextStyle(
              color: ColorUtils.textBlack,
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'Reply',
          height: 36,
          child: Text(
            'پاسخ',
            style: TextStyle(
              color: ColorUtils.textBlack,
            ),
          ),
        ),
        if (text.isURL)
          PopupMenuItem<String>(
            value: 'Link',
            height: 36,
            child: Text(
              'باز کردن لینک',
              style: TextStyle(
                color: ColorUtils.textBlack,
              ),
            ),
          ),
      ],
      elevation: 2.0,
    );
    if (value == "Copy") {
      Clipboard.setData(ClipboardData(text: text));
      ViewUtils.showSuccessDialog(
        "کپی شد.",
        time: 1,
      );
    } else if (value == "Link") {
      launchUrlString(
        text,
        mode: LaunchMode.externalApplication,
      );
    } else if (value == "Reply") {
      final SingleForumController controller = Get.find();
      controller.replyMessage = widget.message;
      controller.update(['reply']);
    }
  }

  void download(String url) async {
    bool dirDownloadExists = true;
    var externalDir;
    if (Platform.isIOS) {
      externalDir = await getDownloadsDirectory();
    } else {
      externalDir = "/storage/emulated/0/Download/";

      dirDownloadExists = await Directory(externalDir).exists();
      if (dirDownloadExists) {
        externalDir = "/storage/emulated/0/Download/";
      } else {
        externalDir = "/storage/emulated/0/Downloads/";
      }
    }
    EasyLoading.show(status: "در حال دانلود...");
    // final id = await FlutterDownloader.enqueue(
    //   url: url,
    //   savedDir: externalDir,
    //   showNotification: true,
    //   fileName: widget.message.content['name'],
    //   openFileFromNotification: true,
    // );

    Future.delayed(const Duration(milliseconds: 500), () {
      widget.message.content['isLocal'] = true;
      widget.message.content['path'] =
          "$externalDir${widget.message.content['name']}";
      // downloadStatus.value = DownloadTaskStatus.complete;
      OpenFile.open(widget.message.content['path']);
      print('object');
      ViewUtils.showSuccessDialog(
        "فایل با موفقیت در پوشه دانلود های شما ذخیره شد.",
      );
      EasyLoading.dismiss();
    });
  }

  @override
  void initState() {
    checkFile();
    // IsolateNameServer.registerPortWithName(
    //     _port.sendPort, 'downloader_send_port');
    // _port.listen((dynamic data) {
    //   // downloadId.value = int.tryParse(data[0].toString()) ?? 0;
    //   // downloadStatus.value = data[1];
    //   // downloadProgress.value = int.tryParse(data[2].toString()) ?? 0;
    //   // print(downloadProgress.value);
    //   // print('downloadStatus.value == DownloadTaskStatus.paused');
    //   // print(downloadStatus.value == DownloadTaskStatus.running);
    //   // print(downloadStatus.value);
    // });
    //
    // FlutterDownloader.registerCallback(downloadCallback);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // asymmetric padding
      padding: EdgeInsets.fromLTRB(
        widget.isCurrentUser ? 64.0 : 16.0,
        4,
        widget.isCurrentUser ? 16.0 : 64.0,
        4,
      ),
      child: Align(
        // align the child within the container
        alignment:
            widget.isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: !widget.isCurrentUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: widget.isCurrentUser
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(25.0),
                            bottomRight: Radius.circular(25.0),
                            bottomLeft: Radius.circular(25.0),
                            topRight: Radius.circular(4),
                          )
                        : const BorderRadius.only(
                            topRight: Radius.circular(25.0),
                            bottomRight: Radius.circular(25.0),
                            bottomLeft: Radius.circular(25.0),
                            topLeft: Radius.circular(4.0),
                          ),
                    child: Container(
                      // chat bubble decoration
                      decoration: BoxDecoration(
                        color: widget.isCurrentUser
                            ? ColorUtils.gray.withOpacity(0.1)
                            : ColorUtils.black,
                      ),
                      child: Column(
                        children: [
                          if (!widget.isCurrentUser) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    widget.message.user.name,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.zero,
                              child: Divider(
                                color: ColorUtils.textWhite,
                                height: 1,
                                thickness: 1,
                              ),
                            ),
                          ],
                          if (widget.message.reply > 0) ...[
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (widget.replyMessage != null) {
                                        RenderBox? renderBox = widget
                                            .replyMessage!
                                            .globalKey
                                            .currentContext
                                            ?.findRenderObject() as RenderBox;
                                        final position = renderBox
                                            .localToGlobal(Offset.zero);
                                        final parentHeight =
                                            MediaQuery.of(context).size.height;
                                        final scrollOffset = position.dy +
                                            parentHeight +
                                            MediaQuery.of(context).padding.top +
                                            Get.height / 6;
                                        widget.scrollController.animateTo(
                                            scrollOffset,
                                            duration:
                                                Duration(milliseconds: 300),
                                            curve: Curves.easeInOut);
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: widget.isCurrentUser
                                            ? ColorUtils.gray.shade600
                                            : ColorUtils.orange.shade600,
                                      ),
                                      height: 35,
                                      padding: const EdgeInsets.all(4),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          right: !widget.isCurrentUser ? 8 : 0,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 20,
                                              width: 2.5,
                                              decoration: BoxDecoration(
                                                color: !widget.isCurrentUser
                                                    ? ColorUtils.gray.shade600
                                                    : ColorUtils.textBlack,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            if (widget.replyMessage ==
                                                null) ...[
                                              Expanded(
                                                child: Text(
                                                  "پیام حذف شده",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: widget.isCurrentUser
                                                        ? null
                                                        : ColorUtils.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                            if (widget.replyMessage !=
                                                null) ...[
                                              Expanded(
                                                child: Text(
                                                  widget.replyMessage!
                                                      .previewText(),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: widget.isCurrentUser
                                                        ? null
                                                        : ColorUtils.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          buildBody(),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: !widget.isCurrentUser
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.end,
                        children: [
                          Text(
                            DateTime.fromMillisecondsSinceEpoch(
                              widget.message.date * 1000,
                            ).chatTime(),
                            style: TextStyle(
                              fontSize: 12,
                              letterSpacing: 1.2,
                              color: ColorUtils.textBlack.withOpacity(0.7),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            if (!widget.isCurrentUser) ...[
              SizedBox(
                width: 8,
              ),
              Column(
                children: [
                  SizedBox(
                    width: 35,
                    height: 35,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(500),
                      child: CachedNetworkImage(
                        imageUrl: widget.message.user.image,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildBody() {
    switch (widget.message.type) {
      case 'image':
        return Stack(
          alignment: widget.isCurrentUser
              ? Alignment.bottomLeft
              : Alignment.bottomRight,
          children: [
            buildImage(),
            if (widget.message.type == 'image') ...[
              Positioned(
                bottom: 12,
                right: widget.isCurrentUser ? null : 12,
                left: !widget.isCurrentUser ? null : 12,
                child: GestureDetector(
                  onTap: () {
                    download(widget.message.content['path']);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorUtils.red,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Ionicons.download_outline,
                      size: 18,
                      color: ColorUtils.white,
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      case 'audio':
        return buildAudio();
      case 'file':
        return buildFile();
      case "text":
        return buildText();
    }
    return buildType();
  }

  Widget buildText() {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTapDown: (TapDownDetails details) {
          _showPopupMenu(
            details.globalPosition,
            widget.message.content['text'] ?? "",
          );
        },
        borderRadius: BorderRadius.circular(10.0),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SelectableText(
            widget.message.content['text'] ?? "",
            style: TextStyle(
              color: widget.isCurrentUser
                  ? ColorUtils.textBlack
                  : ColorUtils.white,
              decoration: widget.message.content['text'].toString().isURL
                  ? TextDecoration.underline
                  : TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildType() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        widget.message.type,
        style: TextStyle(
          color: widget.isCurrentUser ? ColorUtils.orange : ColorUtils.white,
        ),
      ),
    );
  }

  Widget buildImage() {
    return Padding(
      padding: EdgeInsets.all(widget.message.type == 'audio' ? 0 : 8),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: Get.height / 6,
        ),
        child: GestureDetector(
          onTap: () {
            Get.dialog(
              ViewPhotoWidget(
                message: widget.message,
                download: download,
              ),
              barrierColor: Colors.black.withOpacity(0.5),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: widget.message.content['isLocal'] == true
                ? Image.file(
                    File(widget.message.content['path']),
                  )
                : CachedNetworkImage(
                    imageUrl: widget.message.content['path'] ?? "",
                    errorWidget: (context, url, error) => Icon(
                      Icons.error,
                      color: ColorUtils.red,
                    ),
                    imageBuilder: (_, ImageProvider provider) {
                      return SizedBox(
                        height: Get.height / 6,
                        child: Image(
                          image: provider,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SizedBox(
                        height: Get.height / 6,
                        width: Get.height / 6,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: ColorUtils.gray,
                            strokeWidth: 1,
                            value: downloadProgress.progress,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildInput() {
    Widget child = Container();
    // if (chat.input is File) {
    //   if (chat.type == 'image') {
    //     child = Image.file(
    //       chat.input,
    //     );
    //   } else if (chat.type == 'audio') {
    //     child = audioMessage(
    //       audioFile: chat.input,
    //       isLocale: true,
    //       played: false,
    //       me: true,
    //       onPlay: () {},
    //     );
    //   }
    // } else if (chat.input is String) {
    //   if (chat.type == 'image') {
    //     child = Image.network(
    //       chat.input,
    //     );
    //   } else if (chat.type == 'audio') {
    //     child = audioMessage(
    //       audioSrc: chat.input,
    //       isLocale: false,
    //       played: false,
    //       me: true,
    //       onPlay: () {},
    //     );
    //   }
    // }
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: child,
    );
  }

  Widget buildAudio() {
    return VoiceMessage(
      audioFile: widget.message.content['isLocal'] == true
          ? File(widget.message.content['path'])
          : null,
      audioSrc: widget.message.content['isLocal'] == true
          ? null
          : widget.message.content['path'],
      isLocale: widget.message.content['isLocal'] == true,
      played: false,
      me: true,
      onPlay: () {
        print('started playing');
      },
    );
  }

  Widget buildFile() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () async {
          print(widget.message.content['isLocal']);
          if (widget.message.content['isLocal'] == true) {
            OpenFile.open(widget.message.content['path']);
          } else {
            download(widget.message.content['path']);
          }
        },
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 75,
                  height: 75,
                  child: Icon(
                    Icons.file_open,
                    color: widget.message.isMe
                        ? ColorUtils.black
                        : ColorUtils.white,
                    size: 75,
                  ),
                ),
                Text(
                  widget.message.content['type'] ?? "",
                  style: TextStyle(
                    color: !widget.message.isMe
                        ? ColorUtils.black
                        : ColorUtils.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'sans-serif',
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 4,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.message.content['name'] ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: widget.message.isMe
                                ? ColorUtils.textBlack
                                : ColorUtils.textWhite,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    widget.message.content['size'] ?? "",
                    style: TextStyle(
                      color: widget.message.isMe
                          ? ColorUtils.textBlack
                          : ColorUtils.textWhite,
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

  void checkFile() async {
    if (widget.message.content.keys.contains('path') &&
        widget.message.content.keys.contains('name')) {
      final externalDir = await getExternalStorageDirectory();
      print("${externalDir!.path}/${widget.message.content['name']}");
      Future.delayed(const Duration(milliseconds: 50), () {
        print('test');
        print(File("${externalDir.path}/${widget.message.content['name']}")
            .existsSync());
        if (File("${externalDir.path}/${widget.message.content['name']}")
            .existsSync()) {
          print('i am here');
          widget.message.content['path'] =
              "${externalDir.path}/${widget.message.content['name']}";
          widget.message.content['isLocal'] = true;
          setState(() {});
        }
      });
    }
  }
}
