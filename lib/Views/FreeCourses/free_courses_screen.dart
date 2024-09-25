import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:noamooz/Controllers/FreeCourses/free_courses_controller.dart';
import 'package:noamooz/Models/Courses/course_model.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/routing_utils.dart';
import 'package:noamooz/Utils/widget_utils.dart';
import 'package:noamooz/Widgets/my_app_bar.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../Plugins/get/get.dart';

class FreeCoursesScreen extends StatelessWidget {
  final FreeCoursesController controller = Get.put(FreeCoursesController());

  FreeCoursesScreen({Key? key}) : super(key: key);

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
          title: "${controller.category?.name ?? "در حال بارگذاری"} - رایگان",
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
