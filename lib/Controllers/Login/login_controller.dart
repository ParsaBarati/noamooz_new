import 'dart:async';

import 'package:noamooz/Models/general_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:noamooz/Globals/Globals.dart';
import 'package:noamooz/Models/user_model.dart';
import 'package:noamooz/Plugins/get/get.dart';
import 'package:noamooz/Utils/Api/project_request_utils.dart';
import 'package:noamooz/Utils/routing_utils.dart';
import 'package:noamooz/Utils/storage_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Widgets/Components/complere_register.dart';
import 'package:noamooz/Widgets/my_app_bar.dart';

class LoginController extends GetxController {
  RxBool doesAgreeTerms = true.obs;

  RxBool isLogin = false.obs;
  RxBool isWithEmail = false.obs;
  RxBool isRegister = false.obs;
  RxBool isForgot = false.obs;
  RxBool isLoading = false.obs;
  RxBool getFingerprint = false.obs;
  final RxBool canSendAgain = false.obs;
  RxInt sendAgainTimer = 59.obs;
  Timer? timer;
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  FocusNode mobileFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode codeFocusNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  final RxBool emailValid = false.obs;

  TextEditingController passwordController = TextEditingController();

  String refer = RoutingUtils.main.name;


  @override
  void onInit() {
    refer = Get.parameters['refer'] ?? RoutingUtils.main.name;
    print(refer);
    startLoginRegister();
    super.onInit();
  }

  // methods

  void startLoginRegister() async {
    if (mobileController.text.length == 11) {}
  }

  void onChange(String string) {
    List<String> list = string.split('');
    if (list.isNotEmpty) {
      switch (list.length) {
        case 1:
          if (list[0] == '0') {
            mobileController.text = '0';
          } else {
            mobileController.clear();
          }
          break;
        case 2:
          if (list[1] == '9') {
            mobileController.text = '09';
          } else {
            mobileController.text = '0';
          }

          break;
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        case 10:
        case 11:
          list.removeAt(0);
          list.removeAt(0);
          mobileController.text = '09${list.join('')}';
          break;
      }
      if (mobileController.text.length == 11) {
        submit();
      } else {
        Future.delayed(
          Duration.zero,
          () => mobileController.selection = TextSelection.fromPosition(
            TextPosition(
              offset: mobileController.text.length,
            ),
          ),
        );
      }
    }
  }

  void submit() {
    if (!EasyLoading.isShow) {
      if (isForgot.value == true) {
        forgot();
      } else if (isRegister.value == true) {
        register();
      } else if (isLogin.value == true) {
        login();
      } else {
        start();
      }
    }
  }

  @override
  void onClose() {
    close();
    super.onClose();
  }

  void register() async {
    if (codeController.text.length != 4) {
      ViewUtils.showErrorDialog(
        "لطفا کد تایید را به صورت کامل وارد کنید (۴ رقم)",
      );
      return;
    }
    isLoading.value = true;
    ApiResult result = await RequestsUtil.instance.auth.validate(
      mobileEmail: isWithEmail.isTrue ? emailController.text : mobileController.text,
      code: codeController.text,
    );

    isLoading.value = false;
    if (result.isDone) {
      Get.dialog(
        Directionality(
          textDirection: TextDirection.rtl,
          child: CompleteRegister(
            mobile: isWithEmail.isTrue ? emailController.text : mobileController.text,
            code: codeController.value.text,
            controller: this,
          ),
        ),

        barrierColor: Colors.black.withOpacity(0.8),
        barrierDismissible: true,
      );
    } else {
      ViewUtils.showErrorDialog(
        result.data.toString(),
      );
    }
  }

  void login() async {
    if (passwordController.text.isEmpty) {
      ViewUtils.showErrorDialog(
        "لطفا رمز عبور را به درستی وارد کنید",
      );
      return;
    }
    isLoading.value = true;

    ApiResult result = await RequestsUtil.instance.auth.login(
      mobile: isWithEmail.isTrue ? emailController.text : mobileController.text,
      password: passwordController.text,
    );
    isLoading.value = false;
    if (result.isDone) {
      ViewUtils.showSuccessDialog(
        "به noamooz خوش آمدید",
      );

      FocusScope.of(context).requestFocus(FocusNode());

      await StorageUtils.setToken(result.data['token']);

      Globals.userStream.changeUser(UserModel.fromJson(
        result.data['user'],
      ));
      Future.delayed(const Duration(seconds: 3), () {
        toMainPage();
      });
    } else {
      ViewUtils.showErrorDialog(
        result.data['message'].toString(),
      );
    }
  }

  void start() async {
    if (isWithEmail.isFalse && mobileController.text.length != 11) {
      ViewUtils.showErrorDialog(
        "لطفا موبایل را به درستی وارد کنید",
      );
      return;
    }
    if (isWithEmail.isTrue && emailValid.isFalse){
      ViewUtils.showErrorDialog(
        "لطفا ایمیل را به درستی وارد کنید",
      );
      return;
    }
    isLoading.value = true;
    ApiResult result = await RequestsUtil.instance.auth.init(
      mobileEmail: isWithEmail.isTrue ? emailController.text.trim() : mobileController.text,
      isEmail: isWithEmail.isTrue ? 1 : 0,
    );
    isLoading.value = false;
    if (result.isDone) {
      isLogin.value = result.data['type'] == 'login';
      if (isLogin.value) {
        passwordNode.requestFocus();
      }
      isRegister.value = result.data['type'] == 'register';
      if (isRegister.value == true) {
        codeFocusNode.requestFocus();
        setTimer();
      }
      ViewUtils.showSuccessDialog(
        result.data?['message'],
        time: 1,
      );
    } else {
      ViewUtils.showErrorDialog(
        result.data?['message'],
      );
    }
  }

  void forgotPassword() async {
    if (isWithEmail.isFalse && mobileController.text.length != 11) {
      ViewUtils.showErrorDialog(
        "لطفا موبایل را به درستی وارد کنید",
      );
      return;
    }
    if (isWithEmail.isTrue && emailValid.isFalse){
      ViewUtils.showErrorDialog(
        "لطفا ایمیل را به درستی وارد کنید",
      );
      return;
    }
    isLoading.value = true;
    ApiResult result = await RequestsUtil.instance.auth.forgotPassword(
      mobileEmail: isWithEmail.isTrue ? emailController.text.trim() : mobileController.text,
      isEmail: isWithEmail.isTrue ? 1 : 0,
    );
    isLoading.value = false;

    if (result.isDone) {
      isForgot.value = true;
      codeFocusNode.requestFocus();
      isLogin.value = false;
      isRegister.value = false;
      setTimer();
    } else {
      ViewUtils.showErrorDialog(
        result.data['message'],
      );
    }
  }

  void forgot() async {
    isLoading.value = true;
    ApiResult result = await RequestsUtil.instance.auth.validate(
      mobileEmail: isWithEmail.isTrue ? emailController.text : mobileController.text,
      code: codeController.text,
    );
    isLoading.value = false;

    if (result.isDone) {
      if (result.data['type'] == 'login') {
        ViewUtils.showSuccessDialog(
          "رمز عبور جدید شما: ${codeController.text}",
        );
        Globals.userStream.changeUser(UserModel.fromJson(
          result.data['user'],
        ));

        FocusScope.of(context).requestFocus(FocusNode());

        await StorageUtils.setToken(result.data['token']);
        Future.delayed(const Duration(seconds: 2), () {
          toMainPage();
        });
      } else {
        Get.dialog(
          Directionality(
            textDirection: TextDirection.rtl,
            child: CompleteRegister(
              mobile: isWithEmail.isTrue ? emailController.text : mobileController.text,
              code: codeController.value.text,
              controller: this,
            ),
          ),

          barrierColor: Colors.black.withOpacity(0.8),
          barrierDismissible: true,
        );
      }
    } else {
      ViewUtils.showErrorDialog(
        result.data['message'].toString(),
      );
    }
  }

  void toMainPage() async {
    bool test = Get.isRegistered<MainGetxController>();
    if (test) {
      MainGetxController controller = Get.find<MainGetxController>();
      controller.currentIndex = 0;
      controller.update();
    } else {
      Get.offAllNamed(
        RoutingUtils.main.name,
      );
      if (refer != RoutingUtils.main.name) {
        Get.toNamed(
          refer,
        );
      }
    }
  }

  void setTimer() async {
    canSendAgain.value = false;
    sendAgainTimer.value = 59;
    if (timer?.isActive == true) {
      timer?.cancel();
    }
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      sendAgainTimer.value = 59 - timer.tick;
      if (sendAgainTimer.value == 0) {
        canSendAgain.value = true;
        this.timer?.cancel();
      }
    });
  }

  void sendAgain() {
    forgotPassword();
  }

  void close() {
    isForgot.value = false;
    isRegister.value = false;
    isLogin.value = false;

    timer?.cancel();
    mobileController.clear();
    codeController.clear();
    passwordController.clear();
  }


  void onEmailChange(String string) {
    emailValid.value = string.isEmail;
  }
}
