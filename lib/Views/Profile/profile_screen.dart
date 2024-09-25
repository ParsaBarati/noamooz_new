import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:noamooz/Controllers/Profile/profile_controller.dart';
import 'package:noamooz/Globals/Globals.dart';
import 'package:noamooz/Plugins/datepicker/persian_datetime_picker.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Utils/widget_utils.dart';
import 'package:noamooz/Widgets/form_utils.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../Plugins/get/get.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: StreamBuilder(
          stream: Globals.userStream.getStream,
          builder: (context, snapshot) {
            print(Globals.userStream.user!.avatar);
            return Scaffold(
              appBar: buildAppBar(),
              body: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: Get.width,
                    height: Get.height,
                    decoration: BoxDecoration(
                      color: ColorUtils.orange,
                    ),
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/img/galaxy.png',
                                color: ColorUtils.black.withOpacity(0.1),
                              ),
                              Image.asset(
                                'assets/img/galaxy.png',
                                color: ColorUtils.black.withOpacity(0.1),
                              ),
                              Image.asset(
                                'assets/img/galaxy.png',
                                color: ColorUtils.black.withOpacity(0.1),
                              ),
                              Image.asset(
                                'assets/img/galaxy.png',
                                color: ColorUtils.black.withOpacity(0.1),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => AnimatedPositioned(
                      duration: const Duration(milliseconds: 50),
                      top: Get.height / 12 - controller.scrollOffset.value,
                      child: Container(
                        width: Get.width,
                        height: Get.height * 2,
                        decoration: BoxDecoration(
                          color: ColorUtils.white,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                  buildForm(),
                  Obx(
                    () => AnimatedSwitcher(
                      duration: const Duration(milliseconds: 150),
                      child: controller.scrollOffset.value >=
                              (controller.scrollController.hasClients &&
                                          controller.scrollOffset.value != -0.1
                                      ? controller.scrollController.position
                                          .maxScrollExtent
                                      : 0) -
                                  Get.height / 24 -
                                  Get.height / 48
                          ? Container()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                WidgetUtils.softButton(
                                  title: "ذخیره تغییرات پروفایل",
                                  onTap: () => controller.save(),
                                  widthFactor: 1.5,
                                  color: ColorUtils.green,
                                ),
                                ViewUtils.sizedBox(48),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      elevation: 0,
      toolbarHeight: 50,
      shadowColor: ColorUtils.orange,
      backgroundColor: ColorUtils.white,
      foregroundColor: ColorUtils.black,
      leadingWidth: 40,
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
        "حساب کاربری",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: ColorUtils.black,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget buildAvatar() {
    return GestureDetector(
      onTap: () => controller.changeProfile(),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Obx(
            () => AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: Get.width / 3,
              height: Get.width / 3,
              decoration: BoxDecoration(
                color: ColorUtils.black,
                image: Globals.userStream.user!.avatar.isNotEmpty &&
                        controller.isImageLoading.isFalse
                    ? DecorationImage(
                        image: NetworkImage(
                          "${Globals.userStream.user!.avatar}?t=${DateTime.now()}",
                        ),
                        fit: BoxFit.cover,
                      )
                    : null,
                border: Border.all(
                  color: ColorUtils.white,
                  width: 5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorUtils.gray.withOpacity(0.1),
                    spreadRadius: 3.0,
                    blurRadius: 12.0,
                  ),
                ],
                shape: BoxShape.circle,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: controller.isImageLoading.isTrue
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Globals.userStream.user!.avatar.isNotEmpty
                        ? Container()
                        : Icon(
                            Iconsax.user,
                            color: ColorUtils.orange,
                            size: Get.width / 5,
                          ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: ColorUtils.orange,
              boxShadow: [
                BoxShadow(
                  color: ColorUtils.orange.withOpacity(0.4),
                  spreadRadius: 3.0,
                  blurRadius: 12.0,
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Iconsax.edit,
                color: ColorUtils.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SingleChildScrollView(
        controller: controller.scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ViewUtils.sizedBox(24),
            buildAvatar(),
            ViewUtils.sizedBox(48),
            FormUtils.input(
              title: "نام",
              hint: "نام خود را وارد کنید",
              controller: controller.nameController,
              errorText: "لطفا نام خود را وارد کنید",
              onChange: (String name) {
                controller.nameController.hasError.value = name.length <= 3;
              },
            ),
            FormUtils.input(
              title: "نام خانوادگی",
              hint: "نام خانوادگی خود را وارد کنید",
              controller: controller.lastNameController,
              errorText: "لطفا نام خانوادگی خود را وارد کنید",
              onChange: (String lastName) {
                controller.lastNameController.hasError.value =
                    lastName.length <= 3;
              },
            ),

            FormUtils.input(
              title: "کد ملی",
              hint: "کد ملی خود را وارد کنید",
              controller: controller.nationalController,
              errorText: "لطفا کد ملی خود را به صورت صحیح وارد کنید",
              onChange: (String code) {
                controller.nationalController.hasError.value =
                    code.length < 10 || !code.isValidIranianNationalCode();
              },
            ),
            FormUtils.input(
              title: "شماره تماس 2",
              hint: "شماره تماس جهت برقراری ارتباط در صورت دردسترس نبودن شماره اصلی.",
              controller: controller.mobile2Controller,
              errorText: "لطفا شماره اضطراری خود را وارد کنید",
              onChange: (String value) {
                controller.mobile2Controller.hasError.value = value.length != 11;
              },
            ),
            FormUtils.radio(
              title: "جنسیت",
              texts: ["خانم", "آقا"],
              icon: Iconsax.man,
              value: controller.gender,
            ),
            FormUtils.input(
              title: "شماره موبایل",
              hint: 'شماره موبایل خود را وارد کنید',
              enabled: Globals.userStream.user!.mobile.isEmpty,
              controller: controller.mobileController,
              errorText: "لطفا شماره موبایل را به صورت صحیح وارد کنید.",
              onChange: (String code) {
                controller.mobileController.hasError.value = code.length != 11;
              },
            ),
            FormUtils.select(
              title: "انتخاب استان محل سکونت",
              hint: "استان خود را انتخاب کنید",
              controller: controller.statesController,
              icon: Iconsax.location,
              errorText: "لطفا استان را انتخاب کنید",
              onChange: (state) => controller.fetchCities(),
            ),
            FormUtils.select(
              title: "انتخاب شهر",
              info:
              "بعد از انتخاب استان شما میتوانید شهر محل سکونت خود را به راحتی انتخاب کنید",
              hint: "شهر خود را انتخاب کنید",
              icon: Iconsax.location,
              errorText: "لطفا شهر مربوط به تابلو را انتخاب کنید",
              controller: controller.cityController,
            ),
            FormUtils.input(
              title: "آدرس ایمیل",
              hint: "آدرس ایمیل را وارد کنید",
              enabled: Globals.userStream.user!.email.isEmpty,
              controller: controller.emailController,
              errorText: "لطفا آدرس ایمیل را به صورت صحیح وارد کنید.",
              onChange: (String code) {
                controller.emailController.hasError.value = !code.isEmail;
              },
            ),
            FormUtils.input(
              title: "رشته تحصیلی",
              hint: "مهندسی برق، هنر یا ....",
              controller: controller.educationType,
              errorText: "لطفا رشته تحصیلی خود را وارد کنید",
              onChange: (String value) {
                controller.educationType.hasError.value = value.length < 3;
              },
            ),
            FormUtils.input(
              title: "مقطع تحصیلی",
              hint: "دیپلم، لیسانس یا ...",
              controller: controller.educationStage,
              errorText: "لطفا مقطع تحصیلی خود را وارد کنید",
              onChange: (String value) {
                controller.educationStage.hasError.value = value.length < 3;
              },
            ),
            FormUtils.datePicker(
              title: "تاریخ تولد",
              hint: "مثال: 1350/1/1",
              fromDate: Jalali(1300, 1, 1),
              toDate: Jalali(
                Jalali.now().year - 18,
              ),
              controller: controller.birthdateController,
              errorText: "لطفا تاریخ تولد خود را وارد کنید",
              onChange: (String value) {
                controller.birthdateController.hasError.value =
                    value.length <= 3;
              },
            ),
            ViewUtils.sizedBox(96),
            WidgetUtils.softButton(
              title: "ذخیره تغییرات پروفایل",
              onTap: () => controller.save(),
              widthFactor: 1.5,
              color: ColorUtils.green,
            ),
            ViewUtils.sizedBox(12),
          ],
        ),
      ),
    );
  }
}
