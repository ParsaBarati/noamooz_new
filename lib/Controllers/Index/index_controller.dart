import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:noamooz/Globals/Globals.dart';
import 'package:noamooz/Models/Blog/post_model.dart';
import 'package:noamooz/Models/Index/banner_model.dart';
import 'package:noamooz/Models/Index/home_icon_model.dart';
import 'package:noamooz/Models/db_models/home_icons_model.dart';
import 'package:noamooz/Plugins/get/get.dart';
import 'package:noamooz/Utils/Api/project_request_utils.dart';
import 'package:noamooz/Utils/routing_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';

class IndexController extends GetxController {
  final RxBool isLoading = true.obs;
  final PageController pageController = PageController();
  List<PostModel> posts = [];
  List<BannerModel> banners = [];
  List<HomeIcon> icons = [];
  Timer? _timer;

  void fetchInit() async {
    isLoading.value = true;
    if (!Globals.offlineStream.isOffline) {
      ApiResult result = await RequestsUtil.instance.pages.index();
      if (result.isDone) {
        banners = BannerModel.listFromJson(result.data['banners']);
        icons = HomeIcon.listFromJson(result.data['icons']);
        _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
          pageController.nextPage(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeIn,
          );
          if (pageController.page == banners.length - 1){
            pageController.animateToPage(0, duration: Duration(milliseconds: 150), curve: Curves.easeIn,);
          }
        });
        try {
          await HomeIconsDbModel().truncate();
          await HomeIconsDbModel().insertAll(icons.map((e) {
            return {
              'content': e.toJson(),
            };
          }).toList());
        } catch (e) {}
      }
    } else {
      List homeIcons = await HomeIconsDbModel().getAll();
      icons = HomeIcon.listFromJson(
          homeIcons.map((e) => jsonDecode(e['content'])).toList());
    }
    isLoading.value = false;
  }

  @override
  void onInit() {
    fetchInit();
    super.onInit();
  }


  void onTap(HomeIcon icon) {
    print(icon.id);
    switch (icon.id) {
      case 1:
        Get.toNamed(RoutingUtils.categories.name, arguments: {
          "free": false,
        });
        break;
      case 2:
        Get.toNamed(RoutingUtils.categories.name, arguments: {
          "free": true,
        });
        break;
      case 3:
        Get.toNamed(RoutingUtils.forums.name);
        break;
      case 4:
        Get.toNamed(RoutingUtils.myCourses.name);
        break;
      case 5:
        Get.toNamed(RoutingUtils.support.name);
        break;
      case 6:
        Get.toNamed(RoutingUtils.quizzes.name);
        break;
      case 7:
        Get.toNamed(RoutingUtils.lotteries.name);
        break;
      case 8:
        Get.toNamed(RoutingUtils.faq.name);
        break;
      default:
        ViewUtils.showErrorDialog("صفحه مورد نظر در حال طراحی است");
        break;
    }
  }
}
