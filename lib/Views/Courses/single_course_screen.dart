import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:noamooz/Controllers/Courses/single_course_controller.dart';
import 'package:noamooz/Globals/Globals.dart';
import 'package:noamooz/Models/Courses/course_model.dart';
import 'package:noamooz/Models/file_model.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/routing_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Utils/widget_utils.dart';
import 'package:noamooz/Views/Courses/comment_widget.dart';
import 'package:noamooz/Widgets/my_app_bar.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../Plugins/get/get.dart';

class SingleCourseScreen extends StatelessWidget {
  final SingleCourseController controller = Get.put(SingleCourseController());

  SingleCourseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorUtils.bgColor,
        body: buildBody(),
        resizeToAvoidBottomInset: true,
      ),
    );
  }

  Widget buildBody() {
    return Obx(
          () =>
          Column(
            children: [
              MyAppBar(
                inner: true,
                title: "دوره",
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: controller.isLoading.isTrue
                      ? const Center(
                    child: CircularProgressIndicator(),
                  )
                      : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: KeyboardVisibilityBuilder(
                        builder: (context, isKeyboardVisible) {
                          return !controller.courseModel.hasBought
                              ? SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 150),
                                  child: isKeyboardVisible
                                      ? Container()
                                      : Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl: controller
                                              .courseModel.cover,
                                          width: Get.width - 24,
                                          height: Get.height / 5,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                    ],
                                  ),
                                )
                                ,
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        controller.courseModel.name,
                                        style: TextStyle(
                                          color: ColorUtils.textBlack,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 24,
                                  width: Get.width,
                                  child: Divider(
                                    color:
                                    ColorUtils.textColor.withOpacity(0.5),
                                    thickness: 0.5,
                                  ),
                                ),
                                buildInfoBoxes(),
                                SizedBox(
                                  height: 24,
                                  width: Get.width / 1.5,
                                  child: Divider(
                                    color:
                                    ColorUtils.textColor.withOpacity(0.5),
                                    thickness: 0.5,
                                  ),
                                ),
                                buildPriceAndBuy(),
                                SizedBox(
                                  height: 24,
                                  width: Get.width / 2,
                                  child: Divider(
                                    color:
                                    ColorUtils.textColor.withOpacity(0.5),
                                    thickness: 0.5,
                                  ),
                                ),
                                buildTabs(),
                              ],
                            ),

                          ) : buildFiles();
                        }),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Widget buildInfoBoxes() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        buildInfoBox(
          icon: Iconsax.document_download,
          title: "تعداد فایل ها:",
          value: controller.courseModel.files.length.toString(),
        ),
        buildInfoBox(
          icon: Iconsax.wallet,
          title: "فروش اقساطی:",
          value: controller.courseModel.hasInstallments ? "دارد" : "ندارد",
        ),
        buildInfoBox(
          icon: Iconsax.size,
          title: "حجم دوره:",
          value: controller.courseModel.size,
        ),
        buildInfoBox(
          icon: Iconsax.clock,
          title: "مدت دوره:",
          value: controller.courseModel.duration,
        ),
      ],
    );
  }

  Widget buildInfoBox({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ColorUtils.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 4,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: ColorUtils.textColor,
            ),
            const SizedBox(
              width: 6,
            ),
            Text(
              "$title ",
              style: TextStyle(
                color: ColorUtils.textColor,
                fontSize: 12,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: ColorUtils.black,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPriceAndBuy() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: ColorUtils.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: Get.height / 14,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "قیمت اصلی: ",
                            style: TextStyle(
                              color: ColorUtils.textColor,
                              fontSize: 12,
                              decoration: controller.courseModel.discountPrice <
                                  controller.courseModel.price
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          Text(
                            controller.courseModel.price.toString().seRagham(),
                            style: TextStyle(
                              color: ColorUtils.black,
                              decoration: controller.courseModel.discountPrice <
                                  controller.courseModel.price
                                  ? TextDecoration.lineThrough
                                  : null,
                              fontWeight:
                              controller.courseModel.discountPrice ==
                                  controller.courseModel.price
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          Text(
                            " تومان",
                            style: TextStyle(
                              color: ColorUtils.textColor,
                              decoration: controller.courseModel.discountPrice <
                                  controller.courseModel.price
                                  ? TextDecoration.lineThrough
                                  : null,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      if (controller.courseModel.discountPrice <
                          controller.courseModel.price) ...[
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            Text(
                              "قیمت با تخفیف: ",
                              style: TextStyle(
                                color: ColorUtils.textColor,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              controller.courseModel.discountPrice
                                  .toString()
                                  .seRagham(),
                              style: TextStyle(
                                color: ColorUtils.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              " تومان",
                              style: TextStyle(
                                color: ColorUtils.textColor,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (controller.courseModel.hasBought == false &&
            !Globals.offlineStream.isOffline) ...[
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                child: WidgetUtils.softButton(
                  height: Get.height / 14,
                  title: controller.courseModel.price == 0
                      ? "فعال سازی دوره"
                      : "خرید دوره",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  reverse: true,
                  loading: controller.isBuyLoading,
                  icon: Iconsax.shop_add,
                  iconSize: 20,
                  onTap: () => controller.buy(),
                ),
              ),
            ],
          ),
        ],
        if (controller.courseModel.hasBought == true &&
            controller.courseModel.boughtInstallment == true) ...[
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                child: WidgetUtils.softButton(
                  height: Get.height / 14,
                  title: "مشاهده اقساط",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  reverse: true,
                  icon: Iconsax.fatrows,
                  iconSize: 20,
                  onTap: () =>
                      Get.toNamed(
                        RoutingUtils.installmentsRoute(
                            controller.courseModel.id),
                      ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget buildTabs() {
    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: isKeyboardVisible
                  ? Container()
                  : const Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(
                        child: Text("توضیحات دوره"),
                      ),
                      Tab(
                        child: Text("فایل های دوره"),
                      ),
                      Tab(
                        child: Text("نظر دهی"),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                ],
              ),
            );
          }),
          Container(
            constraints: BoxConstraints(maxHeight: Get.height / 3.5),
            child: TabBarView(
              children: [
                buildDescription(),
                buildFiles(),
                buildComments(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDescription() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  controller.courseModel.details,
                  style: TextStyle(
                    fontSize: 12,
                    color: ColorUtils.black,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildFiles() {
    return DefaultTabController(
      length: controller.courseModel.courses.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            indicatorColor: ColorUtils.orange.withOpacity(0.5),
            isScrollable: true,
            tabs: controller.courseModel.courses
                .map(
                  (e) =>
                  Tab(
                    child: Text(
                      e,
                    ),
                  ),
            )
                .toList(),
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
            child: TabBarView(
              children: controller.courseModel.courses
                  .map(
                    (e) =>
                    SingleChildScrollView(
                      child: Column(
                        children: controller.courseModel.files
                            .where((element) => element.courseName == e)
                            .map((e) => buildFile(e))
                            .toList(),
                      ),
                    ),
              )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFile(FileModel fileModel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
                            fileModel.alt
                                .trim()
                                .isEmpty
                                ? "بدون نام"
                                : fileModel.alt,
                            style: TextStyle(
                              color: ColorUtils.black,
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
                            fontSize: 12,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "${ViewUtils.getFileType(
                              fileModel.path
                                  .split('.')
                                  .last,
                            )} (${fileModel.path
                                .split('.')
                                .last})",
                            style: TextStyle(
                              color: ColorUtils.black,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              fileModel.hasBought
                  ? Obx(
                    () =>
                    Icon(
                      fileModel.fileExists.isTrue
                          ? Iconsax.clock
                          : Iconsax.document_download,
                      color: ColorUtils.textColor,
                    ),
              )
                  : Icon(
                Iconsax.lock,
                color: ColorUtils.textColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildComments() {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Obx(
                () =>
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  transitionBuilder: (Widget child,
                      Animation<double> animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: controller.reply.value.id > 0
                      ? Container(
                    width: Get.width,
                    margin: const EdgeInsets.only(
                      bottom: 8,
                    ),
                    decoration: BoxDecoration(
                      color: ColorUtils.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "در پاسخ به: ",
                                      style: TextStyle(
                                        color:
                                        ColorUtils.black.withOpacity(0.5),
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      controller.reply.value.user?.name ?? "",
                                      style: TextStyle(
                                        color: ColorUtils.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                ViewUtils.sizedBox(96),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        controller.reply.value.text,
                                        style: TextStyle(
                                          color: ColorUtils.black
                                              .withOpacity(0.7),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              controller.reply.value = Comment(
                                id: 0,
                                user: User(id: 0, image: '', name: ''),
                                date: 0,
                                text: '',
                                replies: [],
                              );
                            },
                            child: const Icon(
                              Icons.close_outlined,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      : const SizedBox(),
                ),
          ),
          Row(
            children: [
              Material(
                color: ColorUtils.red,
                borderRadius: BorderRadius.circular(5),
                child: InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () => controller.voiceComment(),
                  child: SizedBox(
                    height: Get.width > 400 ? Get.height / 24 : Get.height / 22,
                    width: Get.width > 400 ? Get.height / 24 : Get.height / 22,
                    child: const Center(
                      child: Icon(
                        Ionicons.mic_outline,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: WidgetUtils.formTextField(
                  title: "کامنت خودت رو بنویس...",
                  controller: controller.commentController,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Obx(
                    () =>
                    Material(
                      color: ColorUtils.bgColor,
                      borderRadius: BorderRadius.circular(5),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () => controller.attachFile(),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: controller.isFilePicked.isTrue
                                  ? ColorUtils.green
                                  : ColorUtils.gray.withOpacity(0.5),
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          height:
                          Get.width > 400 ? Get.height / 24 : Get.height / 22,
                          width:
                          Get.width > 400 ? Get.height / 24 : Get.height / 22,
                          child: Center(
                            child: Icon(
                              controller.isFilePicked.isTrue
                                  ? Ionicons.checkmark_done_outline
                                  : Ionicons.attach_outline,
                              color: controller.isFilePicked.isTrue
                                  ? ColorUtils.green
                                  : ColorUtils.gray,
                            ),
                          ),
                        ),
                      ),
                    ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          WidgetUtils.softButton(
            title: "ارسال",
            color: ColorUtils.green,
            widthFactor: 1,
            loading: controller.isCommentLoading,
            onTap: () => controller.sendComment(),
          ),
          ViewUtils.sizedBox(),
          Column(
            children: controller.courseModel.comments
                .map(
                  (e) =>
                  CommentWidget(
                    comment: e,
                    controller: controller,
                  ),
            )
                .toList(),
          ),
        ],
      ),
    );
  }
}
