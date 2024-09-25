import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:noamooz/Controllers/Courses/courses_controller.dart';
import 'package:noamooz/Models/Courses/course_model.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/routing_utils.dart';
import 'package:noamooz/Utils/widget_utils.dart';
import 'package:noamooz/Widgets/my_app_bar.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../Plugins/get/get.dart';

class CoursesScreen extends StatelessWidget {
  final CoursesController controller = Get.put(CoursesController());

  CoursesScreen({Key? key}) : super(key: key);

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
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: controller.isLoading.isTrue
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: WidgetUtils.searchField(
                                  controller: controller.searchController,
                                  onChanged: (_) {
                                    controller.isLoading.value = true;
                                    controller.isLoading.value = false;
                                  },
                                ),
                              ),
                              // const SizedBox(
                              //   width: 12,
                              // ),
                              // WidgetUtils.softButton(
                              //   height: Get.height / 21,
                              //   color: ColorUtils.white,
                              //   textColor: ColorUtils.black,
                              //   widthFactor: 3.4,
                              //   iconSize: 18,
                              //   icon: Ionicons.filter,
                              //   title: "مرتب سازی",
                              //   onTap: () {},
                              //   reverse: true,
                              // ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              itemCount: controller.courses.length,
                              separatorBuilder: (_, int index) =>
                                  const SizedBox(
                                height: 12,
                              ),
                              itemBuilder: (_, int index) => buildCourse(
                                controller.courses[index],
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
    return Column(
      children: [
        MyAppBar(
          inner: true,
          title: controller.category?.name ?? "در حال بارگذاری",
        ),
        if (controller.category != null) ...[
          SizedBox(
            width: Get.width,
            height: Get.height / 5,
            child: CachedNetworkImage(
              imageUrl: controller.category?.banner?.path ?? "",
              fit: BoxFit.cover,
            ),
          ),
                ],
      ],
    );
  }

  Widget buildCourse(CourseModel course) {
    return Container(
      decoration: BoxDecoration(
        color: ColorUtils.white,
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Get.toNamed(
              RoutingUtils.singleCourseRoute(course.id),
            );
          },
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
                    child: CachedNetworkImage(
                      imageUrl: course.icon,
                      height: Get.height / 12,
                    ),
                  ),
                  if (course.hasInstallments) ...[
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorUtils.orange,
                          border: Border.all(
                            color: ColorUtils.orange,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        child: const Text(
                          "اقساطی",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AutoSizeText(
                              course.name,
                              maxLines: 2,
                              minFontSize: 12,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: ColorUtils.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),

                          const SizedBox(
                            width: 8,
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    course.price.toString().seRagham(),
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: ColorUtils.black,
                                      fontWeight: FontWeight.bold,
                                      decoration:
                                          course.discountPrice < course.price
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "تومان",
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: ColorUtils.textColor,
                                      fontSize: 10,
                                      decoration:
                                          course.discountPrice < course.price
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 4,
                              ),
                              if (course.discountPrice < course.price)
                                Row(
                                  children: [
                                    Text(
                                      course.discountPrice.toString().seRagham(),
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: ColorUtils.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      "تومان",
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: ColorUtils.textColor,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
