import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noamooz/Models/Support/ticket_model.dart';
import 'package:noamooz/Models/general_item_model_no_icon.dart';
import 'package:noamooz/Plugins/get/get.dart';
import 'package:noamooz/Plugins/my_dropdown/dropdown_controller.dart';
import 'package:noamooz/Utils/Api/project_request_utils.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Views/Support/create_ticket_dialog.dart';
import 'package:noamooz/Widgets/form_utils.dart';

class SupportController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool submitLoading = false.obs;
  List<GeneralInformationModelNoIcon> subjects = [];
  List<TicketModel> tickets = [];
  final RxBool isFilePicked = false.obs;
  File? file;
  Future<void> createTicket() async {
    if (subjects.isEmpty) {
      EasyLoading.show();
      ApiResult result = await RequestsUtil.instance.support.subjects();
      EasyLoading.dismiss();
      if (result.isDone) {
        subjects
            .addAll(GeneralInformationModelNoIcon.listFromJson(result.data));
        Get.dialog(
          CreateTicketDialog(),
          barrierColor: ColorUtils.black.withOpacity(0.7),
        );
      }
    } else {
      await Get.dialog(
        CreateTicketDialog(),
        barrierColor: ColorUtils.black.withOpacity(0.7),
      );
    }
  }

  Future<void> createTicketSubmit({
    required MyTextController title,
    required MyTextController text,
    required DropdownController subject,
  }) async {
    if (title.text.trim().length < 3) {
      ViewUtils.showErrorDialog("لطقا عنوان درخواست را به صورت کامل وارد کنید");
      return;
    }
    if (subject.isSelected.isFalse) {
      ViewUtils.showErrorDialog("لطفا موضوع درخواست را انتخاب کنید");
      return;
    }
    if (text.text.trim().length < 20) {
      ViewUtils.showErrorDialog(
        "متن درخواست نمی تواند کمتر از 20 کاراکتر باشد.",
      );
      return;
    }
    submitLoading.value = true;
    ApiResult result = await RequestsUtil.instance.support.create(
      title: title.text,
      text: text.text,
      subjectId: subject.value.dropdownId(),
      file: file,
    );
    submitLoading.value = false;
    if (result.isDone) {
      Get.back();
      fetchTickets();
      ViewUtils.showSuccessDialog(
        result.data['message'].toString(),
      );
    } else {
      ViewUtils.showErrorDialog(
        result.data['message'].toString(),
      );
    }
  }

  @override
  void onInit() {
    fetchTickets();
    super.onInit();
  }

  void fetchTickets() async {
    isLoading.value = true;
    ApiResult result = await RequestsUtil.instance.support.list();
    if (result.isDone){
      tickets = TicketModel.listFromJson(result.data);
    } else {
      Get.back();
      ViewUtils.showErrorDialog(result.data['message'].toString());
    }
    isLoading.value = false;
  }

  void attachFile() async {
    isFilePicked.value = false;
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result?.isSinglePick == true) {
      file = File(result!.files.first.path!);
      isFilePicked.value = true;
    }
  }
}
