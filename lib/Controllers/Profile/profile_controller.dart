import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noamooz/Globals/Globals.dart';
import 'package:noamooz/Models/Locations/locations_model.dart';
import 'package:noamooz/Models/user_model.dart';
import 'package:noamooz/Plugins/get/get.dart';
import 'package:noamooz/Plugins/my_dropdown/dropdown_controller.dart';
import 'package:noamooz/Utils/Api/project_request_utils.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Utils/widget_utils.dart';
import 'package:noamooz/Widgets/Components/choose_source_alert.dart';
import 'package:noamooz/Widgets/form_utils.dart';

class ProfileController extends GetxController {
  final MyTextController nameController = MyTextController();
  final MyTextController lastNameController = MyTextController();
  final MyTextController emailController = MyTextController();
  final MyTextController mobile2Controller = MyTextController();
  final MyTextController mobileController = MyTextController();
  final MyTextController nationalController = MyTextController();
  final MyTextController addressController = MyTextController();
  final MyTextController educationStage = MyTextController();
  final MyTextController educationType = MyTextController();
  final MyTextController telephone1Controller = MyTextController();
  final MyTextController birthdateController = MyTextController();

  final DropdownController statesController = DropdownController();
  final DropdownController cityController = DropdownController();

  final ScrollController scrollController = ScrollController();
  final RxDouble scrollOffset = (-0.1).obs;

  final RxBool isImageLoading = false.obs;
  final RxString gender = "آقا".obs;

  void fetchStates() async {
    statesController.loading();

    ApiResult result = await RequestsUtil.instance.pages.states();
    if (result.isDone) {
      statesController.items = StateModel.listFromJson(result.data);
      scrollOffset.value = 0;
    }
    statesController.loaded();
    if (Globals.userStream.user!.state is StateModel) {
      statesController.onChange(Globals.userStream.user!.state!);
    }
  }

  void fetchCities() async {
    cityController.loading();
    ApiResult result = await RequestsUtil.instance.pages.cities(
      statesController.value.dropdownId(),
    );
    if (result.isDone) {
      cityController.items = CityModel.listFromJson(result.data);
    }
    cityController.loaded();
    if (Globals.userStream.user!.city is CityModel) {
      cityController.onChange(Globals.userStream.user!.city!);
    }
  }

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void save() async {
    double offsetToScroll = 0;
    if (cityController.isSelected.isFalse) {
      cityController.hasError.value = true;
      offsetToScroll = Get.height / 2.7 + (Get.height / 9.5) * 4;
    }
    if (statesController.isSelected.isFalse) {
      statesController.hasError.value = true;
      offsetToScroll = Get.height / 2.7 + (Get.height / 10) * 3;
    }

    birthdateController.hasError.value =
        birthdateController.text.trim().length < 3;
    if (birthdateController.hasError.isTrue) {
      birthdateController.hasError.value = true;
      offsetToScroll = Get.height / 2.7 + (Get.height / 9) * 5;
    }

    birthdateController.hasError.value =
        birthdateController.text.trim().length < 3;
    if (birthdateController.hasError.isTrue) {
      birthdateController.hasError.value = true;
      offsetToScroll = Get.height / 2.7 + (Get.height / 9) * 5;
    }
    //
    // educationType.hasError.value = educationType.text.trim().length < 3;
    // if (educationType.hasError.isTrue) {
    //   educationType.hasError.value = true;
    //   offsetToScroll = Get.height / 2.7 + (Get.height / 9) * 5;
    // }
    // educationStage.hasError.value = educationStage.text.trim().length < 3;
    // if (educationStage.hasError.isTrue) {
    //   educationStage.hasError.value = true;
    //   offsetToScroll = Get.height / 2.7 + (Get.height / 9) * 5;
    // }
    //
    // if (!emailController.text.trim().isEmail) {
    //   emailController.hasError.value = true;
    //   offsetToScroll = Get.height / 2.7 + (Get.height / 10) * 2;
    // }
    lastNameController.hasError.value =
        lastNameController.text.trim().length < 3;
    if (lastNameController.hasError.isTrue) {
      offsetToScroll = Get.height / 2.7 + Get.height / 10;
    }
    nameController.hasError.value = nameController.text.trim().length < 3;
    if (nameController.hasError.isTrue) {
      nameController.hasError.value = true;
      offsetToScroll = Get.height / 2.7;
    }

    if (offsetToScroll > 0) {
      scrollController.animateTo(
        offsetToScroll.toDouble(),
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeIn,
      );
    } else {
      EasyLoading.show();
      ApiResult result = await RequestsUtil.instance.auth.updateProfile(
        firstName: nameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
        mobile2: mobile2Controller.text.trim(),
        national: nationalController.text.trim(),
        gender: gender.value == "آقا" ? 1 : 2,
        studyField: educationType.text.trim(),
        stateId: statesController.value.dropdownId(),
        cityId: cityController.value.dropdownId(),
        studyDegree: educationStage.text.trim(),
        birthdate: birthdateController.text.trim(),
      );
      EasyLoading.dismiss();
      if (result.isDone) {
        ViewUtils.showSuccessDialog("ذخیره اطلاعات با موفقیت انجام شد");
        UserModel userModel = UserModel.fromJson(
          result.data['user'],
        );
        Globals.userStream.changeUser(userModel);
        fillUserInfo();
      }
    }
  }

  void changeProfile() async {
    XFile? file = await Get.dialog(
      const ChooseSourceAlert(
        y: 4,
        x: 4,
        lockAspectRatio: true,
      ),
      barrierColor: ColorUtils.black.withOpacity(0.5),
    );
    if (file is XFile) {
      isImageLoading.value = true;
      ApiResult result = await RequestsUtil.instance.auth.updateImage(file);
      isImageLoading.value = false;
      if (result.isDone) {
        Globals.userStream.user!.avatar = result.data['path'];
        Globals.userStream.sync();
      }
    }
  }

  Future<void> fillUserInfo() async {
    UserModel user = Globals.userStream.user!;
    nameController.text = user.firstName;
    lastNameController.text = user.lastName;
    birthdateController.text = user.birthdate;
    emailController.text = user.email ?? "";
    mobile2Controller.text = user.mobile2 ?? "";
    mobileController.text = user.mobile ?? "";
    nationalController.text = user.national ?? "";
    educationType.text = user.studyField ?? "";
    educationStage.text = user.studyDegree ?? "";
    if (user.state is StateModel) {
      statesController.onChange(user.state!);
    }
    if (user.city is CityModel) {
      cityController.onChange(user.city!);
    }
    gender.value = user.gender == 1 ? "آقا" : "خانم";
  }

  void init() async {
    await fillUserInfo();
    fetchStates();
    if (Globals.userStream.user?.state == null) {
      Get.dialog(
        AlertDialog(
          backgroundColor: ColorUtils.white,
          title: Text(
            "هشدار تکمیل اطلاعات",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ColorUtils.black,
              fontSize: 16,
            ),
          ),
          content: Row(
            children: [
              Expanded(
                child: Text(
                  "لطفا اطلاعات خود را تکمیل نمایید تا امکان استفاده از سایر قابلیت های اپلیکیشن برای شما فعال شود",
                  style: TextStyle(
                    fontSize: 12,
                    color: ColorUtils.black.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            WidgetUtils.softButton(
              title: "متوجه شدم",
              widthFactor: 3.5,
              onTap: () => Get.back(
                result: true,
              ),
            ),
          ],
        ),
      );
    }
    scrollController.addListener(() {
      scrollOffset.value = scrollController.offset;
    });
  }
}
