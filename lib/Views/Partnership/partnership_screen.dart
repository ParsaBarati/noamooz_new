import 'package:auto_size_text/auto_size_text.dart';
import 'package:noamooz/Controllers/Partnership/partnership_controller.dart';
import 'package:noamooz/Globals/Globals.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../Plugins/get/get.dart';

class PartnershipScreen extends StatelessWidget {
  final PartnershipController controller = Get.put(PartnershipController());

  PartnershipScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Obx(
        () => DefaultTabController(
          length: 4,
          child: Scaffold(
            backgroundColor: ColorUtils.bgColor,
            appBar: buildAppBar(),
            body: controller.isLoading.isTrue
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [],
                  ),
          ),
        ),
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
        "همکاری با ما",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: ColorUtils.black,
        ),
      ),
      centerTitle: true,
      bottom: const TabBar(
        padding: EdgeInsets.zero,
        isScrollable: true,
        tabs: [
          Tab(
            iconMargin: EdgeInsets.zero,
            child: Text(
              'در انتظار پاسخنامه',
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          Tab(
            iconMargin: EdgeInsets.zero,
            child: Text(
              'در حال بررسی',
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          Tab(
            iconMargin: EdgeInsets.zero,
            child: Text(
              'تایید شده',
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          Tab(
            iconMargin: EdgeInsets.zero,
            child: Text(
              'رد شده',
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
