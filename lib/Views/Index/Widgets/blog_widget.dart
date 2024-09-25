import 'package:auto_size_text/auto_size_text.dart';
import 'package:noamooz/Controllers/Index/index_controller.dart';
import 'package:noamooz/Models/Blog/post_model.dart';
import 'package:noamooz/Plugins/datepicker/persian_datetime_picker.dart';

import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/image_utils.dart';
import 'package:noamooz/Utils/routing_utils.dart';
import 'package:noamooz/Utils/shimmer_widget.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../Plugins/get/get.dart';

class BlogWidget extends StatelessWidget {
  final IndexController controller = Get.find<IndexController>();

  BlogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height / 4,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: ColorUtils.white,
        borderRadius: BorderRadius.circular(15),
      ),
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/img/book2.png',
                  height: 35,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "کتابخانه",
                  style: TextStyle(
                    color: ColorUtils.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const Spacer(),
                Icon(
                  Iconsax.more_square,
                  color: ColorUtils.orange.withOpacity(0.8),
                  size: 15,
                ),
                const SizedBox(
                  width: 4,
                ),
                GestureDetector(
                  onTap: (){
                    Get.toNamed(RoutingUtils.blog.name,);
                  },
                  child: Text(
                    "مشاهده همه",
                    style: TextStyle(
                      color: ColorUtils.orange.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            ViewUtils.softUiDivider(),
            const SizedBox(
              height: 12,
            ),
            Obx(
              () => Expanded(
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (_, int index) {
                    return const SizedBox(
                      width: 12,
                    );
                  },
                  itemBuilder: (_, int index) => controller.isLoading.isTrue
                      ? ShimmerWidget(
                          height: Get.height / 12,
                          width: Get.width / 1.5,
                        )
                      : buildPost(index),
                  itemCount:
                      controller.isLoading.isTrue ? 3 : controller.posts.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPost(int index) {
    PostModel post = controller.posts[index];
    return Container(
      height: Get.height / 6,
      width: Get.width / 1.5,
      decoration: BoxDecoration(
        color: ColorUtils.white,
        border: Border.all(
          color: ColorUtils.orange,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    topLeft: Radius.circular(10.0),
                  ),
                  child: ImageUtils.fadeIn(
                    image: post.cover,
                    width: Get.width / 1.5,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: ColorUtils.black.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Iconsax.calendar,
                            color: ColorUtils.white.withOpacity(0.7),
                            size: 15,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            post.date.toJalali().formatMediumDate(),
                            style: TextStyle(
                              color: ColorUtils.white.withOpacity(0.7),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AutoSizeText(
                    post.title,
                    maxLines: 1,
                    style: TextStyle(
                      color: ColorUtils.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  'ادامه مطلب',
                  style: TextStyle(
                    color: ColorUtils.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
