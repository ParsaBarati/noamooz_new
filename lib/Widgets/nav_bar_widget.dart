import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:noamooz/Controllers/Login/login_controller.dart';
import 'package:noamooz/Controllers/Profile/profile_controller.dart';
import 'package:noamooz/Controllers/Wallet/wallet_controller.dart';
import 'package:noamooz/Globals/Globals.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Widgets/my_app_bar.dart';

import '../Plugins/get/get.dart';

class NavBar extends StatelessWidget {
  final MainGetxController controller = Get.find<MainGetxController>();

  NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 8,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: GetBuilder(
          init: controller,
          builder: (context) {
            return Container(
              width: Get.width / 1.05,
              height: Get.height / 16,
              decoration: BoxDecoration(
                color: ColorUtils.white,
                border: Border.all(
                  color: ColorUtils.orange.withOpacity(0.3),
                ),
                borderRadius: BorderRadius.circular(10),
                // boxShadow: [
                //   BoxShadow(
                //     color: ColorUtils.orange.withOpacity(0.05),
                //     spreadRadius: 3,
                //     blurRadius: 12,
                //   ),
                // ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildIcon(
                    index: 0,
                    icon: Iconsax.home,
                    title: 'خانه',
                  ),
                  buildIcon(
                    index: 1,
                    icon: Iconsax.chart,
                    title: 'دوره های من',
                  ),
                  buildIcon(
                    index: 2,
                    icon: Iconsax.profile_2user,
                    title: 'پروفایل',
                  ),
                  buildIcon(
                    index: 3,
                    icon: Iconsax.menu,
                    title: 'منو',
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildIcon({
    required int index,
    required IconData icon,
    required String title,
  }) {
    bool isSelected = index == controller.currentIndex;
    return ClipRRect(
      borderRadius: index == 0
          ? const BorderRadius.only(
              bottomRight: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            )
          : index == 3
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  topLeft: Radius.circular(10.0),
                )
              : BorderRadius.zero,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () {
            if (Globals.userStream.user?.state == null && !Globals.offlineStream.isOffline) {
              return;
            } else {
              if (index != controller.currentIndex) {
                if (index == 3 && Globals.userStream.isLoggedIn()) {
                  controller.openDrawer();
                } else {
                  controller.currentIndex = index;
                  controller.update();
                }
              }
              if (controller.currentIndex == 0) {
                Get.delete<ProfileController>();
                Get.delete<WalletController>();
                Get.delete<LoginController>();
                // Get.delete<DashboardController>();
              }
            }
          },
          child: Container(
            width: Get.width / 1.05 / 4 - 1,
            height: Get.height / 16,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isSelected ? ColorUtils.orange : Colors.transparent,
                  width: 3,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? ColorUtils.orange
                      : ColorUtils.textGray.withOpacity(0.5),
                  size: 20,
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected
                        ? ColorUtils.orange
                        : ColorUtils.textGray.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                    fontSize: isSelected ? 12 : 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButton() {
    return GestureDetector(
      onTap: () => controller.add(),
      child: Container(
        width: ((Get.width / 1.1) / 5) - 24,
        height: Get.height / 16,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            stops: const [
              0.98,
              0.99,
              0,
            ],
            center: const Alignment(0, -1),
            colors: [
              Colors.transparent,
              ColorUtils.gray.shade100.withOpacity(0.1),
              ColorUtils.white,
            ],
          ),
        ),
      ),
    );
  }
}
