import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:noamooz/Controllers/Faq/faq_controller.dart';
import 'package:noamooz/Models/Faq/faq_model.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/shimmer_widget.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Utils/widget_utils.dart';
import 'package:noamooz/Widgets/my_app_bar.dart';
import 'package:noamooz/Widgets/my_drawer.dart';

import '../../Plugins/get/get.dart';

class FaqScreen extends StatelessWidget {
  final FaqController controller = Get.put(FaqController());

  FaqScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: buildBody(),
        resizeToAvoidBottomInset: false,
        drawer: MyDrawer(),
        backgroundColor: ColorUtils.bgColor,
      ),
    );
  }

  Widget buildBody() {
    return Obx(
      () => Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              MyAppBar(
                inner: true,
                title: 'سوالات متداول',
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 150),
                    child: controller.isLoading.isTrue
                        ? buildLoading()
                        : controller.faqs.isNotEmpty
                            ? buildList()
                            : buildEmpty(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildLoading() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: ColorUtils.white,
            borderRadius: BorderRadius.circular(10),
          ),
          width: Get.width,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerWidget(
                height: 25,
                width: Get.width / 3,
              ),
              ViewUtils.sizedBox(48),
              ShimmerWidget(
                height: 15,
                width: Get.width / 1,
              ),
              const SizedBox(
                height: 4,
              ),
              ShimmerWidget(
                height: 15,
                width: Get.width / 1,
              ),
              const SizedBox(
                height: 4,
              ),
              ShimmerWidget(
                height: 15,
                width: Get.width / 1.5,
              ),
            ],
          ),
        );
      },
      itemCount: 10,
    );
  }

  Widget buildList() {
    return DefaultTabController(
        length: controller.faqs.length,
        child: Column(
          children: [
            TabBar(
              isScrollable: true,
              tabs: controller.faqs
                  .map(
                    (e) => Tab(
                      child: Text(
                        e.name,
                      ),
                    ),
                  )
                  .toList(),
            ),
            Expanded(
              child: TabBarView(
                children: controller.faqs.map((e) => buildTab(e)).toList(),
              ),
            ),
          ],
        ));
  }

  Widget buildTab(FaqType faqType) {
    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 24),
        itemBuilder: (BuildContext context, int index) {

          Faq faq = faqType.faqs[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            child: FadeInAnimation(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: ColorUtils.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: Get.width,
                child: Material(
                  type: MaterialType.transparency,
                  child: ExpandablePanel(
                    theme: ExpandableThemeData(
                      iconColor: ColorUtils.textGray,
                      hasIcon: true,
                      inkWellBorderRadius: BorderRadius.circular(10),
                      expandIcon: Iconsax.arrow_down_1,
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      collapseIcon: Iconsax.arrow_up_2,
                      iconSize: 20,
                    ),
                    header: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        children: [
                          Text(
                            "${index + 1}. ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ColorUtils.black,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              faq.question,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorUtils.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    collapsed: Container(),
                    expanded: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(
                            color: ColorUtils.orange.withOpacity(0.5),
                            height: 1,
                          ),
                          ViewUtils.sizedBox(48),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  faq.answer,
                                  style: TextStyle(
                                    height: 1.5,
                                    color: ColorUtils.textBlack,
                                    fontSize: 13,
                                    wordSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: faqType.faqs.length,
      ),
    );
  }

  Widget buildEmpty() {
    return Center(
      child: Column(
        children: [
          Lottie.asset(
            'assets/animations/support.json',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Column(
              children: [
                Text(
                  "چیزی برای توضیح نیست!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                    color: ColorUtils.textBlack,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  "با کلیک روی دکمه زیر برو توی صفحه افزودن تابلو و تابلوی خودت رو رایگان ثبت کن!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    height: 1.5,
                    color: ColorUtils.textBlack,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                WidgetUtils.softButton(
                  widthFactor: 1,
                  title: "بازگشت",
                  onTap: () => Get.back(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
