part of 'custom_dropdown.dart';

const _noTextStyle = TextStyle(height: 0);
const _borderSide = BorderSide(color: Colors.transparent);
const _errorBorderSide = BorderSide(color: Colors.redAccent, width: 2);

class _DropDownField extends StatefulWidget {
  final DropdownController controller;
  final VoidCallback onTap;
  final Function(DropDownItemModel)? onChanged;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final String? errorText;
  final TextStyle? errorStyle;
  final BorderSide? borderSide;
  final BorderSide? errorBorderSide;
  final BorderRadius? borderRadius;
  final Widget? suffixIcon;
  final Color? fillColor;

  final IconData? icon;

  const _DropDownField({
    Key? key,
    required this.controller,
    required this.onTap,
    this.onChanged,
    this.suffixIcon,
    this.hintText,
    this.hintStyle,
    this.style,
    this.errorText,
    this.errorStyle,
    this.borderSide,
    this.errorBorderSide,
    this.borderRadius,
    this.fillColor,
    this.icon,
  }) : super(key: key);

  @override
  State<_DropDownField> createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<_DropDownField> {
  bool listenChanges = true;

  @override
  void initState() {
    super.initState();
    if (widget.onChanged != null) {
      widget.controller.addListener(listenItemChanges);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(listenItemChanges);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _DropDownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onChanged != null) {
      widget.controller.addListener(listenItemChanges);
    } else {
      listenChanges = false;
    }
  }

  void listenItemChanges() {
    if (widget.controller.isSelected.isTrue) {
      final text = widget.controller.value;
      widget.onChanged!(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
      borderSide: widget.borderSide ?? _borderSide,
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
      borderSide: widget.errorBorderSide ?? _errorBorderSide,
    );

    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: ColorUtils.white,
          borderRadius: widget.controller.isOverlayShown.isTrue
              ? const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                )
              : BorderRadius.circular(10),
          border: widget.controller.hasError.isTrue
              ? Border.all(
                  color: ColorUtils.red,
                )
              : Border.all(
                  color: ColorUtils.orange,
                  width: 0.5,
                ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: widget.controller.isLoading.isTrue
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      ShimmerWidget(
                        height: 20,
                        width: Get.width / 3,
                      ),
                    ],
                  ),
                )
              : Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: widget.onTap,
                    borderRadius: BorderRadius.circular(10.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          if (widget.icon != null &&
                              (widget.controller.isSelected.isFalse ||
                                  !widget.controller.value.hasIcon)) ...[
                            Icon(
                              widget.icon,
                              size: 20,
                              color: ColorUtils.textGray,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                          ],
                          if (widget.controller.isSelected.isTrue &&
                              widget.controller.value.hasIcon) ...[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                widget.controller.value.iconPath(),
                                width: 20,
                                height: 20,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                          ],
                          if (widget.controller.isSelected.isTrue)
                            Text(
                              widget.controller.value.dropdownTitle(),
                              style: TextStyle(
                                color: ColorUtils.black,
                                fontSize: 12,
                              ),
                            ),
                          if (widget.controller.isSelected.isFalse)
                            Text(
                              widget.hintText ?? "انتخاب",
                              style: widget.hintStyle?.copyWith(
                                fontSize: 12,
                              )
                            ),
                          const Spacer(),
                          AnimatedRotation(
                            duration: const Duration(milliseconds: 250),
                            turns: widget.controller.isOverlayShown.isTrue
                                ? 0.5
                                : 0,
                            child: Icon(
                              Ionicons.chevron_down,
                              color: ColorUtils.textGray,
                              size: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
