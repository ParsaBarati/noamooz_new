import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:noamooz/Controllers/Forum/single_forum_controller.dart';
import 'package:noamooz/Globals/Globals.dart';
import 'package:noamooz/Models/Forums/forum_message_model.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/routing_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Views/Forum/Widgets/chat_bubble.dart';
import 'package:noamooz/Views/Forum/Widgets/select_image_modal.dart';
import 'package:noamooz/Widgets/my_app_bar.dart';
import 'package:noamooz/Widgets/my_drawer.dart';
// import 'package:photo_manager/photo_manager.dart';

import '../../Models/file_model.dart';
import '../../Plugins/get/get.dart';

class SingleForumScreen extends StatelessWidget {
  final SingleForumController controller = Get.put(
    SingleForumController(),
  );
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  SingleForumScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // EasyLoading.show();
        // if (Get.isRegistered<ForumController>()) {
        //   ForumController controller = Get.find();
        //   controller.fetchForums();
        // }
        // EasyLoading.dismiss();
        return true;
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Expanded(
              child: Scaffold(
                floatingActionButton: Obx(
                  () => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 150),
                    child: controller.isImagesShown.isTrue
                        ? buildPhotoPick()
                        : controller.showScrollButton.isTrue
                            ? Row(
                                children: [
                                  const SizedBox(
                                    width: 24,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      bottom: Get.height / 24,
                                      right: 0,
                                    ),
                                    child: FloatingActionButton.small(
                                      onPressed: () {
                                        controller.scrollController.animateTo(
                                          controller.scrollController.position
                                              .maxScrollExtent,
                                          duration:
                                              const Duration(milliseconds: 150),
                                          curve: Curves.ease,
                                        );
                                      },
                                      backgroundColor: ColorUtils.orange,
                                      child: const Icon(
                                        Ionicons.chevron_down,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                  ),
                ),
                body: buildBody(),
                drawer: MyDrawer(),
                resizeToAvoidBottomInset: true,
                backgroundColor: ColorUtils.bgColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAppBar() {
    return Obx(
      () => MyAppBar(
        globalKey: globalKey,
        inner: true,
        title: controller.isLoading.isTrue
            ? "در حال بارگذاری"
            : controller.forum.name,
      ),
    );
  }

  Widget buildFile(FileModel fileModel) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: ColorUtils.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () => controller.openFile(fileModel),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            fileModel.alt.trim().isEmpty
                                ? "بدون نام"
                                : fileModel.alt,
                            style: TextStyle(
                              color: ColorUtils.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Text(
                          "نوع فایل: ",
                          style: TextStyle(
                            color: ColorUtils.textColor,
                            fontSize: 10,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "${ViewUtils.getFileType(
                              fileModel.path.split('.').last,
                            )} (${fileModel.path.split('.').last})",
                            style: TextStyle(
                              color: ColorUtils.black,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              controller.forum.course?.hasBought == true
                  ? Obx(
                      () => Icon(
                        fileModel.fileExists.isTrue
                            ? Iconsax.clock
                            : Iconsax.document_download,
                        color: ColorUtils.textColor,
                        size: 20,
                      ),
                    )
                  : Icon(
                      Iconsax.lock,
                      color: ColorUtils.textColor,
                      size: 20,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        buildAppBar(),
        Expanded(
          child: Obx(
            () => AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: controller.isLoading.isTrue
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (controller.forum.file is FileModel) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: controller.forum.file!.path,
                                width: Get.width / 1,
                                height: Get.height / 6,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                        ],
                        Container(
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: ColorUtils.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      controller.forum.name,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: ColorUtils.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 15,
                                        child: Divider(
                                          color: ColorUtils.textBlack
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        controller.forum.description.trim(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: ColorUtils.textBlack,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (controller.forum.course != null) ...[
                          Container(
                            width: Get.width,
                            decoration: BoxDecoration(
                              color: ColorUtils.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(500),
                                    child: CachedNetworkImage(
                                      imageUrl: controller.forum.course!.icon,
                                      width: 30,
                                      height: 30,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "دوره: ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: ColorUtils.textBlack,
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.toNamed(
                                          RoutingUtils.singleCourseRoute(
                                            controller.forum.course?.id ?? 0,
                                          ),
                                        );
                                      },
                                      child: Text(
                                        controller.forum.course?.name ?? "",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.zero,
                            controller: controller.scrollController,
                            child: Column(
                              children: [
                                Column(
                                  children: controller.forum.files
                                      .map((e) => buildFile(e))
                                      .toList(),
                                ),
                                Column(
                                  children: controller.messages
                                      .map((e) => buildMessage(e))
                                      .toList(),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                              ],
                            ),
                          ),
                        ),
                        buildInput()
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildOperator() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorUtils.gray,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: ColorUtils.black.withOpacity(0.15),
            spreadRadius: 3,
            offset: const Offset(0, 5),
            blurRadius: 12,
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  color: ColorUtils.orange,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                "نام خدمات: ",
                style: TextStyle(
                  color: ColorUtils.textBlack,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 6,
          ),
          Row(
            children: [
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  color: ColorUtils.orange,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                "شماره پرونده: ",
                style: TextStyle(
                  color: ColorUtils.textBlack,
                  fontSize: 14,
                ),
              ),
              Text(
                controller.forum.id.toString(),
                style: TextStyle(
                  color: ColorUtils.textBlack,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 6,
          ),
        ],
      ),
    );
  }

  Widget buildMessage(ForumMessage message) {
    return ChatBubble(
      key: message.globalKey,
      replyIndex: controller.messages.indexOf(message),
      scrollController: controller.scrollController,
      isCurrentUser: message.isMe,
      message: message,
      replyMessage: message.reply > 0
          ? controller.messages.any((element) => element.id == message.reply)
              ? controller.messages.singleWhere((element) {
                  return element.id == message.reply;
                })
              : null
          : null,
    );
  }

  Widget buildInput() {
    return GetBuilder(
        id: 'reply',
        init: controller,
        builder: (context) {
          return Column(
            children: [
              if (controller.replyMessage is ForumMessage) ...[
                const SizedBox(
                  height: 12,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: ColorUtils.white,
                    border: Border(
                      bottom: BorderSide(
                        color: ColorUtils.gray.withOpacity(0.2),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          controller.replyMessage = null;
                          controller.update(['reply']);
                        },
                        child: Icon(
                          Icons.close,
                          color: ColorUtils.orange,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Text(
                          controller.replyMessage!.previewText(),
                          style: TextStyle(
                            color: ColorUtils.textBlack,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              StreamBuilder(
                  stream: Globals.uploadStream.getStream,
                  builder: (context, snapshot) {
                    print('snapshot');
                    print(snapshot);
                    return Container(
                      constraints: BoxConstraints(
                        minHeight: Get.height / 18,
                        maxHeight: Get.height / 4,
                      ),
                      color: ColorUtils.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Obx(
                            () => AnimatedSwitcher(
                              duration: const Duration(milliseconds: 125),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: child,
                                );
                              },
                              child: controller.showSendButton.isTrue ||
                                      controller.isRecorded.isTrue
                                  ? GestureDetector(
                                      onTap: () {
                                        controller.sendMessage();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: ColorUtils.orange,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Icon(
                                            Ionicons.send,
                                            color: ColorUtils.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        color: ColorUtils.orange,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: GestureDetector(
                                          onLongPressStart:
                                              (LongPressStartDetails start) {
                                            controller.start();
                                          },
                                          onTap: () {
                                            if (controller.isRecording.isTrue) {
                                              controller.stop();
                                            } else {
                                              controller.start();
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Obx(
                                              () => AnimatedSwitcher(
                                                duration: const Duration(
                                                    milliseconds: 250),
                                                transitionBuilder:
                                                    (Widget child,
                                                        Animation<double>
                                                            animation) {
                                                  return RotationTransition(
                                                    turns: animation,
                                                    child: child,
                                                  );
                                                },
                                                child: controller
                                                        .isRecording.isFalse
                                                    ? Icon(
                                                        Icons.mic_outlined,
                                                        color: ColorUtils.white,
                                                        size: 20,
                                                      )
                                                    : Material(
                                                        type: MaterialType
                                                            .transparency,
                                                        child: Icon(
                                                          Icons.stop,
                                                          color: ColorUtils.red,
                                                          size: 20,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          Expanded(
                            child: Obx(
                              () => AnimatedSwitcher(
                                duration: const Duration(milliseconds: 150),
                                transitionBuilder: (Widget child,
                                    Animation<double> animation) {
                                  return ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  );
                                },
                                child: controller.isRecorded.isFalse &&
                                        controller.isRecording.isFalse
                                    ? Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: ColorUtils.white,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                textAlign: TextAlign.right,
                                                textDirection:
                                                    TextDirection.rtl,
                                                focusNode:
                                                    controller.messageFocusNode,

                                                // controller: controller.searchController,
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                onFieldSubmitted: (String str) {
                                                  if (str.isNotEmpty) {
                                                    controller.sendMessage();
                                                  }
                                                },
                                                style: TextStyle(
                                                  color: ColorUtils.black,
                                                  fontSize: 14,
                                                ),
                                                onChanged: (String str) {
                                                  controller.showSendButton
                                                      .value = str.isNotEmpty;
                                                },

                                                onTap: () async {
                                                  if (controller
                                                          .messageController
                                                          .selection ==
                                                      TextSelection
                                                          .fromPosition(
                                                        TextPosition(
                                                          offset: controller
                                                                  .messageController
                                                                  .text
                                                                  .length -
                                                              1,
                                                        ),
                                                      )) {
                                                    controller.messageController
                                                            .selection =
                                                        TextSelection
                                                            .fromPosition(
                                                      TextPosition(
                                                        offset: controller
                                                            .messageController
                                                            .text
                                                            .length,
                                                      ),
                                                    );
                                                  }
                                                  Future.delayed(
                                                      const Duration(
                                                          milliseconds: 500),
                                                      () {
                                                    controller.scrollController
                                                        .animateTo(
                                                      controller
                                                          .scrollController
                                                          .position
                                                          .maxScrollExtent,
                                                      duration: const Duration(
                                                        milliseconds: 150,
                                                      ),
                                                      curve: Curves.ease,
                                                    );
                                                  });
                                                },
                                                minLines: 1,
                                                maxLines: 5,

                                                textInputAction:
                                                    TextInputAction.newline,
                                                controller: controller
                                                    .messageController,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                    right: 12,
                                                    top: 24,
                                                  ),
                                                  hintStyle: TextStyle(
                                                    color: ColorUtils.textBlack,
                                                  ),
                                                  hintText:
                                                      "پیام خود را بنویسید...",
                                                  hintMaxLines: 1,
                                                  focusedBorder:
                                                      const OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  enabledBorder:
                                                      const OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  disabledBorder:
                                                      const OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8.0,
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                // List<AssetEntity>? asset =
                                                //     await Get.bottomSheet(
                                                //   AddPostModal(
                                                //     controller: controller,
                                                //     isBusiness: false,
                                                //   ),
                                                //   isScrollControlled: true,
                                                // );
                                                // if (asset != null) {
                                                //   for (var o in asset) {
                                                //     controller.sendImage(
                                                //         '', (await o.file)!);
                                                //   }
                                                // }
                                              },
                                              child: Icon(
                                                Icons.attach_file_outlined,
                                                color: ColorUtils.orange,
                                                size: 25,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : controller.isRecording.isTrue
                                        ? buildRecording()
                                        : buildRecorded(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ],
          );
        });
  }

  Widget buildPhotoPick() {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  color: ColorUtils.yellow,
                  shape: BoxShape.circle,
                ),
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () => controller.pickImage(ImageSource.gallery),
                    borderRadius: BorderRadius.circular(500),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Ionicons.image_outline,
                            color: ColorUtils.white,
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            "گالری",
                            style: TextStyle(
                              color: ColorUtils.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                decoration: BoxDecoration(
                  color: ColorUtils.yellow,
                  shape: BoxShape.circle,
                ),
                height: 65,
                width: 65,
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () => controller.pickImage(ImageSource.camera),
                    borderRadius: BorderRadius.circular(500),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Ionicons.camera_outline,
                            color: ColorUtils.white,
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            "دوربین",
                            style: TextStyle(
                              color: ColorUtils.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: Get.height / 24,
              ),
            ],
          ),
          SizedBox(
            width: Get.width / 48,
          ),
        ],
      ),
    );
  }

  Widget buildRecording() {
    return GetBuilder(
      init: controller,
      id: 'voice_timer',
      builder: (context) {
        return Material(
          type: MaterialType.transparency,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 12,
              ),
              Text(
                controller.voiceShowTime,
                style: TextStyle(
                  fontSize: 12,
                  color: ColorUtils.orange.withOpacity(0.8),
                ),
              ),
              Divider(
                color: ColorUtils.orange,
                thickness: 5,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildRecorded() {
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          height: Get.height / 21,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: ColorUtils.white,
            boxShadow: [
              BoxShadow(
                color: ColorUtils.orange.withOpacity(0.1),
                spreadRadius: 3.0,
                blurRadius: 12.0,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  controller.isRecording.value = false;
                  controller.isRecorded.value = false;
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Ionicons.trash_outline,
                    color: ColorUtils.red,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      controller.voiceShowTime,
                      style: TextStyle(
                        fontSize: 12,
                        color: ColorUtils.orange.withOpacity(0.8),
                      ),
                    ),
                    Divider(
                      color: ColorUtils.orange,
                      thickness: 5,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
