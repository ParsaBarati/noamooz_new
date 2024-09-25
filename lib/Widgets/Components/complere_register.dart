import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:noamooz/Controllers/Login/login_controller.dart';
import 'package:noamooz/Globals/Globals.dart';
import 'package:noamooz/Models/user_model.dart';
import 'package:noamooz/Plugins/get/get.dart';
import 'package:noamooz/Utils/Api/project_request_utils.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/routing_utils.dart';
import 'package:noamooz/Utils/storage_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Utils/widget_utils.dart';

class CompleteRegister extends StatefulWidget {
  final String mobile;
  final String code;
  final LoginController controller;

  const CompleteRegister({
    super.key,
    required this.mobile,
    required this.code,
    required this.controller,
  });

  @override
  _CompleteRegisterState createState() => _CompleteRegisterState();
}

class _CompleteRegisterState extends State<CompleteRegister> {
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode passwordConfirmFocusNode = FocusNode();

  Widget header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'تکمیل اطلاعات',
          style: TextStyle(
            fontSize: 21.0,
            fontWeight: FontWeight.bold,
            color: ColorUtils.black,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: Get.width / 1.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Material(
          color: ColorUtils.white,
          borderRadius: BorderRadius.circular(10.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: Get.height / 48,
                ),
                header(),
                SizedBox(
                  height: Get.height / 48,
                ),
                body(),
                // SizedBox(
                //   height: Get.height / 48,
                // ),
                // GetBuilder(
                //     init: widget.controller,
                //     id: "categories",
                //     builder: (context) {
                //       return WidgetUtils.outlineButton(
                //         title: widget.controller.selectedCategories.isEmpty
                //             ? "انتخاب دسته بندی های مورد علاقه"
                //             : widget.controller.selectedCategories
                //                 .map((e) => e.name)
                //                 .join('، '),
                //         widthFactor:
                //             widget.controller.selectedCategories.isEmpty
                //                 ? 1.8
                //                 : 1.33,
                //         fontWeight: FontWeight.bold,
                //         fontSize: 12,
                //         onTap: () {
                //           widget.controller.selectCategories();
                //         },
                //       );
                //     }),
                SizedBox(
                  height: Get.height / 48,
                ),
                finalBtn(),
                SizedBox(
                  height: Get.height / 48,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget finalBtn() {
    return WidgetUtils.softButton(
      title: "ثبت نام",
      fontWeight: FontWeight.bold,
      onTap: () => finalize(),
      enabled: true,
      widthFactor: 1,
    );
  }

  Widget body() {
    return Column(
      children: [
        name(),
        const SizedBox(
          height: 12,
        ),
        lastName(),
        const SizedBox(
          height: 12,
        ),
        password(),
        const SizedBox(
          height: 12,
        ),
        passwordConfirm(),
      ],
    );
  }

  Widget _textInput({
    required TextEditingController controller,
    required String name,
    void Function(String)? onChange,
    required FocusNode focusNode,
    bool password = false,
    int maxLen = 9999,
    TextAlign align = TextAlign.right,
  }) {
    return WidgetUtils.input(
      title: name,
      textColor: ColorUtils.black,
      controller: controller,
      letterSpacing: 0,
      password: password,
      focusNode: focusNode,
      textAlign: align,
      onChanged: onChange,
    );
  }

  Widget name() {
    return _textInput(
      controller: nameController,
      focusNode: nameFocusNode,
      name: "نام",
    );
  }

  Widget lastName() {
    return _textInput(
      controller: lastNameController,
      focusNode: lastNameFocusNode,
      name: "نام خانوادگی",
    );
  }

  Widget password() {
    return _textInput(
      controller: passwordController,
      focusNode: passwordFocusNode,
      password: true,
      name: "رمز عبور",
    );
  }

  Widget passwordConfirm() {
    return _textInput(
      controller: passwordConfirmController,
      focusNode: passwordConfirmFocusNode,
      name: "تایید رمز عبور",
      password: true,
    );
  }

  void finalize() async {
    EasyLoading.show();
    ApiResult result = await RequestsUtil.instance.auth.completeRegister(
      name: nameController.text,
      lastName: lastNameController.text,
      password: passwordController.text,
      passwordConfirm: passwordConfirmController.text,
      code: widget.code,
      mobile: widget.mobile,
    );
    EasyLoading.dismiss();
    if (result.isDone) {
      await StorageUtils.setToken(result.data['token']);
      Globals.userStream.changeUser(UserModel.fromJson(
        result.data['user'],
      ));
      Get.offAllNamed(
        RoutingUtils.main.name,
      );
    } else {
      ViewUtils.showErrorDialog(
        result.data,
      );
    }
  }
}
