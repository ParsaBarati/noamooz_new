import 'package:noamooz/Plugins/get/get.dart';
import 'package:noamooz/Plugins/my_dropdown/dropdown_controller.dart';
import 'package:noamooz/Plugins/my_dropdown/dropdown_item_model.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../Plugins/datepicker/persian_datetime_picker.dart';

class FormUtils {
  static Widget select({
    required String title,
    required String hint,
    String errorText = "لطفا این مورد را انتخاب کنید",
    String? info,
    required DropdownController controller,
    IconData? icon,
    void Function(DropDownItemModel)? onChange,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: ColorUtils.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          if (info != null && info.isNotEmpty) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Iconsax.info_circle,
                  color: ColorUtils.textGray,
                  size: 20,
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Text(
                    info,
                    style: TextStyle(
                      color: ColorUtils.textBlack,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(
            height: 8,
          ),
          WidgetUtils.dropdown(
            hint: hint,
            onChange: onChange,
            icon: icon,
            controller: controller,
          ),
          Obx(
            () => AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              child: controller.hasError.isTrue
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Icon(
                              Iconsax.warning_2,
                              color: ColorUtils.red,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              errorText,
                              style: TextStyle(
                                color: ColorUtils.red,
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  : Container(),
            ),
          )
        ],
      ),
    );
  }

  static input({
    required String title,
    String? info,
    bool enabled = true,
    required String hint,
    String errorText = '',
    IconData? icon,
    required MyTextController controller,
    void Function(String)? onChange,
    Widget? button,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: ColorUtils.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (button != null) ...[
                const Spacer(),
                button,
              ]
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          if (info != null && info.isNotEmpty) ...[
            Row(
              children: [
                Icon(
                  Iconsax.info_circle,
                  color: ColorUtils.textGray,
                  size: 20,
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Text(
                    info,
                    style: TextStyle(
                      color: ColorUtils.textGray,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(
            height: 8,
          ),
          Obx(
            () => WidgetUtils.formTextField(
              icon: icon,
              valid: controller.hasError.isTrue ? false : null,
              enabled: enabled,
              title: hint,
              key: controller.key,
              onChanged: onChange,
              keyboardType: controller.keyboardType,
              controller: controller,
            ),
          ),
          Obx(
            () => AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              child: controller.hasError.isTrue
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Icon(
                              Iconsax.warning_2,
                              color: ColorUtils.red,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              errorText,
                              style: TextStyle(
                                color: ColorUtils.red,
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  : Container(),
            ),
          )
        ],
      ),
    );
  }

  static textArea({
    required String title,
    String? info,
    required String hint,
    String errorText = '',
    IconData? icon,
    required MyTextController controller,
    void Function(String)? onChange,
    Color? iconColor,
  }) {
    iconColor ??= ColorUtils.red;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              if (icon is IconData) ...[
                Icon(
                  icon,
                  size: 20,
                  color: iconColor,
                ),
                const SizedBox(
                  width: 4,
                ),
              ],
              Text(
                title,
                style: TextStyle(
                  color: ColorUtils.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Obx(
            () => WidgetUtils.formTextField(
              title: hint,
              controller: controller,
              valid: controller.hasError.isTrue ? false : null,
              maxLines: 6,
              onChanged: onChange,
            ),
          ),
          if (info != null && info.isNotEmpty) ...[
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Icon(
                  Iconsax.info_circle,
                  color: ColorUtils.textWhite,
                  size: 20,
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Text(
                    info,
                    style: TextStyle(
                      color: ColorUtils.textWhite,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ],
          Obx(
            () => AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              child: controller.hasError.isTrue
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Icon(
                              Iconsax.warning_2,
                              color: ColorUtils.red,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              errorText,
                              style: TextStyle(
                                color: ColorUtils.red,
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  : Container(),
            ),
          )
        ],
      ),
    );
  }

  static multiInput({
    required String title,
    required String info,
    required List<String> hints,
    required List<MyTextController> controllers,
    required List<String> labels,
    required IconData icon,
    required String errorText,
    List<void Function(String)> functions = const [],
  }) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: ColorUtils.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          if (info.isNotEmpty) ...[
            Row(
              children: [
                Icon(
                  Iconsax.info_circle,
                  color: ColorUtils.textGray,
                  size: 20,
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Text(
                    info,
                    style: TextStyle(
                      color: ColorUtils.textWhite,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(
            height: 8,
          ),
          Container(
            decoration: BoxDecoration(
              color: ColorUtils.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: ColorUtils.gray.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 12,
                ),
              ],
            ),
            child: Obx(
              () => Row(
                children: controllers
                    .map(
                      (e) => Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: WidgetUtils.formTextField(
                                inline: true,
                                valid: e.hasError.isTrue ? false : null,
                                title: hints[controllers.indexOf(e)],
                                keyboardType: e.keyboardType,
                                controller: e,
                                onChanged:
                                    functions.length > controllers.indexOf(e)
                                        ? functions[controllers.indexOf(e)]
                                        : null,
                                enabled: e.disabled == false,
                                suffix: Container(
                                  decoration: BoxDecoration(
                                    color: ColorUtils.gray.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                  margin: const EdgeInsets.only(
                                    left: 4,
                                  ),
                                  child: Center(
                                    child: Text(
                                      labels[controllers.indexOf(e)],
                                      style: TextStyle(
                                        color: ColorUtils.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          Obx(
            () => AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              child: controllers.any((element) => element.hasError.isTrue)
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Icon(
                              Iconsax.warning_2,
                              color: ColorUtils.red,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              errorText,
                              style: TextStyle(
                                color: ColorUtils.red,
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  : Container(),
            ),
          )
        ],
      ),
    );
  }

  static Widget checkbox({
    required String title,
    required IconData icon,
    required RxBool value,
    required List<String> texts,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: ColorUtils.textGray,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                title,
                style: TextStyle(
                  color: ColorUtils.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            decoration: BoxDecoration(
              color: ColorUtils.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: ColorUtils.gray.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 12,
                ),
              ],
            ),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(10.0),
                onTap: () {
                  value.value = !value.value;
                },
                child: Obx(
                  () => Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: value.isTrue
                                ? ColorUtils.green
                                : Colors.transparent,
                            border: Border.all(
                              color: ColorUtils.green,
                            ),
                          ),
                          child: Center(
                            child: AnimatedSwitcher(
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: child,
                                );
                              },
                              duration: const Duration(milliseconds: 50),
                              child: value.isTrue
                                  ? const Icon(
                                      Ionicons.checkmark_outline,
                                      color: Colors.white,
                                      size: 16,
                                    )
                                  : const Center(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          texts[value.isFalse ? 1 : 0],
                          style: TextStyle(
                            color: ColorUtils.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget radio({
    required String title,
    required IconData icon,
    required Rx<String> value,
    required List<String> texts,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: ColorUtils.black.withOpacity(0.7),
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                title,
                style: TextStyle(
                  color: ColorUtils.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            decoration: BoxDecoration(
              color: ColorUtils.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: ColorUtils.orange.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: texts
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10.0),
                          onTap: () {
                            value.value = e;
                          },
                          child: Obx(
                            () => Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 150),
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      color: value.value == e
                                          ? ColorUtils.orange
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: ColorUtils.orange,
                                      ),
                                    ),
                                    child: Center(
                                      child: AnimatedSwitcher(
                                        transitionBuilder: (Widget child,
                                            Animation<double> animation) {
                                          return ScaleTransition(
                                            scale: animation,
                                            child: child,
                                          );
                                        },
                                        duration:
                                            const Duration(milliseconds: 50),
                                        child: value.value == e
                                            ? const Icon(
                                                Ionicons.checkmark_outline,
                                                color: Colors.white,
                                                size: 16,
                                              )
                                            : const Center(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    e,
                                    style: TextStyle(
                                      color: ColorUtils.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  static Widget datePicker({
    required String title,
    required String errorText,
    required String hint,
    required MyTextController controller,
    void Function(String)? onChange,
    void Function()? onTap,
    Jalali? fromDate,
    Jalali? toDate,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: ColorUtils.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Obx(
            () => WidgetUtils.formTextField(
              icon: Iconsax.calendar_1,
              valid: controller.hasError.isTrue ? false : null,
              title: hint,
              key: controller.key,
              fromDate: fromDate,
              toDate: toDate,
              onChanged: onChange,
              onTap: onTap,
              datePicker: true,
              keyboardType: controller.keyboardType,
              controller: controller,
            ),
          ),
          Obx(
            () => AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              child: controller.hasError.isTrue
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Icon(
                              Iconsax.warning_2,
                              color: ColorUtils.red,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              errorText,
                              style: TextStyle(
                                color: ColorUtils.red,
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  : Container(),
            ),
          )
        ],
      ),
    );
  }

  static Widget price({
    required String title,
    required String hint,
    required String errorText,
    required MyTextController controller,
    void Function(String)? onChange,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: ColorUtils.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Icon(
                Iconsax.info_circle,
                color: ColorUtils.textGray,
                size: 20,
              ),
              const SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  "تمامی قیمت ها به تومان وارد میشوند.",
                  style: TextStyle(
                    color: ColorUtils.textWhite,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Obx(
            () => WidgetUtils.formTextField(
              icon: Iconsax.wallet,
              valid: controller.hasError.isTrue ? false : null,
              title: hint,
              price: true,
              key: controller.key,
              suffix: Container(
                decoration: BoxDecoration(
                  color: ColorUtils.gray.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: const EdgeInsets.only(
                  left: 4,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                child: const Text(
                  "تومان",
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
              ),
              onChanged: (String str) {
                controller.hasError.value = !controller.hasError.value;
                controller.hasError.value = !controller.hasError.value;
                int price = int.tryParse(str.replaceAll(',', '')) ?? 0;
                if (price > 10000000000) {
                  str = price
                      .toString()
                      .substring(0, price.toString().length - 1)
                      .seRagham();
                  controller.text = str;
                }
                onChange?.call(str);
              },
              keyboardType: controller.keyboardType,
              controller: controller,
            ),
          ),
          Obx(
            () => AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              child: controller.hasError.isFalse
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 16,
                            ),
                            Text(
                              "${controller.text.toWord()} تومان",
                              style: TextStyle(
                                color: ColorUtils.textWhite,
                                fontSize: 10,
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  : Container(),
            ),
          ),
          Obx(
            () => AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              child: controller.hasError.isTrue
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Icon(
                              Iconsax.warning_2,
                              color: ColorUtils.red,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              errorText,
                              style: TextStyle(
                                color: ColorUtils.red,
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  : Container(),
            ),
          )
        ],
      ),
    );
  }

  static Widget percent({
    required String title,
    required String hint,
    required String errorText,
    required MyTextController controller,
    void Function(String)? onChange,
    int basePrice = 0,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: ColorUtils.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Icon(
                Iconsax.info_circle,
                color: ColorUtils.textGray,
                size: 20,
              ),
              const SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  "لطفا درصد تخفیف را بدون اعشار وارد کنید.",
                  style: TextStyle(
                    color: ColorUtils.textWhite,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Obx(
            () => WidgetUtils.formTextField(
              icon: Iconsax.wallet,
              valid: controller.hasError.isTrue ? false : null,
              title: hint,
              price: false,
              percent: true,
              key: controller.key,
              suffix: Container(
                decoration: BoxDecoration(
                  color: ColorUtils.gray.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: const EdgeInsets.only(
                  left: 4,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                child: const Text(
                  "%",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onChanged: (String str) {
                controller.hasError.value = !controller.hasError.value;
                controller.hasError.value = !controller.hasError.value;
                onChange?.call(str);
              },
              keyboardType: controller.keyboardType,
              controller: controller,
            ),
          ),
          Obx(
            () {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 100),
                child: controller.hasError.isFalse && basePrice > 0
                    ? Column(
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 16,
                              ),
                              Text(
                                "${((int.tryParse(controller.text) ?? 0) * basePrice / 1000).toString().toWord()} تومان",
                                style: TextStyle(
                                  color: ColorUtils.textWhite,
                                  fontSize: 10,
                                ),
                              )
                            ],
                          ),
                        ],
                      )
                    : Container(),
              );
            },
          ),
          Obx(
            () => AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              child: controller.hasError.isTrue
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Icon(
                              Iconsax.warning_2,
                              color: ColorUtils.red,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              errorText,
                              style: TextStyle(
                                color: ColorUtils.red,
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  : Container(),
            ),
          )
        ],
      ),
    );
  }
}

class MyTextController extends TextEditingController {
  final RxBool hasError = false.obs;
  bool disabled = false;
  TextInputType keyboardType = TextInputType.text;
  void Function(String)? onChange;

  final GlobalKey key = GlobalKey();

  MyTextController({
    this.keyboardType = TextInputType.text,
    this.disabled = false,
    this.onChange,
  });
}
