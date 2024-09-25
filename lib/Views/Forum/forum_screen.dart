import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:noamooz/Controllers/Forum/forum_controller.dart';
import 'package:noamooz/Models/Forums/forum_model.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/routing_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Widgets/my_app_bar.dart';

import '../../Plugins/get/get.dart';

class ForumScreen extends StatelessWidget {
  final ForumController controller = Get.put(ForumController());

  ForumScreen({Key? key}) : super(key: key);

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
                              itemCount: controller.forums.length,
                              separatorBuilder: (_, int index) =>
                                  const SizedBox(
                                height: 12,
                              ),
                              itemBuilder: (_, int index) => buildForums(
                                controller.forums[index],
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
      title: "تالار های گفتمان",
    );
  }

  Widget buildForums(ForumModel forum) {
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
              onTap: () => Get.toNamed(RoutingUtils.forumRoute(forum.id)),
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
                        child: forum.course?.icon != null
                            ? CachedNetworkImage(
                                imageUrl: forum.course!.icon,
                                height: Get.height / 18,
                              )
                            : Container(
                                height: Get.height / 18,
                                decoration: BoxDecoration(
                                  color: ColorUtils.gray.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Icon(
                                    Ionicons.image,
                                    size: (Get.height / 18) - 8,
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          forum.name,
                          style: TextStyle(
                            color: ColorUtils.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (forum.course != null) ...[
                          const SizedBox(
                            height: 2,
                          ),
                          Row(
                            children: [
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
                                forum.course!.name,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: ColorUtils.textBlack,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Icon(
                    Ionicons.chevron_back,
                    color: ColorUtils.gray.withOpacity(0.4),
                    size: 20,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
