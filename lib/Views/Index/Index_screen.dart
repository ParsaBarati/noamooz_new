import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:noamooz/Controllers/Index/index_controller.dart';
import 'package:noamooz/Globals/Globals.dart';
import 'package:noamooz/Models/Index/home_icon_model.dart';
import 'package:noamooz/Plugins/get/get.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/routing_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Widgets/my_app_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher_string.dart';

class IndexScreen extends StatelessWidget {
  final MainGetxController appBarController = Get.find<MainGetxController>();
  final IndexController controller = Get.put(IndexController());
  final GlobalKey globalKey = GlobalKey();

  IndexScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: globalKey,
        backgroundColor: ColorUtils.bgColor,
        body: buildBody(),
        resizeToAvoidBottomInset: false,
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
                      children: [
                        if (controller.banners.isNotEmpty) ...[
                          const SizedBox(
                            height: 8,
                          ),
                          buildAds(),
                        ],
                        const SizedBox(
                          height: 8,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: GridView.builder(
                              padding: EdgeInsets.zero,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisExtent: Get.height / 5,
                                mainAxisSpacing: 12,
                              ),
                              itemCount: controller.icons.length,
                              itemBuilder: (_, int index) => buildButton(
                                controller.icons[index],
                              ),
                            ),
                          ),
                        ),
                        ViewUtils.sizedBox(12),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildAppBar() {
    return MyAppBar(
      key: globalKey,
    );
  }

  Widget buildAds() {
    return GestureDetector(
      child: Column(
        children: [
          SizedBox(
            height: Get.height / 6,
            child: PageView(
              controller: controller.pageController,
              children: controller.banners.map((e) {
                return GestureDetector(
                  onTap: () {
                    if (e.link.toString().startsWith('course_')) {
                      int id = int.tryParse(e.link
                              .toString()
                              .split('course_')
                              .last
                              .toString()) ??
                          0;
                      Get.toNamed(
                        RoutingUtils.singleCourseRoute(id),
                      );
                    } else {
                      launchUrlString(
                        e.link,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  child: Container(
                    width: Get.width,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    height: Get.height / 6,
                    decoration: BoxDecoration(
                      color: ColorUtils.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: CachedNetworkImage(
                        imageUrl: e.image.path,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          SmoothPageIndicator(
            controller: controller.pageController,
            count: controller.banners.length,
            effect: ExpandingDotsEffect(
              dotColor: ColorUtils.black.withOpacity(0.2),
              activeDotColor: ColorUtils.orange,
              dotHeight: 6,
              dotWidth: 6,
              spacing: 13,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }

  Widget buildButton(HomeIcon icon) {
    return Container(
      decoration: BoxDecoration(
        color: ColorUtils.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => controller.onTap(icon),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (!Globals.offlineStream.isOffline &&
                    icon.icon.path.endsWith('.json')) ...[
                  Transform.scale(
                    scale: 1.8,
                    child: Lottie.network(
                      icon.icon.path,
                      height: Get.height / 12,
                    ),
                  ),
                ],
                if (!Globals.offlineStream.isOffline &&
                    (icon.icon.path.endsWith('.jpg') ||
                        icon.icon.path.endsWith('.png'))) ...[
                  Image.network(
                    icon.icon.path,
                    height: Get.height / 12,
                  ),
                ],
                if (Globals.offlineStream.isOffline) ...[
                  Icon(
                    Ionicons.cloud_offline_outline,
                    size: 50,
                    color: ColorUtils.black.withOpacity(0.5),
                  ),
                ],
                const SizedBox(
                  height: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      icon.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorUtils.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                if (icon.subTitle.trim().isNotEmpty) ...[
                  const SizedBox(
                    height: 4,
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 150),
                    child: Text(
                      icon.subTitle,
                      style: TextStyle(
                        color: ColorUtils.black.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
