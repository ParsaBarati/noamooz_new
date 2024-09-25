import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:ionicons/ionicons.dart';
import 'package:noamooz/Controllers/Lotteries/lottery_controller.dart';
import 'package:noamooz/Plugins/datepicker/persian_datetime_picker.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Utils/widget_utils.dart';
import 'package:noamooz/Widgets/my_app_bar.dart';

import '../../Plugins/get/get.dart';

class LotteryScreen extends StatelessWidget {
  final LotteryController controller = Get.put(LotteryController());

  LotteryScreen({Key? key}) : super(key: key);

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
      () => Stack(
        children: [
          Column(
            children: [
              MyAppBar(
                inner: true,
                title: controller.isLoading.isTrue
                    ? "در حال بارگذاری"
                    : controller.lottery.name,
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
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 150),
                                    child: isKeyboardVisible
                                        ? Container()
                                        : Column(
                                            children: [
                                              if (controller.lottery.course !=
                                                  null) ...[
                                                Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: CachedNetworkImage(
                                                        imageUrl: controller
                                                            .lottery
                                                            .course!
                                                            .cover,
                                                        width: Get.width - 24,
                                                        height: Get.height / 5,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: Get.width - 24,
                                                      height: Get.height / 5,
                                                      decoration: BoxDecoration(
                                                        color: ColorUtils.black
                                                            .withOpacity(0.4),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(
                                                            8.0,
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              const Text(
                                                                "مربوط به دوره:",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 4,
                                                              ),
                                                              Text(
                                                                controller
                                                                    .lottery
                                                                    .course!
                                                                    .name,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ],
                                          ),
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
                                  buildPrizes(),
                                  SizedBox(
                                    height: 24,
                                    width: Get.width / 1.5,
                                    child: Divider(
                                      color:
                                          ColorUtils.textColor.withOpacity(0.5),
                                      thickness: 0.5,
                                    ),
                                  ),
                                  buildInfo(),
                                  SizedBox(
                                    height: 24,
                                    width: Get.width / 1.5,
                                    child: Divider(
                                      color:
                                          ColorUtils.textColor.withOpacity(0.5),
                                      thickness: 0.5,
                                    ),
                                  ),
                                  const Spacer(),
                                  WidgetUtils.softButton(
                                    widthFactor: 1,
                                    reverse: true,
                                    loading: controller.attendLoading,
                                    icon: Ionicons.enter_outline,
                                    onTap: () => controller.attend(),
                                    title: "شرکت در قرعه کشی",
                                    fontWeight: FontWeight.bold,
                                  ),
                                  ViewUtils.sizedBox(),
                                ],
                              );
                            },
                          ),
                        ),
                ),
              ),
            ],
          ),
          if (controller.hasWon.isTrue)
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 1,
                sigmaY: 1,
              ),
              child: Container(
                height: Get.height,
                width: Get.width,
                decoration: BoxDecoration(
                  color: ColorUtils.black.withOpacity(0.5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: Get.width / 1.6,
                      decoration: BoxDecoration(
                        color: ColorUtils.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            CachedNetworkImage(
                              imageUrl: controller.prize.image,
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            Text(
                              "تبریک! شما برنده ی ${controller.prize.name} شدید.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: ColorUtils.black,
                                height: 1.5,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    controller.prize.details,
                                    style: TextStyle(
                                      color: ColorUtils.textBlack,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            WidgetUtils.softButton(
                              title: "بازگشت",
                              height: 24,
                              radius: 5,
                              fontSize: 12,
                              onTap: (){
                                Get.back();
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildPrizes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "جوایز:",
              style: TextStyle(
                color: ColorUtils.black,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.start,
          children: controller.lottery.prizes
              .map(
                (e) => buildInfoBox(
                  icon: e.image,
                  title: e.name,
                  value: " ${e.count.toString()} عدد",
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget buildInfoBox({
    required String icon,
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
            CachedNetworkImage(
              imageUrl: icon,
              height: 20,
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              title,
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

  Widget buildInfo() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.start,
      children: [
        if (controller.lottery.from > 0) ...[
          Container(
            decoration: BoxDecoration(
              color: ColorUtils.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Ionicons.calendar_clear_outline,
                  color: ColorUtils.textBlack,
                  size: 22,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  "از",
                  style: TextStyle(
                    fontSize: 12,
                    color: ColorUtils.textBlack,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                Text(
                  DateTime.fromMillisecondsSinceEpoch(
                    controller.lottery.from * 1000,
                  ).toJalali().formatCompactDate(),
                  style: TextStyle(
                    fontSize: 12,
                    color: ColorUtils.textBlack,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  "تا",
                  style: TextStyle(
                    fontSize: 12,
                    color: ColorUtils.textBlack,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  DateTime.fromMillisecondsSinceEpoch(
                    controller.lottery.to * 1000,
                  ).toJalali().formatCompactDate(),
                  style: TextStyle(
                    fontSize: 12,
                    color: ColorUtils.textBlack,
                  ),
                ),
              ],
            ),
          ),
        ],
        if (controller.lottery.course != null) ...[
          Container(
            decoration: BoxDecoration(
              color: ColorUtils.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: CachedNetworkImage(
                    imageUrl: controller.lottery.course!.icon,
                    width: 22,
                    height: 22,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  "دوره:",
                  style: TextStyle(
                    fontSize: 10,
                    color: ColorUtils.textBlack,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  controller.lottery.course!.name,
                  style: TextStyle(
                    fontSize: 10,
                    color: ColorUtils.textBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
        Container(
          decoration: BoxDecoration(
            color: ColorUtils.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Ionicons.people_circle_outline,
                color: ColorUtils.textBlack,
                size: 22,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                "برندگان:",
                style: TextStyle(
                  fontSize: 10,
                  color: ColorUtils.textBlack,
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                "${controller.lottery.maxWinners} نفر",
                style: TextStyle(
                  fontSize: 10,
                  color: ColorUtils.textBlack,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: ColorUtils.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 22,
              ),
              Text(
                "وضعیت:",
                style: TextStyle(
                  fontSize: 10,
                  color: ColorUtils.textBlack,
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                controller.getStatus(controller.lottery.status),
                style: TextStyle(
                  fontSize: 10,
                  color: ColorUtils.textBlack,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
