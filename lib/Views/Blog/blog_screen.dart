import 'package:noamooz/Controllers/Blog/blog_controller.dart';
import 'package:noamooz/Globals/Globals.dart';
import 'package:noamooz/Models/Blog/post_model.dart';
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

class BlogScreen extends StatelessWidget {
  final BlogController controller = Get.put(BlogController());

  BlogScreen({Key? key}) : super(key: key);

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
                                      children: [
                                        buildSection(
                                          title: "پربازدید ترین مطالب هفته",
                                          showAll: false,
                                          perPage: 1,
                                          pageController:
                                              controller.mostVisitsController,
                                          posts: controller.mostVisits,
                                          tag: "most-visits",
                                        ),
                                        ViewUtils.sizedBox(),
                                        buildSection(
                                          title: "آخرین مطالب",
                                          showAll: true,
                                          perPage: 3,
                                          pageController:
                                              controller.latestPostsController,
                                          posts: controller.latestPosts,
                                          tag: "latest-posts",
                                        ),
                                        ViewUtils.sizedBox(),
                                        buildSection(
                                          title: "ویدئو کست",
                                          showAll: true,
                                          perPage: 3,
                                          pageController:
                                              controller.videoCastController,
                                          posts: controller.latestPosts,
                                          tag: "video-cast",
                                        ),
                                        ViewUtils.sizedBox(),
                                        buildSection(
                                          title: "پادکست",
                                          showAll: true,
                                          perPage: 3,
                                          pageController:
                                              controller.podcastController,
                                          posts: controller.latestPosts,
                                          tag: "pod-cast",
                                        ),
                                        ViewUtils.sizedBox(),
                                      ],
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




  Widget buildSection({
    required String title,
    required bool showAll,
    required int perPage,
    required PageController pageController,
    required List<PostModel> posts,
    required String tag,
  }) {
    return SizedBox(
      height: perPage == 1 ? Get.height / 4 : Get.height / 4.5,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: ColorUtils.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (showAll)
                Row(
                  children: [
                    Icon(
                      Iconsax.more_square,
                      color: ColorUtils.orange.withOpacity(0.8),
                      size: 15,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(RoutingUtils.posts.name, parameters: {
                          't': tag,
                        });
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
                )
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemBuilder: (_, int index) => buildSlide(posts[index]),
              itemCount: posts.length,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          SmoothPageIndicator(
            controller: pageController,
            count: posts.length,
            effect: ScrollingDotsEffect(
              dotColor: ColorUtils.black.withOpacity(0.2),
              activeDotColor: ColorUtils.orange,
              dotHeight: 6,
              dotWidth: 6,
              spacing: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSlide(PostModel post) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 6,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: ImageUtils.cachedImage(
          post.cover,
        ),
      ),
    );
  }
}
