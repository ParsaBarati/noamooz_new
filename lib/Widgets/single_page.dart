import 'package:flutter/material.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Widgets/my_app_bar.dart';
import 'package:noamooz/Widgets/my_drawer.dart';

import '../Plugins/get/get.dart';

class SinglePage extends StatelessWidget {
  final String title;
  final Widget child;
  final Rx<Color> color;
  final MainGetxController controller = Get.find<MainGetxController>();
  final bool appBar;

  SinglePage({
    Key? key,
    required this.title,
    required this.child,
    required this.color,
    this.appBar = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
    return Obx(
      () => Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          drawer: MyDrawer(),
          key: globalKey,
          backgroundColor: color.value,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                appBar
                    ? MyAppBar(
                        bgColor: color.value,
                    globalKey: globalKey,
                      )
                    : Container(),
                ViewUtils.sizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        width: Get.width,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              ColorUtils.white,
                              ColorUtils.white.withOpacity(0.2),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "${title}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 42,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        width: Get.width,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              ColorUtils.white.withOpacity(0.2),
                              ColorUtils.white,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ViewUtils.sizedBox(48),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
