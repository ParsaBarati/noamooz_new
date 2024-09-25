import 'package:noamooz/Plugins/dropdown/dropdown_button2.dart';
import 'package:noamooz/Plugins/get/get.dart';
import 'package:noamooz/Plugins/my_dropdown/custom_dropdown.dart';
import 'package:noamooz/Plugins/my_dropdown/dropdown_item_model.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/logic_utils.dart';
import 'package:noamooz/Widgets/form_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:shimmer/shimmer.dart';

import '../Plugins/datepicker/persian_datetime_picker.dart';
import '../Plugins/my_dropdown/dropdown_controller.dart';

class WidgetUtils {
  static Widget chip({
    required Widget child,
    required RxBool isSelected,
  }) {
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color: isSelected.isTrue ? ColorUtils.orange : ColorUtils.white,
          borderRadius: BorderRadius.circular(50.0),
          border: Border.all(
            color: ColorUtils.orange,
            width: 1,
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () {
              isSelected.value = !isSelected.value;
            },
            child: child,
          ),
        ),
      ),
    );
  }

  static Widget select<T>({
    required String title,
    required Iterable<T> items,
    required T value,
    required void Function(T) update,
  }) {
    return DropdownButtonFormField2<T>(
      value: items.contains(value) ? value : null,
      textDirection: TextDirection.rtl,
      decoration: InputDecoration(
        //Add isDense true and zero Padding.
        //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
        isDense: true,
        filled: true,
        fillColor: ColorUtils.pink,
        contentPadding: EdgeInsets.zero,
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: ColorUtils.white.withOpacity(0.0),
            width: 0.5,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: ColorUtils.white,
            width: 0.5,
          ),
        ),
        //Add more decoration as you want here
        //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
      ),
      isExpanded: false,
      hint: Text(
        title,
        style: TextStyle(
          fontSize: 28,
          color: ColorUtils.white,
        ),
      ),
      icon: Icon(
        Ionicons.chevron_down_outline,
        size: 20,
        color: ColorUtils.white,
      ),
      iconSize: 30,
      buttonHeight: Get.height / 14,
      buttonPadding: const EdgeInsets.symmetric(
        horizontal: 12.0,
      ),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: ColorUtils.pink,
      ),
      items: items
          .map((item) => DropdownMenuItem<T>(
                value: item,
                child: Text(
                  item.toString(),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 24,
                    color: ColorUtils.white,
                  ),
                ),
              ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return "Please select $title.";
        }
        return null;
      },
      onChanged: (val) {
        value = val as T;

        update(value);
      },
      onSaved: (val) {
        value = val as T;
        update(value);
      },
    );
  }

  static textField({
    String title = '',
    IconData? icon,
    TextEditingController? controller,
    TextAlign textAlign = TextAlign.right,
    TextInputType keyboardType = TextInputType.text,
    void Function(String string)? onChanged,
    FocusNode? focusNode,
    List<TextInputFormatter> formatter = const [],
    double letterSpacing = 1.5,
    bool enabled = true,
    bool? valid,
    int maxLines = 1,
    bool price = false,
    bool percent = false,
    Color? backgroundColor,
    double heightFactor = 21,
    Color? borderColor,
    Color? enabledBorderColor,
    bool password = false,
  }) {
    controller ??= TextEditingController();
    backgroundColor ??= ColorUtils.white;
    enabledBorderColor ??= ColorUtils.orange.withOpacity(0.5);
    return Container(
      height: maxLines == 0
          ? Get.height / heightFactor
          : Get.height / (heightFactor / maxLines),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: backgroundColor,
      ),
      child: TextFormField(
        textAlign: textAlign,
        keyboardType: price ? TextInputType.number : keyboardType,
        controller: controller,
        maxLines: maxLines,
        enabled: enabled,
        focusNode: focusNode,
        cursorColor: ColorUtils.orange,
        obscureText: password,
        textAlignVertical: TextAlignVertical.bottom,
        style: TextStyle(
          color: ColorUtils.black,
          fontSize: 15.0,
          fontFamily: 'iranSans',
          letterSpacing: letterSpacing,
        ),
        inputFormatters: [
          if (percent) LengthLimitingTextInputFormatter(3),
          if (percent || price) FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (String str) {
          if (price) {
            double value = double.parse(str.replaceAll(',', '').trim());
            controller!.text = LogicUtils.moneyFormat(value);
            controller.selection = TextSelection.fromPosition(
              TextPosition(
                offset: controller.text.length,
              ),
            );
          }
          if (percent) {
            double value;
            try {
              value = double.parse(str);
            } catch (e) {
              value = 0;
            }
            if (value > 100) {
              controller!.text = '100';
              controller.selection = TextSelection.fromPosition(
                TextPosition(
                  offset: controller.text.length,
                ),
              );
            }
          }
          if (onChanged != null) onChanged(str);
        },
        decoration: InputDecoration(
          hintText: title,
          hintStyle: TextStyle(
            color: ColorUtils.black.withOpacity(0.7),
            fontSize: 14.0,
            letterSpacing: 0,
            fontFamily: "iranSans",
          ),
          suffixIcon: icon != null
              ? Icon(
                  icon,
                  size: 20,
                  color: ColorUtils.gray,
                )
              : null,
          hintMaxLines: 1,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: borderColor is Color
                  ? borderColor
                  : valid == true
                      ? ColorUtils.green
                      : valid is bool
                          ? ColorUtils.red
                          : ColorUtils.orange.withOpacity(0.8),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              width: 1.5,
              color: borderColor is Color
                  ? borderColor
                  : valid == true
                      ? ColorUtils.green
                      : valid is bool
                          ? ColorUtils.red
                          : enabledBorderColor,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: borderColor is Color
                  ? borderColor
                  : valid == true
                      ? ColorUtils.green
                      : valid is bool
                          ? ColorUtils.red
                          : Colors.grey.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }

  static searchField({
    TextEditingController? controller,
    TextAlign textAlign = TextAlign.right,
    void Function(String string)? onChanged,
    FocusNode? focusNode,
    double letterSpacing = 1.5,
    Color? backgroundColor,
    Color? borderColor,
    Color? enabledBorderColor,
    bool password = false,
  }) {
    controller ??= TextEditingController();
    backgroundColor ??= ColorUtils.white;
    enabledBorderColor ??= ColorUtils.orange.withOpacity(0.5);
    return SizedBox(
      height: Get.height / 21,
      child: TextFormField(
        textAlign: textAlign,
        controller: controller,
        maxLines: 1,
        enabled: true,
        focusNode: focusNode,
        cursorColor: ColorUtils.orange,
        obscureText: password,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          color: ColorUtils.black,
          fontSize: 14.0,
          fontFamily: 'iranSans',
          letterSpacing: letterSpacing,
        ),
        onChanged: (String str) {
          if (onChanged != null) onChanged(str);
        },
        decoration: InputDecoration(
          hintText: 'جستجو...',
          filled: true,
          contentPadding: EdgeInsets.zero,
          fillColor: ColorUtils.white,
          hintStyle: TextStyle(
            color: ColorUtils.black.withOpacity(0.7),
            fontSize: 14.0,
            letterSpacing: 0,
            fontFamily: "iranSans",
          ),
          prefixIcon: Icon(
                  Iconsax.search_normal,
                  size: 20,
                  color: ColorUtils.gray,
                ),
          hintMaxLines: 1,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: ColorUtils.orange,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:const  BorderSide(
              color: Colors.white,
              width: 0,
            )
          ),
        ),
      ),
    );
  }

  static Widget formTextField({
    String title = '',
    IconData? icon,
    TextEditingController? controller,
    TextAlign textAlign = TextAlign.right,
    TextInputType keyboardType = TextInputType.text,
    void Function(String string)? onChanged,
    void Function()? onTap,
    FocusNode? focusNode,
    List<TextInputFormatter> formatter = const [],
    bool enabled = true,
    bool? valid,
    int maxLines = 1,
    GlobalKey? key,
    bool price = false,
    bool percent = false,
    Color? backgroundColor,
    double heightFactor = 21,
    Color? borderColor,
    Color? enabledBorderColor,
    bool password = false,
    bool datePicker = false,
    bool inline = true,
    Jalali? fromDate,
    Jalali? toDate,
    Widget? suffix,
  }) {
    controller ??= MyTextController();
    fromDate ??= Jalali.now();
    toDate ??= Jalali.MAX;
    backgroundColor ??= ColorUtils.white;
    enabledBorderColor ??= ColorUtils.orange.withOpacity(0.3);
    return Container(
      height: maxLines == 1
          ? Get.height / heightFactor
          : Get.height / heightFactor + (maxLines * (14)),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: inline
            ? null
            : [
                BoxShadow(
                  color: ColorUtils.gray.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 12,
                ),
              ],
      ),
      child: TextFormField(
        textAlign: textAlign,
        keyboardType: price ? TextInputType.number : keyboardType,
        controller: controller,
        readOnly: datePicker,
        maxLines: maxLines,
        enabled: enabled,
        focusNode: focusNode,
        onTap: datePicker
            ? () async {
                if (onTap != null) {
                  onTap();
                  return;
                }
                List<String> strings = controller!.text.split('/');
                Jalali? jalali = await showPersianDatePicker(
                  context: Get.context!,
                  initialDate: Jalali(
                    int.tryParse(strings.isNotEmpty ? strings.first : '') ??
                        fromDate!.year,
                    int.tryParse(strings.length >= 2 ? strings[1] : '') ??
                        fromDate!.month,
                    int.tryParse(
                          strings.length >= 3 ? strings.last : '',
                        ) ??
                        fromDate!.day,
                  ),
                  firstDate: fromDate!,
                  lastDate: toDate!,
                );
                if (jalali is Jalali) {
                  controller.text = jalali.formatCompactDate();
                  onChanged?.call(controller.text);
                }
              }
            : null,
        cursorColor: ColorUtils.orange,
        obscureText: password,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          color: ColorUtils.black,
          fontSize: 14.0,
          height: 1.4,
          fontFamily: 'iranSans',
        ),
        inputFormatters: [
          if (percent) LengthLimitingTextInputFormatter(3),
          if (percent || price) FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (String str) {
          if (price) {
            double value = double.tryParse(str.replaceAll(',', '').trim()) ?? 0;
            controller!.text = value.toStringAsFixed(0).seRagham();
            controller.selection = TextSelection.fromPosition(
              TextPosition(
                offset: controller.text.length,
              ),
            );
          }
          if (percent) {
            double value;
            try {
              value = double.parse(str);
            } catch (e) {
              value = 0;
            }
            if (value > 100) {
              controller!.text = '100';
              controller.selection = TextSelection.fromPosition(
                TextPosition(
                  offset: controller.text.length,
                ),
              );
            }
          }
          if (onChanged != null) onChanged(str);
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),

          hintText: title,
          hintStyle: TextStyle(
            color: ColorUtils.black.withOpacity(0.5),
            fontSize: 12.0,
            letterSpacing: 0,
            fontFamily: "iranSans",
          ),
          prefixIcon: icon != null
              ? Icon(
                  icon,
                  size: 20,
                  color: ColorUtils.black.withOpacity(0.7),
                )
              : null,
          suffixIconConstraints: BoxConstraints(
            maxHeight: Get.height / 30,
            maxWidth: Get.width / 8,
          ),
          suffixIcon: suffix,
          hintMaxLines: maxLines,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: borderColor is Color
                  ? borderColor
                  : valid == true
                      ? ColorUtils.green
                      : valid is bool
                          ? ColorUtils.red
                          : ColorUtils.orange,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: valid == null
                  ? ColorUtils.orange.withOpacity(0.3)
                  : valid
                      ? ColorUtils.green
                      : ColorUtils.red,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: valid == null
                  ? ColorUtils.gray.withOpacity(0.3)
                  : valid
                      ? ColorUtils.green
                      : ColorUtils.red,
            ),
          ),
        ),
      ),
    );
  }

  static softButton({
    void Function()? onTap,
    double widthFactor = 4,
    String title = 'تایید',
    bool enabled = true,
    double fontSize = 14.0,
    double height = 0,
    MaterialColor? color,
    IconData? icon,
    bool reverse = false,
    double? letterSpacing,
    FontWeight? fontWeight,
    int radius = 10,
    bool simpleShadow = false,
    Color textColor = Colors.white,
    double iconSize = 25,
    RxBool? loading,
  }) {
    height = (height == 0
        ? (Get.width > 400 ? Get.height / 24 : Get.height / 22)
        : height);
    color ??= ColorUtils.orange;
    loading ??= false.obs;
    return Obx(
      () => Container(
        height: height,
        width: Get.width / widthFactor,
        decoration: BoxDecoration(
          color: color,
          // gradient: simpleShadow == false
          //     ? LinearGradient(
          //   begin: const Alignment(-1.0, -4.0),
          //   end: const Alignment(1.0, 4.0),
          //   colors: [
          //     if (!reverse) ...[
          //       enabled ? color! : color!.withOpacity(0.5),
          //       enabled
          //           ? color.shade600
          //           : color.shade600.withOpacity(0.5),
          //     ],
          //     if (reverse) ...[
          //       enabled
          //           ? color!.shade600
          //           : color!.shade600.withOpacity(0.5),
          //       enabled ? color : color.withOpacity(0.5),
          //     ],
          //   ],
          // )
          //     : null,
          // boxShadow: [
          //   BoxShadow(
          //     color: color!.shade700.withOpacity(0.7),
          //     offset: const Offset(1.0, 1.0),
          //     blurRadius: 6.0,
          //     spreadRadius: 1.0,
          //   ),
          //   BoxShadow(
          //     color: color.withOpacity(0.2),
          //     offset: const Offset(-2.0, -2.0),
          //     blurRadius: 6.0,
          //     spreadRadius: 1.0,
          //   ),
          // ],
          borderRadius: BorderRadius.circular(radius.toDouble()),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: loading!.isTrue
              ? Center(
                  child: SizedBox(
                    height: height - 12,
                    width: height - 12,
                    child: CircularProgressIndicator(
                      color: textColor,
                    ),
                  ),
                )
              : Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(radius.toDouble()),
                    onTap: onTap,
                    child: SizedBox(
                      height: height,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (reverse && icon is IconData) ...[
                            Icon(
                              icon,
                              color: textColor,
                              size: iconSize,
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                          ],
                          Text(
                            title,
                            style: TextStyle(
                              color: textColor,
                              letterSpacing: letterSpacing,
                              fontWeight: fontWeight,
                              fontSize: fontSize,
                            ),
                          ),
                          if (!reverse && icon is IconData) ...[
                            const SizedBox(
                              width: 8.0,
                            ),
                            Icon(
                              icon,
                              color: textColor,
                              size: iconSize,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  static smallSoftButton({
    void Function()? onTap,
    double widthFactor = 4,
    String title = 'تایید',
    bool enabled = true,
    double fontSize = 12.0,
    double height = 0,
    MaterialColor? color,
    IconData? icon,
    bool reverse = false,
    double? letterSpacing,
    FontWeight? fontWeight,
    int radius = 10,
    bool simpleShadow = false,
    Color textColor = Colors.white,
  }) {
    height = (height == 0
        ? (Get.width > 400 ? Get.height / 24 : Get.height / 22)
        : height);
    color ??= ColorUtils.orange;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: Get.width / widthFactor,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius.toDouble()),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (reverse && icon is IconData) ...[
              Icon(
                icon,
                size: 20,
                color: Colors.white,
              ),
              const SizedBox(
                width: 8.0,
              ),
            ],
            Text(
              title,
              style: TextStyle(
                color: textColor,
                letterSpacing: letterSpacing,
                fontWeight: fontWeight,
                fontSize: fontSize,
              ),
            ),
            if (!reverse && icon is IconData) ...[
              const SizedBox(
                width: 8.0,
              ),
              Icon(
                icon,
                color: Colors.white,
              ),
            ],
          ],
        ),
      ),
    );
  }

  static smallSoftIcon({
    void Function()? onTap,
    bool enabled = true,
    double height = 0,
    MaterialColor? color,
    required IconData icon,
    int radius = 10,
    bool simpleShadow = false,
    Color textColor = Colors.white,
  }) {
    color ??= ColorUtils.orange;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius.toDouble()),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: textColor,
            ),
          ],
        ),
      ),
    );
  }

  static outlineButton({
    void Function()? onTap,
    double widthFactor = 4,
    String title = 'تایید',
    bool enabled = true,
    double fontSize = 14.0,
    double height = 0,
    MaterialColor? color,
    FontWeight fontWeight = FontWeight.normal,
    Color? bgColor,
    IconData? icon,
    bool reverse = false,
    double iconSize = 25,
    double radius = 10,
    Color? textColor,
  }) {
    height = (height == 0
        ? (Get.width > 400 ? Get.height / 24 : Get.height / 22)
        : height);
    color ??= ColorUtils.orange;
    textColor ??= ColorUtils.textWhite;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        splashColor: color.shade50,
        highlightColor: color.shade200.withOpacity(0.5),
        onTap: onTap,
        child: Container(
          height: height,
          width: Get.width / widthFactor,
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(
              color: color,
            ),
            borderRadius: BorderRadius.circular(radius),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!reverse && icon is IconData) ...[
                Icon(
                  icon,
                  color: textColor,
                  size: iconSize,
                ),
                const SizedBox(
                  width: 8.0,
                ),
              ],
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: fontWeight,
                    fontSize: fontSize,
                  ),
                ),
              ),
              if (reverse && icon is IconData) ...[
                const SizedBox(
                  width: 8.0,
                ),
                Icon(
                  icon,
                  color: textColor,
                  size: iconSize,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static badge({
    void Function()? onTap,
    double widthFactor = 4.5,
    String title = 'تایید',
    bool enabled = true,
    double fontSize = 12.0,
    double height = 0,
    MaterialColor? color,
    IconData? icon,
    bool reverse = false,
  }) {
    height = (height == 0
        ? (Get.width > 400 ? Get.height / 28 : Get.height / 28)
        : height);
    color ??= ColorUtils.green;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: Get.width / widthFactor,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const Alignment(-1.0, -4.0),
            end: const Alignment(1.0, 4.0),
            colors: [
              if (!reverse) ...[
                enabled ? color : color.withOpacity(0.5),
                enabled ? color.shade800 : color.shade800.withOpacity(0.5),
              ],
              if (reverse) ...[
                enabled ? color.shade800 : color.shade800.withOpacity(0.5),
                enabled ? color : color.withOpacity(0.5),
              ],
            ],
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: color.shade700.withOpacity(0.7),
              offset: const Offset(1.0, 1.0),
              blurRadius: 6.0,
              spreadRadius: 1.0,
            ),
            BoxShadow(
              color: color.withOpacity(0.2),
              offset: const Offset(-2.0, -2.0),
              blurRadius: 6.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!reverse && icon is IconData) ...[
              Icon(
                icon,
                color: ColorUtils.white,
              ),
              const SizedBox(
                width: 8.0,
              ),
            ],
            Text(
              title,
              style: TextStyle(
                color: ColorUtils.white,
                fontSize: fontSize,
              ),
            ),
            if (reverse && icon is IconData) ...[
              const SizedBox(
                width: 8.0,
              ),
              Icon(
                icon,
                color: ColorUtils.white,
              ),
            ],
          ],
        ),
      ),
    );
  }

  static input({
    String title = '',
    IconData? icon,
    TextEditingController? controller,
    TextAlign textAlign = TextAlign.right,
    TextInputType keyboardType = TextInputType.text,
    void Function(String string)? onChanged,
    FocusNode? focusNode,
    List<TextInputFormatter> formatter = const [],
    double letterSpacing = 1.5,
    bool enabled = true,
    bool? valid,
    int maxLines = 1,
    bool price = false,
    bool percent = false,
    Color? backgroundColor,
    double heightFactor = 21,
    Color? borderColor,
    Color? textColor,
    bool password = false,
    double labelSize = 12,
    bool datePicker = false,
  }) {
    controller ??= TextEditingController();
    backgroundColor ??= ColorUtils.black;
    textColor ??= ColorUtils.white;
    if (password) {
      keyboardType = TextInputType.visiblePassword;
    }
    return GestureDetector(
      onTap: () async {
        if (datePicker) {
          Jalali? result = await showPersianDatePicker(
            context: Get.context!,
            initialDate: Jalali(1350, 1, 1),
            firstDate: Jalali(
              1300,
            ),
            lastDate: Jalali(
              1400,
            ),
          );
          controller?.text = result?.formatFullDate() ?? "";
        }
      },
      child: TextFormField(
        textAlign: textAlign,
        keyboardType: price ? TextInputType.number : keyboardType,
        controller: controller,
        maxLines: maxLines,
        enabled: enabled ? !datePicker : false,
        focusNode: focusNode,
        cursorColor: ColorUtils.orange,
        obscureText: password,
        textAlignVertical: TextAlignVertical.bottom,
        style: TextStyle(
          color: textColor,
          fontSize: labelSize + 1,
          fontFamily: "iranSans",
        ),
        inputFormatters: [
          if (percent) LengthLimitingTextInputFormatter(3),
          if (percent || price) FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (String str) {
          if (price) {
            double value = double.parse(str.replaceAll(',', '').trim());
            controller!.text = LogicUtils.moneyFormat(value);
            controller.selection = TextSelection.fromPosition(
              TextPosition(
                offset: controller.text.length,
              ),
            );
          }
          if (percent) {
            double value;
            try {
              value = double.parse(str);
            } catch (e) {
              value = 0;
            }
            if (value > 100) {
              controller!.text = '100';
              controller.selection = TextSelection.fromPosition(
                TextPosition(
                  offset: controller.text.length,
                ),
              );
            }
          }
          if (onChanged != null) onChanged(str);
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: title,
          labelStyle: TextStyle(
            color: textColor.withOpacity(0.5),
            fontSize: labelSize,
            fontFamily: "iranSans",
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          suffixIcon: datePicker
              ? Icon(
                  Ionicons.calendar_clear_outline,
                  color: textColor.withOpacity(0.5),
                )
              : null,
          focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: borderColor is Color
                  ? borderColor
                  : valid == true
                      ? ColorUtils.blue
                      : valid is bool
                          ? ColorUtils.red
                          : ColorUtils.orange,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              width: 0.5,
              color: borderColor is Color
                  ? borderColor
                  : valid == true
                      ? ColorUtils.blue
                      : valid is bool
                          ? ColorUtils.red
                          : ColorUtils.orange.withOpacity(0.7),
            ),
          ),
          disabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: borderColor is Color
                  ? borderColor
                  : valid == true
                      ? ColorUtils.blue
                      : valid is bool
                          ? ColorUtils.red
                          : ColorUtils.orange.withOpacity(0.2),
            ),
          ),
        ),
      ),
    );
  }

  static Widget shimmer({required Widget child}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.3),
      highlightColor: Colors.grey.withOpacity(0.1),
      child: child,
    );
  }

  static Widget dropdown({
    required String hint,
    required DropdownController controller,
    IconData? icon,
    void Function(DropDownItemModel)? onChange,
  }) {
    return CustomDropdown.search(
      hintText: hint,
      icon: icon,
      fillColor: ColorUtils.white,
      items: controller.items,
      onChanged: (DropDownItemModel value) {
        onChange?.call(value);
      },
      controller: controller,
    );
  }

  static closeButton() {
    return GestureDetector(
      onTap: () {
        Get.close(1);
      },
      child: Icon(
        Iconsax.close_circle,
        color: ColorUtils.red,
      ),
    );
  }
}
