import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:noamooz/Controllers/Courses/comment_controller.dart';
import 'package:noamooz/Globals/Globals.dart';
import 'package:noamooz/Models/Courses/course_model.dart';
import 'package:noamooz/Models/db_models/courses_model.dart';
import 'package:noamooz/Models/file_model.dart';
import 'package:noamooz/Plugins/get/get.dart';
import 'package:noamooz/Utils/Api/project_request_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Views/Courses/check_installment_dialog.dart';
import 'package:noamooz/Views/Courses/installment_dialog.dart';
import 'package:noamooz/Views/Courses/paymeht_method_dialog.dart';
import 'package:noamooz/Views/Courses/transfer_information_dialog.dart';
import 'package:noamooz/Views/Courses/voice_recorder_dialog.dart';
import 'package:noamooz/Widgets/download_dialog.dart';
import 'package:app_links/app_links.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SingleCourseController extends GetxController with CommentController {
  final RxBool isLoading = false.obs;
  final RxBool isFilePicked = false.obs;
  File? file;
  final RxBool isBuyLoading = false.obs;
  final RxBool isCommentLoading = false.obs;
  late CourseModel courseModel;
  final TextEditingController commentController = TextEditingController();
  StreamSubscription? _sub;
  final appLinks = AppLinks(); // AppLinks is singleton

  void fetchCourse() async {
    isLoading.value = true;
    if (!Globals.offlineStream.isOffline) {
      ApiResult result = await RequestsUtil.instance.pages
          .course(Get.currentRoute.split('/').last);
      if (result.isDone) {
        courseModel = CourseModel.fromJson(result.data);
        for (var element in courseModel.files) {
          element.checkFileExists();
        }
        await CoursesDbModel().create();

        Map<String, dynamic>? course = await CoursesDbModel()
            .getCourse(int.tryParse(Get.currentRoute.split('/').last) ?? 0);
        if (course != null) {
          await CoursesDbModel().update(course['id'], {
            'content': jsonEncode(courseModel.toJson()),
          });
        } else {
          await CoursesDbModel().insert({
            'course_id': courseModel.id,
            'content': jsonEncode(courseModel.toJson()),
          });
        }
      } else {
        Get.back();
        ViewUtils.showErrorDialog(result.data['message'].toString() ?? "");
      }
    } else {
      await CoursesDbModel().create();
      Map<String, dynamic>? course = await CoursesDbModel()
          .getCourse(int.tryParse(Get.currentRoute.split('/').last) ?? 0);
      if (course != null) {
        courseModel = CourseModel.fromJson(jsonDecode(course['content']));
      } else {
        Get.back();
      }
    }
    for (var element in courseModel.files) {
      await element.checkFileExists();
    }
    isLoading.value = false;
  }

  @override
  void onInit() {
    fetchCourse();
    super.onInit();
  }

  @override
  void init() {
    fetchCourse();
  }

  void sendComment() async {
    isCommentLoading.value = true;
    ApiResult result = await RequestsUtil.instance.pages.comment(
      id: courseModel.id,
      text: commentController.text,
      reply: reply.value.id,
      voice: null,
      file: file,
    );
    isCommentLoading.value = false;
    file = null;
    isFilePicked.value = false;
    if (result.isDone) {
      commentController.clear();
      ViewUtils.showSuccessDialog(result.data['message'].toString());
    } else {
      ViewUtils.showErrorDialog(result.data['message'].toString());
    }
  }

  void openFile(FileModel fileModel) async {
    if (courseModel.hasBought) {
      if (fileModel.hasBought) {
        DownloadController controller = Get.find();
        controller.downloadFileFromServer(
          fileModel,
          courseModel,
        );
        Get.dialog(
          DownloadDialog(),
        );
      } else {
        ViewUtils.showErrorDialog("لطفا ابتدا جهت پرداخت قسط اقدام کنید");
      }
    } else {
      ViewUtils.showErrorDialog("لطفا ابتدا جهت خرید دوره اقدام کنید");
    }
  }

  Future<void> buy() async {
    if (courseModel.price == 0) {
      isBuyLoading.value = true;
      ApiResult result = await RequestsUtil.instance.course.buy(courseModel.id);
      isBuyLoading.value = false;
      if (result.isDone) {
        fetchCourse();
        ViewUtils.showSuccessDialog(result.data['message'] ?? "");
      } else {
        ViewUtils.showErrorDialog(result.data['message'] ?? "");
      }
    } else {
      if (courseModel.hasInstallments) {
        bool? wantInstallments = await Get.dialog(
          const CheckInstallmentDialog(),
        );
        if (wantInstallments == true) {
          Map<String, dynamic>? res = await Get.dialog(
            InstallmentDialog(
              maxInstallmentMonths: courseModel.maxInstallmentMonths,
              totalPrice: courseModel.discountPrice,
            ),
          );
          if (res != null && res['monthCount'] != null) {
            EasyLoading.show();
            ApiResult result = await RequestsUtil.instance.course.buy(
              courseModel.id,
              monthCount: int.tryParse(res['monthCount'].toString()) ?? 0,
            );
            EasyLoading.dismiss();
            if (result.isDone) {
              ViewUtils.showSuccessDialog(result.data['message'] ?? "");
              if (result.data['url'] is String) {
                _sub = appLinks.uriLinkStream.listen((link) {

                  if (link.path.contains('payment') == true) {
                    if (link.path.contains('fail') == true) {
                      ViewUtils.showErrorDialog("پرداخت با خطا مواجه شد!");
                      fetchCourse();
                    } else if (link is String) {
                      Uri uri = link;
                      ViewUtils.showSuccessDialog(
                        "خرید شما با موفقیت انجام شد",
                      );
                      fetchCourse();
                    }
                  }
                });
                await launchUrlString(
                  result.data['url'],
                  mode: LaunchMode.externalApplication,
                );
                fetchCourse();
              } else {
                fetchCourse();
              }
            } else {
              ViewUtils.showErrorDialog(result.data['message'] ?? "");
            }
          }
        } else if (wantInstallments == false) {
          pay();
        }
      } else {
        pay();
      }
    }
  }

  void voiceComment() async {
    String? recordedFilePath = await Get.dialog(
      VoiceRecorderDialog(),
    );
    if (recordedFilePath is String) {
      File file = File(recordedFilePath);
      if (file.existsSync()) {
        isCommentLoading.value = true;
        ApiResult result = await RequestsUtil.instance.pages.comment(
          id: courseModel.id,
          text: commentController.text,
          reply: reply.value.id,
          file: this.file,
          voice: file,
        );
        isCommentLoading.value = false;
        if (result.isDone) {
          commentController.clear();
          ViewUtils.showSuccessDialog(result.data['message'].toString());
        } else {
          ViewUtils.showErrorDialog(result.data['message'].toString());
        }
      }
    }
  }

  void attachFile() async {
    isFilePicked.value = false;
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result?.isSinglePick == true) {
      file = File(result!.files.first.path!);
      isFilePicked.value = true;
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }

  void pay() async {
    String? method = await Get.dialog(
      const PaymentMethodDialog(),
    );
    if (method == 'online') {
      isBuyLoading.value = true;
      ApiResult result = await RequestsUtil.instance.course.buy(courseModel.id);
      isBuyLoading.value = false;
      if (result.isDone) {
        ViewUtils.showSuccessDialog(result.data['message'] ?? "");
        if (result.data['url'] is String) {
          _sub = appLinks.uriLinkStream.listen((link) {

            if (link.path.contains('payment') == true) {
              if (link.path.contains('fail') == true) {
                ViewUtils.showErrorDialog("پرداخت با خطا مواجه شد!");
                fetchCourse();
              } else if (link is String) {
                Uri uri = link;
                ViewUtils.showSuccessDialog(
                  "خرید شما با موفقیت انجام شد",
                );
                fetchCourse();
              }
            }
          });
          await launchUrlString(
            result.data['url'],
            mode: LaunchMode.externalApplication,
          );
          fetchCourse();
        } else {
          fetchCourse();
        }
      } else {
        ViewUtils.showErrorDialog(result.data['message'] ?? "");
      }
    } else if (method == 'transfer') {
      Get.dialog(
        TransferInformationDialog(),
      );
    }
  }
}
