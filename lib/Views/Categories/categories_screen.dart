import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:noamooz/Controllers/Categories/categories_controller.dart';
import 'package:noamooz/Models/general_item_model.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/routing_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Widgets/my_app_bar.dart';

import '../../Plugins/get/get.dart';

class CategoriesScreen extends StatelessWidget {
  final CategoriesController controller = Get.put(CategoriesController());

  CategoriesScreen({Key? key}) : super(key: key);

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
                              // gridDelegate:
                              //     SliverGridDelegateWithFixedCrossAxisCount(
                              //   crossAxisCount: 3,
                              //   crossAxisSpacing: 12,
                              //   mainAxisExtent: Get.height / 5,
                              //   mainAxisSpacing: 12,
                              // ),
                              itemCount: controller.categories.length,
                              separatorBuilder: (_, int index) =>
                                  const SizedBox(
                                height: 16,
                              ),
                              itemBuilder: (_, int index) => buildCategory(
                                controller.categories[index],
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
      title: "دسته بندی ها",
    );
  }

  Widget buildCategory(GeneralInformationModel category) {
    return Container(
      height: 98,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorUtil.fromHex(category.color ?? ColorUtils.white.toHex())
                .withOpacity(0.5),
            ColorUtil.fromHex(category.color ?? ColorUtils.white.toHex()),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => Get.toNamed(
            controller.freeOnly
                ? RoutingUtils.freeCoursesRoute(category.id)
                : RoutingUtils.coursesRoute(category.id),
            arguments: {
              'free': controller.freeOnly,
            },
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 75,
                  child: Image.network(
                    category.icon.path,
                    height: Get.height / 12,
                    width: 75,
                  ),
                ),
                SizedBox(
                  width: Get.width / 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AutoSizeText(
                              category.name,
                              maxLines: 2,
                              minFontSize: 12,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
