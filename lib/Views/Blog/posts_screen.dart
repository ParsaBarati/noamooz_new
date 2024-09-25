import 'package:noamooz/Controllers/Blog/posts_controller.dart';
import 'package:noamooz/Globals/Globals.dart';
import 'package:noamooz/Models/Blog/post_model.dart';
import 'package:noamooz/Plugins/datepicker/persian_datetime_picker.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/image_utils.dart';
import 'package:noamooz/Utils/routing_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../Plugins/get/get.dart';

class PostsScreen extends StatelessWidget {
  final PostsController controller = Get.put(PostsController());

  PostsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: StreamBuilder(
        stream: Globals.userStream.getStream,
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: ColorUtils.bgColor,
            appBar: buildAppBar(),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  ViewUtils.sizedBox(48),
                  Row(
                    children: [
                      Expanded(
                        child: WidgetUtils.searchField(),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      buildFilter(),
                    ],
                  ),
                  ViewUtils.sizedBox(),
                  Expanded(
                    child: Obx(
                      () => AnimatedSwitcher(
                        duration: const Duration(
                          milliseconds: 150,
                        ),
                        child: controller.isLoading.isTrue
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : controller.posts.isEmpty
                                ? SizedBox(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text('اطلاعاتی یافت نشد'),
                                      ],
                                    ),
                                  )
                                : SingleChildScrollView(
                                    child: Column(
                                      children: controller.posts
                                          .map((e) => buildPost(e))
                                          .toList(),
                                    ),
                                  ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      elevation: 0,
      toolbarHeight: 50,
      shadowColor: ColorUtils.orange,
      backgroundColor: ColorUtils.white,
      foregroundColor: ColorUtils.black,
      leadingWidth: 40,
      actions: [
        IconButton(
          splashRadius: 20,
          onPressed: () => Globals.toggleDarkMode(),
          icon: Icon(
            Globals.darkModeStream.darkMode
                ? Iconsax.lamp_on
                : Iconsax.lamp_slash,
            size: 26,
          ),
        ),
      ],
      title: Text(
        "کتابخانه",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: ColorUtils.black,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget buildFilter() {
    return Container(
      decoration: BoxDecoration(
        color: ColorUtils.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Icon(
            Iconsax.filter,
            color: ColorUtils.black,
          ),
        ),
      ),
    );
  }

  Widget buildPost(PostModel post) {
    return GestureDetector(
      onTap: () {
        RoutingUtils.postRoute(
          post.id,
        );
      },
      child: SizedBox(
        height: Get.width / 2.5 + 32,
        child: Container(
          margin: const EdgeInsets.only(bottom: 18),
          decoration: BoxDecoration(
            color: ColorUtils.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  height: Get.width / 2.5,
                  width: Get.width / 3.3,
                  child: Image.network(
                    post.cover,
                    height: Get.width / 2.5,
                    width: Get.width / 3.3,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      post.title,
                      style: TextStyle(
                        color: ColorUtils.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ...post.tags.take(4).map((e) => buildTag(e)).toList(),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      post.price == 0
                          ? "رایگان"
                          : '${post.price.toString().seRagham()} تومان',
                      style: TextStyle(
                        color: ColorUtils.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      post.date.toJalali().formatFullDate(),
                      style: TextStyle(
                        color: ColorUtils.black,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    WidgetUtils.softButton(
                      widthFactor: 1,
                      title: "مشاهده مطلب",
                      height: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTag(Tag tag) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      child: Text(
        "#${tag.name}",
        textAlign: TextAlign.right,
        style: TextStyle(
          color: ColorUtils.orange,
          fontSize: 12,
        ),
      ),
    );
  }
}
