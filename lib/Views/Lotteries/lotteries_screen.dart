import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:noamooz/Controllers/Lotteries/lotteries_controller.dart';
import 'package:noamooz/Models/Lotteries/lottery_model.dart';
import 'package:noamooz/Plugins/datepicker/persian_datetime_picker.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/routing_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Widgets/my_app_bar.dart';

import '../../Plugins/get/get.dart';

class LotteriesScreen extends StatelessWidget {
  final LotteriesController controller = Get.put(LotteriesController());

  LotteriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorUtils.bgColor,
        body: buildBody(),
        resizeToAvoidBottomInset: false,
      ),
    );
  }

  Widget buildBody() {
    return Obx(
      () => Column(
        children: [
          buildAppBar(),
          ViewUtils.sizedBox(48),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: controller.isLoading.isTrue
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              itemCount: controller.lotteries.length,
                              separatorBuilder: (_, int index) =>
                                  const SizedBox(
                                height: 12,
                              ),
                              itemBuilder: (_, int index) => buildLottery(
                                controller.lotteries[index],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAppBar() {
    return MyAppBar(
      inner: true,
      title: "قرعه کشی ها",
    );
  }

  Widget buildLottery(LotteryModel lottery) {
    return Container(
      decoration: BoxDecoration(
        color: ColorUtils.white,
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => Get.toNamed(RoutingUtils.lotteryRoute(lottery.id)),
              child: Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                        child: lottery.course?.icon != null
                            ? CachedNetworkImage(
                                imageUrl: lottery.course!.icon,
                                height: Get.height / 12,
                              )
                            : Container(
                                height: Get.height / 12,
                                decoration: BoxDecoration(
                                  color: ColorUtils.gray.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Icon(
                                    Ionicons.image,
                                    size: (Get.height / 12) - 8,
                                    color: ColorUtils.black.withOpacity(0.9),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lottery.name,
                        style: TextStyle(
                          color: ColorUtils.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          if (lottery.from > 0) ...[
                            Text(
                              "از",
                              style: TextStyle(
                                fontSize: 10,
                                color: ColorUtils.textBlack,
                              ),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(
                              DateTime.fromMillisecondsSinceEpoch(
                                lottery.from * 1000,
                              ).toJalali().formatCompactDate(),
                              style: TextStyle(
                                fontSize: 10,
                                color: ColorUtils.textBlack,
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              "تا",
                              style: TextStyle(
                                fontSize: 10,
                                color: ColorUtils.textBlack,
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              DateTime.fromMillisecondsSinceEpoch(
                                lottery.to * 1000,
                              ).toJalali().formatCompactDate(),
                              style: TextStyle(
                                fontSize: 10,
                                color: ColorUtils.textBlack,
                              ),
                            ),
                          ],
                          if (lottery.course != null) ...[
                            if (lottery.from > 0) ...[
                              SizedBox(
                                height: 12,
                                child: VerticalDivider(
                                    color: ColorUtils.textBlack,
                                    thickness: 0.1,
                                    width: 8),
                              ),
                            ],
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
                              lottery.course!.name,
                              style: TextStyle(
                                fontSize: 10,
                                color: ColorUtils.textBlack,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              decoration: BoxDecoration(
                color: ColorUtils.orange,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Ionicons.people_circle_outline,
                      size: 16,
                      color: ColorUtils.white,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Text(
                      "${lottery.maxWinners} برنده",
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 8,
            bottom: -8,
            child: Container(
              decoration: BoxDecoration(
                color: ColorUtils.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 3,
                    blurRadius: 8,
                    offset: const Offset(
                      0,
                      -1,
                    ),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${controller.getStatus(lottery.status)}",
                      style: TextStyle(
                        fontSize: 10,
                        color: ColorUtils.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
