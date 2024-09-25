import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_share/flutter_share.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:noamooz/Globals/Globals.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/routing_utils.dart';
import 'package:noamooz/Utils/storage_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Utils/widget_utils.dart';
import 'package:noamooz/Views/Terms/terms_dialog.dart';
import 'package:noamooz/Widgets/get_confirmation_dialog.dart';
import 'package:noamooz/Widgets/my_app_bar.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../Plugins/get/get.dart';

class MyDrawer extends StatelessWidget {
  final MainGetxController controller = Get.find<MainGetxController>();

  MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      width: Get.width / 1.1,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: ColorUtils.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
              child: Column(
                children: [
                  ViewUtils.sizedBox(48),
                  buildProfile(),
                  ViewUtils.sizedBox(48),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        // buildListTile(
                        //   title: "صفحه اصلی",
                        //   icon: Iconsax.home_1,
                        //   route: RoutingUtils.main,
                        // ),
                        buildListTile(
                          title: "دوره های من",
                          icon: Iconsax.chart_1,
                          route: RoutingUtils.myCourses,
                        ),
                        // buildListTile(
                        //   title: "پشتیبانی",
                        //   icon: Iconsax.chart_1,
                        //   route: RoutingUtils.main,
                        // ),
                        // buildListTile(
                        //   title: "امتیازات",
                        //   icon: Iconsax.level,
                        //   route: RoutingUtils.main,
                        // ),
                        // buildListTile(
                        //   title: "کتابخانه",
                        //   icon: Iconsax.book,
                        //   route: RoutingUtils.main,
                        // ),
                        // buildListTile(
                        //   title: "شارژ حساب",
                        //   icon: Iconsax.wallet,
                        //   route: RoutingUtils.main,
                        // ),
                        buildListTile(
                          title: "قوانین و مقررات",
                          icon: Iconsax.judge,
                          route: RoutingUtils.main,
                          onClick: () {
                            Get.dialog(
                              TermsDialog(),
                              barrierColor: Colors.black.withOpacity(0.7),
                            );
                          },
                        ),
                        buildListTile(
                          title: "دعوت از دوستان",
                          icon: Iconsax.gift,
                          onClick: () {
                            // FlutterShare.share(
                            //   title: "اپلیکیشن نوآموز را امتحان کنید!",
                            //   linkUrl: "https://noamooz.ir/app",
                            //   text: "دسترسی به آرشیو چندین و چند دوره ی آموزشی",
                            // );
                          },
                        ),
                        Divider(
                          color: ColorUtils.orange.withOpacity(0.5),
                        ),
                        Column(
                          children: controller.menuItems
                              .map(
                                (e) => buildListTile(
                                  title: e.text,
                                  icon: e.file.path,
                                  onClick: (){
                                    launchUrlString(e.link);
                                  },
                                ),
                              )
                              .toList(),
                        ),
                        buildListTile(
                          title: "خروج",
                          icon: Iconsax.logout,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Obx(
                    () => SafeArea(
                      top: false,
                      child: Text(
                        controller.isPackageLoaded.isTrue
                            ? "نسخه ${controller.packageInfo.version}"
                            : "نسخه نامشخص",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: ColorUtils.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Column(
            children: [
              ViewUtils.sizedBox(18),
              IconButton(
                onPressed: () {
                  controller.closeDrawer() ;
                },
                splashRadius: 15,
                icon: const Icon(
                  Ionicons.close,
                  size: 30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildProfile() {
    return StreamBuilder(
      stream: Globals.userStream.getStream,
      builder: (context, snapshot) {
        return Container(
          height: Get.height / 10,
          decoration: BoxDecoration(
            color: ColorUtils.white,
          ),
          child: GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(
                top: 12,
                right: 12,
                left: 12,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Globals.userStream.user?.avatar.isNotEmpty ?? false
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(500),
                              child: Image.network(
                                Globals.userStream.user!.avatar,
                                height: Get.height / 12,
                                width: Get.height / 12,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              Ionicons.person_circle_outline,
                              color: ColorUtils.gray,
                              size: Get.height / 12,
                            ),
                      const SizedBox(
                        width: 12,
                      ),
                      if (!Globals.userStream.isLoggedIn()) ...[
                        WidgetUtils.softButton(
                          title: "ورود / ثبت نام",
                          widthFactor: 4,
                          onTap: () {
                            Get.offAllNamed(
                              RoutingUtils.login.name,
                            );
                          },
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                      if (Globals.userStream.isLoggedIn()) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Globals.userStream.user!.fullName,
                              style: TextStyle(
                                color: ColorUtils.black.withOpacity(0.8),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            WidgetUtils.softButton(
                              title: "ویرایش حساب کاربری",
                              widthFactor: 3.9,
                              height: 24,
                              radius: 25,
                              fontSize: 10,
                              onTap: () => Get.toNamed(
                                RoutingUtils.profile.name,
                              ),
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        )
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildListTile({
    required String title,
    required dynamic icon,
    GetPage<dynamic>? route,
    void Function()? onClick,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 24,
      ),
      decoration: BoxDecoration(
        color: ColorUtils.white,
        border: Border.all(
          color: route == null && onClick == null
              ? ColorUtils.red.withOpacity(0.2)
              : ColorUtils.orange.withOpacity(0.5),
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: () async {
            if (onClick != null) {
              onClick();
            } else {
              if (route is GetPage) {
                Get.toNamed(
                  route.name,
                );
              } else {
                bool? exit = await GetConfirmationDialog.show(
                  text: "آیا مطمئن هستید که از حساب کاربری خود خارج شوید؟",
                  maxFontSize: 16,
                );
                if (exit == true) {
                  await StorageUtils.removeToken();
                  Get.offAllNamed(RoutingUtils.login.name);
                  Globals.userStream.changeUser(null);
                }
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                icon is IconData
                    ? Icon(
                        icon,
                        size: 25,
                        color: route == null && onClick == null
                            ? ColorUtils.red
                            : ColorUtils.orange,
                      )
                    : CachedNetworkImage(
                        imageUrl: icon,
                        width: 25,
                        height: 25,
                      ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorUtils.black.withOpacity(0.7),
                  ),
                ),
                const Spacer(),
                Icon(
                  Iconsax.arrow_left_2,
                  size: 15,
                  color: ColorUtils.black.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
