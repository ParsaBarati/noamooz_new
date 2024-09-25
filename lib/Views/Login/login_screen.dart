import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:noamooz/Controllers/Login/login_controller.dart';
import 'package:noamooz/Plugins/get/get.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Utils/widget_utils.dart';
import 'package:noamooz/Views/Terms/terms_dialog.dart';
import 'package:noamooz/Widgets/Components/bezier_container.dart';
import 'package:noamooz/Widgets/Components/circles.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.put(
    LoginController(),
  );

  LoginScreen({Key? key}) : super(key: key);

  List backGroundItems() {
    return [
      AnimatedPositioned(
        duration: const Duration(milliseconds: 100),
        right: Get.width / 1.4,
        top: Get.height / 2,
        child: Transform.rotate(
          angle: 3,
          child: BezierContainer(
            color: ColorUtils.yellow.withOpacity(0.1),
          ),
        ),
      ),
      // AnimatedPositioned(
      //   duration: const Duration(milliseconds: 100),
      //   right: Get.width / 1.5,
      //   top: Get.height / 1.5,
      //   child: Image.asset('assets/img/space.png'),
      // ),

      AnimatedPositioned(
        duration: const Duration(milliseconds: 100),
        top: Get.height / 1.4,
        left: Get.width / 2,
        child: Transform.rotate(
          angle: 8,
          child: BezierContainer(
            color: ColorUtils.orange.withOpacity(0.2),
          ),
        ),
      ),
      AnimatedPositioned(
        duration: const Duration(milliseconds: 100),
        right: Get.width / 0.85,
        top: Get.height / 6,
        child: CustomPaint(
          painter: CircleOne(
            ColorUtils.orange.withOpacity(0.1),
          ),
        ),
      ),
      AnimatedPositioned(
        duration: const Duration(milliseconds: 100),
        right: Get.width / 1.15,
        top: Get.height / 6,
        child: CustomPaint(
          painter: CircleTwo(
            ColorUtils.gray.withOpacity(0.1),
          ),
        ),
      ),
      // AnimatedPositioned(
      //   duration: const Duration(milliseconds: 100),
      //   right: Get.width / 1.2,
      //   top: Get.height / 12,
      //   child: Image.asset('assets/img/asteroid.png'),
      // ),

      AnimatedPositioned(
        duration: const Duration(milliseconds: 100),
        left: Get.width / 1,
        top: Get.height / 1.2,
        child: CustomPaint(
          painter: CircleTwo(
            ColorUtils.gray.withOpacity(0.1),
          ),
        ),
      ),
      AnimatedPositioned(
        duration: const Duration(milliseconds: 100),
        left: Get.width / 0.9,
        top: Get.height / 4,
        child: CustomPaint(
          painter: CircleOne(
            ColorUtils.yellow.withOpacity(
              0.2,
            ),
          ),
        ),
      ),
      AnimatedPositioned(
        duration: const Duration(milliseconds: 100),
        left: Get.width / 0.92,
        top: Get.height / 4,
        child: CustomPaint(
          painter: CircleOne(
            ColorUtils.yellow.withOpacity(
              0.05,
            ),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Scaffold(
            backgroundColor: ColorUtils.white,
          ),
          ...backGroundItems(),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: buildBody(),
          ),
        ],
      ),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ViewUtils.sizedBox(3),
          // Image.asset(
          //   'assets/img/logo.png',
          //   width: Get.width / 2,
          //   fit: BoxFit.fill,
          // ),
          AutoSizeText(
            "ورود / ثبت نام",
            style: TextStyle(
              fontSize: 36.0,
              color: ColorUtils.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          ViewUtils.sizedBox(),
          DefaultTabController(
            length: 2,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TabBar(
                    onTap: (index) {
                      controller.isWithEmail.value = index == 1;
                    },
                    tabs: [
                      Tab(
                        text: "شماره موبایل",
                      ),
                      Tab(
                        text: "ایمیل",
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                SizedBox(
                  height: Get.height / 16,
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Column(
                        children: [
                          mobileInput(),
                        ],
                      ),
                      Column(
                        children: [
                          emailInput(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Obx(() {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  child: child,
                );
              },
              child: controller.isLogin.isTrue
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Center(
                        child: Column(
                          children: [
                            passwordInput(),
                            SizedBox(
                              height: Get.height / 96,
                            ),
                            SizedBox(
                              width: Get.width / 1,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    child: Text(
                                      "رمز عبور خود را فرموش کرده ام",
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color:
                                            ColorUtils.black.withOpacity(0.7),
                                      ),
                                    ),
                                    onTap: () => controller.forgotPassword(),
                                  ),
                                ],
                              ),
                            ),
                            ViewUtils.sizedBox(48),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            );
          }),
          Obx(
            () => AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  child: child,
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Center(
                  child: Column(
                    children: [
                      if (controller.isRegister.isTrue ||
                          controller.isForgot.isTrue) ...[
                        codeInput(),
                        ViewUtils.sizedBox(96),
                      ],
                      SizedBox(
                        width: Get.width / 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const SizedBox(
                                  width: 8,
                                ),
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Checkbox(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    shape: const CircleBorder(),
                                    side: BorderSide(
                                      width: 1,
                                      color: ColorUtils.black,
                                    ),
                                    splashRadius: 1,
                                    fillColor: MaterialStatePropertyAll(
                                      ColorUtils.orange.shade500,
                                    ),
                                    value: controller.doesAgreeTerms.value,
                                    onChanged: (bool? val) {
                                      controller.doesAgreeTerms.value = val!;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    bool? accept = await Get.dialog(
                                      TermsDialog(),
                                      barrierColor:
                                          Colors.black.withOpacity(0.7),
                                    );
                                    controller.doesAgreeTerms.value =
                                        accept == true;
                                    // Focus.of(Get.context!)
                                    //     .requestFocus(FocusNode());
                                  },
                                  child: Text(
                                    "قوانین و مقررات را می پذیرم",
                                    style: TextStyle(
                                      color: ColorUtils.blue,
                                      decoration: TextDecoration.underline,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            if (controller.isRegister.isTrue ||
                                controller.isForgot.isTrue) ...[
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 150),
                                child: controller.canSendAgain.isFalse
                                    ? Text(
                                        "${controller.sendAgainTimer} ثانیه تا ارسال مجدد",
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color:
                                              ColorUtils.black.withOpacity(0.7),
                                        ),
                                      )
                                    : GestureDetector(
                                        child: Text(
                                          "ارسال مجدد",
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: ColorUtils.black
                                                .withOpacity(0.7),
                                          ),
                                        ),
                                        onTap: () => controller.sendAgain(),
                                      ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Get.height / 48,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Obx(
                    () => button(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget mobileInput() {
    return Obx(
      () => controller.isLogin.value == true ||
              controller.isRegister.value == true ||
              controller.isForgot.value == true
          ? Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: ColorUtils.white,
                  boxShadow: [
                    BoxShadow(
                      color: ColorUtils.gray.withOpacity(0.1),
                      spreadRadius: 1.0,
                      blurRadius: 12.0,
                    ),
                  ]),
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: () {
                    controller.isLogin.value = false;
                    controller.isRegister.value = false;
                    controller.isForgot.value = false;
                    controller.passwordController.clear();
                    controller.codeController.clear();
                    controller.mobileFocusNode.requestFocus();
                  },
                  borderRadius: BorderRadius.circular(10.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ColorUtils.orange,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Icon(
                              Ionicons.pencil_outline,
                              size: 17.0,
                              color: ColorUtils.orange,
                            ),
                          ),
                        ),
                        Text(
                          controller.mobileController.value.text,
                          style: TextStyle(
                            color: ColorUtils.black,
                            letterSpacing: 2,
                            fontSize: 17.0,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Icon(
                              Icons.edit,
                              size: 17.0,
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: WidgetUtils.textField(
                focusNode: controller.mobileFocusNode,
                controller: controller.mobileController,
                onChanged: controller.onChange,
                textAlign: TextAlign.center,
                letterSpacing: 2,
                formatter: [
                  LengthLimitingTextInputFormatter(11),
                ],
                keyboardType: TextInputType.phone,
                title: "شماره موبایل",
              ),
            ),
    );
  }

  Widget emailInput() {
    return Obx(
      () => controller.isLogin.value == true ||
              controller.isRegister.value == true ||
              controller.isForgot.value == true
          ? Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: ColorUtils.white,
                  boxShadow: [
                    BoxShadow(
                      color: ColorUtils.gray.withOpacity(0.1),
                      spreadRadius: 1.0,
                      blurRadius: 12.0,
                    ),
                  ]),
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: () {
                    controller.isLogin.value = false;
                    controller.isRegister.value = false;
                    controller.isForgot.value = false;
                    controller.passwordController.clear();
                    controller.codeController.clear();
                    controller.mobileFocusNode.requestFocus();
                  },
                  borderRadius: BorderRadius.circular(10.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ColorUtils.orange,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Icon(
                              Ionicons.pencil_outline,
                              size: 17.0,
                              color: ColorUtils.orange,
                            ),
                          ),
                        ),
                        Text(
                          controller.emailController.value.text,
                          style: TextStyle(
                            color: ColorUtils.black,
                            letterSpacing: 1,
                            fontSize: 14.0,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Icon(
                              Icons.edit,
                              size: 17.0,
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: WidgetUtils.textField(
                focusNode: controller.emailFocusNode,
                controller: controller.emailController,
                onChanged: controller.onEmailChange,
                textAlign: TextAlign.center,
                letterSpacing: 2,
                valid: controller.emailValid.value,
                keyboardType: TextInputType.emailAddress,
                title: "ایمیل",
              ),
            ),
    );
  }

  Widget passwordInput() {
    return WidgetUtils.textField(
      focusNode: controller.passwordNode,
      controller: controller.passwordController,
      letterSpacing: 0,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.visiblePassword,
      title: "رمز عبور",
    );
  }

  Widget codeInput() {
    return WidgetUtils.textField(
      focusNode: controller.codeFocusNode,
      controller: controller.codeController,
      letterSpacing: 0,
      textAlign: TextAlign.center,
      formatter: [
        LengthLimitingTextInputFormatter(4),
      ],
      onChanged: (String string) {
        if (string.length > 3) {
          controller.submit();
        }
      },
      keyboardType: TextInputType.number,
      title: "کد تایید",
    );
  }

  Widget button() {
    return WidgetUtils.softButton(
      enabled: controller.mobileController.value.text.length == 11,
      title: controller.isLogin.value == true ? "ورود" : "مرحله بعد",
      loading: controller.isLoading,
      onTap: () => controller.submit(),
      widthFactor: 1,
    );
  }
}
