import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noamooz/Globals/Globals.dart';
import 'package:noamooz/Models/Settings/setting_model.dart';
import 'package:noamooz/Models/db_models/setting_db_model.dart';
import 'package:noamooz/Models/db_models/user_db_model.dart';
import 'package:noamooz/Models/user_model.dart';
import 'package:noamooz/Utils/Api/project_request_utils.dart';
import 'package:noamooz/Utils/routing_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Widgets/notif_dialog.dart';
import 'package:noamooz/main.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../Plugins/get/get.dart';

class SplashController extends GetxController {
  final RxBool isLoaded = false.obs;

  void onInit() {
    Future.delayed(const Duration(seconds: 1), () async {
      // Get.offAndToNamed(
      //   RoutingUtils.index.name,
      // );
      // return false;
      WidgetsBinding.instance.addObserver(Handler());

      final hasInternet = await InternetConnectivity().hasInternetConnection;
      if (hasInternet) {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String version = packageInfo.version;
        String token = "no_token";
        try {
          FirebaseMessaging messaging = FirebaseMessaging.instance;
          token = await messaging.getToken() ?? "no_token";
        } catch (e) {
          print(e.toString());
        }
        // FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        //   alert: true,
        //   badge: true,
        //   sound: true
        // );

        ApiResult result = await RequestsUtil.instance.auth.check(token);
        FirebaseMessaging messaging = FirebaseMessaging.instance;

        NotificationSettings settings = await messaging.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );

        print('User granted permission: ${settings.authorizationStatus}');
        FirebaseMessaging.onMessage.listen((event) {
          print('new message');
          print(event.data);
          if (event.notification != null) {
            Get.dialog(
              NotifDialog(event: event),
            );
            // ViewUtils.showInfoDialog(
            //   event.notification!.body,
            //   event.notification!.title,
            // );
          }
        });
        // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
        //   if (message != null) {
        //     if (message.data['link'] != null){
        //       launchUrlString(message.data['link'] ?? "");
        //     }
        //   }
        // });
        // await Permission.notification.request();
        // await Permission.audio.request();
        // await Permission.camera.request();
        // await Permission.photos.request();
        //

        if (result.isDone) {
          Globals.settingStream.changeSetting(
            SettingModel.fromJson(result.data['settings']),
          );
          Globals.userStream.changeUser(
            UserModel.fromJson(result.data['user']),
          );

          await UserDbModel().truncate();
          int id = await UserDbModel().insert({
            'content': jsonEncode(Globals.userStream.user!.toJson()),
          });
          print('id: ${id}');
          await SettingDbModel().truncate();
          await SettingDbModel().insert({
            'content': jsonEncode(Globals.settingStream.setting!.toJson()),
          });

          Globals.offlineStream.changeOffline(false);

          Get.offAndToNamed(
            RoutingUtils.main.name,
          );
          return true;
        }
        Get.offAndToNamed(
          RoutingUtils.onBoarding.name,
        );
      } else {
        ViewUtils.showInfoDialog("تغییر به حالت آفلاین...");
        List result = await UserDbModel().getAll();

        print(result);
        if (result.isNotEmpty) {
          UserModel userModel =
              UserModel.fromJson(jsonDecode(result.first['content']));
          if (userModel.id > 0) {
            List result = await SettingDbModel().getAll();
            if (result.isNotEmpty) {
              Globals.settingStream.changeSetting(
                SettingModel.fromJson(jsonDecode(result.first['content'])),
              );
            }
            Globals.userStream.changeUser(
              userModel,
            );
            Globals.offlineStream.changeOffline(true);
            Future.delayed(const Duration(seconds: 1), () {
              Get.offAndToNamed(
                RoutingUtils.main.name,
              );
            });
          } else {
            ViewUtils.showErrorDialog("کاربر یافت نشد");
            Future.delayed(const Duration(seconds: 2), () {
              SystemNavigator.pop(
                animated: true,
              );
            });
          }
        } else {
          ViewUtils.showErrorDialog("کاربر یافت نشد");
          Future.delayed(const Duration(seconds: 2), () {
            SystemNavigator.pop(
              animated: true,
            );
          });
          print(result);
        }
        // UserModel? userModel = user.get('user');
        //
      }
    });

    super.onInit();
  }
}
