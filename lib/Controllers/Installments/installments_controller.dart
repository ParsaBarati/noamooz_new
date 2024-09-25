import 'dart:async';
import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:noamooz/Globals/Globals.dart';
import 'package:noamooz/Models/Courses/course_model.dart';
import 'package:noamooz/Models/Courses/installment_model.dart';
import 'package:noamooz/Plugins/get/get.dart';
import 'package:noamooz/Utils/Api/project_request_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Views/Courses/paymeht_method_dialog.dart';
import 'package:noamooz/Views/Courses/transfer_information_dialog.dart';
import 'package:app_links/app_links.dart';
import 'package:url_launcher/url_launcher_string.dart';

class InstallmentsController extends GetxController {
  CourseModel? course;
  List<InstallmentModel> installments = [];
  final RxBool isLoading = true.obs;
  final appLinks = AppLinks(); // AppLinks is singleton

  StreamSubscription? _sub;

  @override
  void onInit() {
    fetchInstallments();
    super.onInit();
  }

  void fetchInstallments() async {
    isLoading.value = true;
    if (!Globals.offlineStream.isOffline) {
      ApiResult result = await RequestsUtil.instance.course
          .installments(Get.currentRoute.split('/').last);
      if (result.isDone) {
        course = CourseModel.fromJson(result.data['course']);
        installments =
            InstallmentModel.listFromJson(result.data['installments']);
      } else {
        ViewUtils.showErrorDialog(
            "خطایی در بارگذاری دوره های شما رخ داد، لطفا بعدا امتحان کنید");
      }
    } else {
      Get.back();
    }

    isLoading.value = false;
  }

  void pay(InstallmentModel installment) async {
    if (!EasyLoading.isShow) {
      String? method = await Get.dialog(
        const PaymentMethodDialog(),
      );
      if (method == 'online') {
        EasyLoading.show();
        ApiResult result =
            await RequestsUtil.instance.course.payInstallment(installment.id);
        EasyLoading.dismiss();
        if (result.isDone) {
          if (result.data['url'] is String) {
            _sub = appLinks.uriLinkStream.listen((uri) {
              String link = uri.path;
              if (link.contains('payment') == true) {
                if (link.contains('fail') == true) {
                  ViewUtils.showErrorDialog("پرداخت با خطا مواجه شد!");
                  fetchInstallments();
                } else {
                  Uri uri = Uri.parse(link);
                }
                ViewUtils.showSuccessDialog(
                  "خرید شما با موفقیت انجام شد",
                );
                fetchInstallments();
              }
            });
            await launchUrlString(
              result.data['url'],
              mode: LaunchMode.externalApplication,
            );
            fetchInstallments();
          } else {
            fetchInstallments();
          }
        }
      } else {
        Get.dialog(
          TransferInformationDialog(),
        );
      }
    }
  }
}
