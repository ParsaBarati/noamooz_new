import 'package:noamooz/Controllers/Onboarding/onboarding_controller.dart';
import 'package:noamooz/Models/on_boarding_page_model.dart';
import 'package:noamooz/Plugins/get/get.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/routing_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatelessWidget {
  final OnBoardingController controller = Get.put(
    OnBoardingController(),
  );

  OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.white,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Obx(
          () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            child: controller.isLoaded.isTrue
                ? buildPages()
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildPages() {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: controller.pageController,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              onPageChanged: (value) {
                controller.page.value = value;
                controller.update();
              },
              children: controller.pages.map((e) => buildPage(e)).toList(),
            ),
          ),
          ViewUtils.sizedBox(96),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WidgetUtils.outlineButton(
                textColor: ColorUtils.black.withOpacity(0.8),
                color: ColorUtils.white,
                title: "بیخیال",
                onTap: () => Get.offAllNamed(
                  RoutingUtils.login.name,
                ),
              ),
              SmoothPageIndicator(
                controller: controller.pageController,
                count: controller.pages.length,
                effect: ExpandingDotsEffect(
                  dotColor: ColorUtils.black.withOpacity(0.2),
                  activeDotColor: ColorUtils.orange,
                  dotHeight: 6,
                  dotWidth: 6,
                  expansionFactor: 5,
                  spacing: 13,
                ),
              ),
              Obx(
                () => WidgetUtils.softButton(
                  title: controller.page.value == controller.pages.length - 1
                      ? "ورود به برنامه"
                      : "ادامه",
                  onTap: controller.page.value == controller.pages.length - 1
                      ? () => Get.offAllNamed(
                            RoutingUtils.login.name,
                          )
                      : () => controller.pageController.nextPage(
                            duration: const Duration(milliseconds: 150),
                            curve: Curves.easeIn,
                          ),
                ),
              ),
            ],
          ),
          ViewUtils.sizedBox(96),
        ],
      ),
    );
  }

  Widget buildPage(OnBoardingPageModel e) {
    return SafeArea(
      child: Column(
        children: [
          ViewUtils.sizedBox(12),
          Image.network(
            e.icon.path,
            height: Get.height / 3,
            width: Get.width / 1.4,
          ),
          const SizedBox(
            height: 24,
          ),
          Text(
            e.name,
            style: TextStyle(
              color: ColorUtils.black,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          SizedBox(
            width: Get.width / 1.4,
            child: Text(
              e.details,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorUtils.black.withOpacity(0.7),
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
