import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:noamooz/Globals/Globals.dart';
import 'package:noamooz/Models/db_models/menu_items_model.dart';
import 'package:noamooz/Models/menu_item_model.dart';
import 'package:noamooz/Plugins/bottomNavBar/persistent-tab-view.dart';
import 'package:noamooz/Plugins/drawer/config.dart';
import 'package:noamooz/Plugins/drawer/flutter_zoom_drawer.dart';
import 'package:noamooz/Plugins/get/get.dart';
import 'package:noamooz/Utils/Api/project_request_utils.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MainGetxController extends GetxController {
  final RxString mobile = "".obs;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late PackageInfo packageInfo;
  final RxBool isPackageLoaded = false.obs;
  PersistentTabController tabviewController = PersistentTabController();
  PersistentTabController controller = PersistentTabController(initialIndex: 0);
  List<MenuItemModel> menuItems = [];
  int currentIndex = 0;

  void openDrawer() {
    // Scaffold.of(context).openDrawer();

    scaffoldKey.currentState?.openDrawer();
  }

  void closeDrawer() {
    // Scaffold.of(context).openEndDrawer();
    scaffoldKey.currentState?.openEndDrawer();
  }

  void toggleDrawer() {
    if (scaffoldKey.currentContext?.drawerState == DrawerState.open) {
      closeDrawer();
    } else {
      openDrawer();
    }
  }

  @override
  void onInit() {
    getInfo();
    getMenuItems();

    super.onInit();
  }

  void getMenuItems() async {
    if (!Globals.offlineStream.isOffline) {
      ApiResult result = await RequestsUtil.instance.pages.menuItems();
      if (result.isDone) {
        menuItems.clear();
        menuItems.addAll(
            List.from(result.data).map((e) => MenuItemModel.fromJson(e)));
        await MenuItemsDbModel().truncate();
        await MenuItemsDbModel().insertAll(menuItems.map((e) {
          return {
            'content': e.toJson(),
          };
        }).toList());
      }
    } else {
      List res = await MenuItemsDbModel().getAll();

      menuItems.clear();
      menuItems.addAll(
        List.from(res).map(
          (e) => MenuItemModel.fromJson(
            jsonDecode(
              e['content'],
            ),
          ),
        ),
      );
    }
  }

  void getInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    this.packageInfo = packageInfo;
    isPackageLoaded.value = true;
    if (Globals.userStream.user?.state == null && !Globals.offlineStream.isOffline){
      currentIndex = 2;
      update();
    }
  }

  void setScaffoldKey(GlobalKey<ScaffoldState> globalKey) {
    scaffoldKey = globalKey;
  }

  void add() async {}
}

// ignore: must_be_immutable
class MyAppBar extends StatelessWidget {
  final MainGetxController controller = Get.find();
  final bool inner;
  final bool hasBack;
  final String title;
  Color bgColor = Colors.transparent;

  MyAppBar({
    Key? key,
    this.title = "تنظیمات",
    this.inner = false,
    this.hasBack = false,
    this.bgColor = Colors.transparent,
    GlobalKey<ScaffoldState>? globalKey,
  }) {
    print(globalKey);
    if (globalKey != null) {
      controller.setScaffoldKey(globalKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Globals.userStream.getStream,
        builder: (context, snapshot) {
          return !inner ? buildMainAppBar() : buildSingleAppBar();
        });
  }

  Widget buildMainAppBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: ColorUtils.black,
        actions: [
          const SizedBox(
            width: 12,
          ),
          GestureDetector(
            onTap: () {
              controller.currentIndex = 2;
              controller.update();
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(500),
              child: CachedNetworkImage(
                imageUrl: Globals.userStream.user?.avatar ??
                    Globals.settingStream.setting!.logo?.path ?? "",
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
        ],
        title: Row(
          children: [
            Expanded(
              child: AutoSizeText(
                Globals.settingStream.setting?.name ?? "نوآموز",
                maxLines: 1,
                minFontSize: 12,
                style: TextStyle(
                  color: ColorUtils.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
            ),
          ],
        ),
        leading: null,
      ),
    );
  }

  Widget buildSingleAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          splashRadius: 20,
          onPressed: () => Globals.toggleDarkMode(),
          icon: Icon(
            Globals.darkModeStream.darkMode
                ? Iconsax.lamp_on
                : Iconsax.lamp_slash,
            size: 26,
            color: ColorUtils.black,
          ),
        ),
      ],
      title: Text(
        title,
        style: TextStyle(
          color: ColorUtils.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      leadingWidth: 50,
      leading: BackButton(
        color: ColorUtils.black,
      ),
    );
  }
}
