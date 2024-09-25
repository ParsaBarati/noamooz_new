library animated_custom_dropdown;

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:noamooz/Plugins/my_dropdown/dropdown_controller.dart';
import 'package:noamooz/Plugins/my_dropdown/dropdown_item_model.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/shimmer_widget.dart';
import 'package:iconsax/iconsax.dart';

import '../get/get.dart';

export 'custom_dropdown.dart';

part 'animated_section.dart';

part 'dropdown_field.dart';

part 'dropdown_overlay.dart';

part 'overlay_builder.dart';

enum _SearchType { onListData }

class CustomDropdown extends StatefulWidget {
  final List<DropDownItemModel> items;
  final DropdownController controller;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? selectedStyle;
  final String? errorText;
  final TextStyle? errorStyle;
  final TextStyle? listItemStyle;
  final BorderSide? borderSide;
  final BorderSide? errorBorderSide;
  final BorderRadius? borderRadius;
  final IconData? icon;
  final Function(DropDownItemModel)? onChanged;
  final bool? excludeSelected;
  final Color? fillColor;
  final bool? canCloseOutsideBounds;
  final _SearchType? searchType;

  CustomDropdown({
    Key? key,
    required this.items,
    required this.controller,
    this.hintText,
    this.hintStyle,
    this.selectedStyle,
    this.errorText,
    this.errorStyle,
    this.listItemStyle,
    this.errorBorderSide,
    this.borderRadius,
    this.borderSide,
    this.icon,
    this.onChanged,
    this.excludeSelected = false,
    this.fillColor = Colors.white,
  })  : assert(items.isNotEmpty, 'Items list must contain at least one item.'),
        // assert(
        //   controller.value.isEmpty || items.contains(controller.value),
        //   'Controller value must match with one of the item in items list.',
        // ),
        searchType = null,
        canCloseOutsideBounds = true,
        super(key: key);

  CustomDropdown.search({
    Key? key,
    required this.items,
    required this.controller,
    this.hintText,
    this.hintStyle,
    this.selectedStyle,
    this.errorText,
    this.errorStyle,
    this.listItemStyle,
    this.errorBorderSide,
    this.borderRadius,
    this.borderSide,
    this.icon,
    this.onChanged,
    this.excludeSelected = false,
    this.canCloseOutsideBounds = true,
    this.fillColor = Colors.white,
  })  : searchType = _SearchType.onListData,
        super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  final layerLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    /// hint text
    final hintText = widget.hintText ?? 'لطفا یک مورد را انتخاب کنید';

    // hint style :: if provided then merge with default
    final hintStyle = TextStyle(
      fontSize: 12,
      color: ColorUtils.textGray,
      fontWeight: FontWeight.w400,
    ).merge(widget.hintStyle);

    // selected item style :: if provided then merge with default
    final selectedStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ).merge(widget.selectedStyle);

    return _OverlayBuilder(
      controller: widget.controller,
      overlay: (size, hideCallback) {
        return _DropdownOverlay(
          items: widget.controller.items,
          controller: widget.controller,
          size: size,
          layerLink: layerLink,
          hideOverlay: hideCallback,
          headerStyle:
              widget.controller.isSelected.isTrue ? selectedStyle : hintStyle,
          hintText: hintText,
          listItemStyle: widget.listItemStyle,
          excludeSelected: widget.excludeSelected,
          canCloseOutsideBounds: widget.canCloseOutsideBounds,
          searchType: widget.searchType,
        );
      },
      child: (showCallback) {
        return CompositedTransformTarget(
          link: layerLink,
          child: _DropDownField(
            controller: widget.controller,
            onTap: showCallback,
            style: selectedStyle,
            icon: widget.icon,
            borderRadius: widget.borderRadius,
            borderSide: widget.borderSide,
            errorBorderSide: widget.errorBorderSide,
            errorStyle: widget.errorStyle,
            errorText: widget.errorText,
            hintStyle: hintStyle,
            hintText: hintText,
            onChanged: widget.onChanged,
            fillColor: widget.fillColor,
          ),
        );
      },
    );
  }
}
