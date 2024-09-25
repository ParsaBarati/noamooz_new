import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:noamooz/Models/Courses/course_model.dart';
import 'package:noamooz/Plugins/get/get.dart';
import 'package:noamooz/Utils/Api/project_request_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Views/Courses/comment_actions_dialog.dart';
import 'package:noamooz/Widgets/get_confirmation_dialog.dart';

mixin CommentController  {
  final RxBool isEdit = false.obs;
  final AudioPlayer player = AudioPlayer();

  final TextEditingController cController = TextEditingController();
  Rx<Comment> reply = Comment(
    id: 0,
    user: User(id: 0, image: '', name: ''),
    date: 0,
    text: '',
    replies: [],
  ).obs;

  void init();

  void commentActions(Comment comment) async {
    Get.dialog(
      CommentActionsDialog(
        comment: comment,
        controller: this,
      ),
    );
  }

  void editStart(Comment comment) {
    isEdit.value = true;
    cController.text = comment.text;
  }

  void editConfirm(Comment comment) async {
    EasyLoading.show();
    ApiResult result = await RequestsUtil.instance.pages.editComment(
      id: comment.id,
      text: cController.text,
    );
    EasyLoading.dismiss();
    if (result.isDone) {
      isEdit.value = false;
      Get.close(1);
      init();
      ViewUtils.showSuccessDialog(result.data['message'].toString());
    } else {
      ViewUtils.showErrorDialog(result.data['message'].toString());
    }
  }

  void delete(Comment comment) async {
    bool? exit = await GetConfirmationDialog.show(
      text: "آیا از حذف این کامنت اطمینان دارید؟",
      maxFontSize: 14,
    );
    if (exit == true) {
      EasyLoading.show();
      ApiResult result =
          await RequestsUtil.instance.pages.deleteComment(comment.id);
      EasyLoading.dismiss();
      if (result.isDone) {
        Get.close(1);

        ViewUtils.showSuccessDialog(
          result.data['message'].toString(),
        );
        init();
      } else {
        ViewUtils.showErrorDialog(
          result.data['message'].toString(),
        );
      }
    }
  }

}
