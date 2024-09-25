part of 'custom_dropdown.dart';

const _headerPadding = EdgeInsets.only(
  left: 16.0,
  top: 16,
  bottom: 16,
  right: 14,
);
const _overlayOuterPadding = EdgeInsets.only(bottom: 12, left: 12, right: 12);
const _overlayShadowOffset = Offset(0, 6);
const _listItemPadding = EdgeInsets.symmetric(vertical: 12, horizontal: 16);

class EmptyItemModel extends DropDownItemModel {
  @override
  dropdownId() {
    return -1;
  }

  @override
  dropdownTitle() {
    return '';
  }
}

class _DropdownOverlay extends StatefulWidget {
  final List<DropDownItemModel> items;
  final DropdownController controller;
  final Size size;
  final LayerLink layerLink;
  final VoidCallback hideOverlay;
  final String hintText;
  final TextStyle? headerStyle;
  final TextStyle? listItemStyle;
  final bool? excludeSelected;
  final bool? canCloseOutsideBounds;
  final _SearchType? searchType;

  const _DropdownOverlay({
    Key? key,
    required this.items,
    required this.controller,
    required this.size,
    required this.layerLink,
    required this.hideOverlay,
    required this.hintText,
    this.headerStyle,
    this.listItemStyle,
    this.excludeSelected,
    this.canCloseOutsideBounds,
    this.searchType,
  }) : super(key: key);

  @override
  _DropdownOverlayState createState() => _DropdownOverlayState();
}

class _DropdownOverlayState extends State<_DropdownOverlay> {
  bool displayOverly = true;
  bool displayOverlayBottom = true;
  late DropDownItemModel selectedValue;
  late List<DropDownItemModel> items;
  late List<DropDownItemModel> filteredItems;
  final key1 = GlobalKey(), key2 = GlobalKey();
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final render1 = key1.currentContext?.findRenderObject() as RenderBox;
      final render2 = key2.currentContext?.findRenderObject() as RenderBox;
      final screenHeight = MediaQuery.of(context).size.height;
      double y = render1.localToGlobal(Offset.zero).dy;
      if (screenHeight - y < render2.size.height) {
        displayOverlayBottom = false;
        Future.delayed(const Duration(milliseconds: 100), () {
          setState(() {});
        });
      }
    });

    selectedValue = widget.controller.isSelected.isTrue
        ? widget.controller.value
        : EmptyItemModel();
    if (widget.excludeSelected! &&
        widget.items.length > 1 &&
        widget.controller.isSelected.isTrue) {
      items = widget.items.where((item) => item != selectedValue).toList();
    } else {
      items = widget.items;
    }
    filteredItems = items;
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // search availability check
    final onListDataSearch = widget.searchType == _SearchType.onListData;

    // border radius
    final borderRadius = BorderRadius.circular(12);

    // overlay icon
    final overlayIcon = Icon(
      displayOverlayBottom ? Iconsax.arrow_up_2 : Iconsax.arrow_up_2,
      color: ColorUtils.textWhite,
      size: 20,
    );

    // overlay offset
    final overlayOffset =
        Offset(-12, displayOverlayBottom ? Get.height / 21 : 60);

    // list padding
    final listPadding =
        onListDataSearch ? const EdgeInsets.only(top: 8) : EdgeInsets.zero;

    // items list
    final list = widget.controller.isLoading.isTrue
        ? const SizedBox()
        : items.isNotEmpty
            ? _ItemsList(
                controller: widget.controller,
                scrollController: scrollController,
                excludeSelected:
                    widget.items.length > 1 ? widget.excludeSelected! : false,
                items: items,
                padding: listPadding,
                selectedValue: selectedValue,
                itemTextStyle: widget.listItemStyle,
                onItemSelect: (value) {
                  setState(() => displayOverly = false);
                  widget.controller.onChange(value);
                },
              )
            : const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'نتیجه ای یافت نشد.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              );

    final child = Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        children: [
          Positioned(
            width: widget.size.width + 24,
            child: CompositedTransformFollower(
              link: widget.layerLink,
              followerAnchor: displayOverlayBottom
                  ? Alignment.topLeft
                  : Alignment.bottomLeft,
              showWhenUnlinked: false,
              offset: overlayOffset,
              child: Container(
                key: key1,
                padding: _overlayOuterPadding,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: ColorUtils.white,
                    borderRadius: displayOverlayBottom
                        ? const BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          )
                        : const BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 24.0,
                        color: ColorUtils.gray.withOpacity(0.3),
                        offset: Offset(
                          0,
                          displayOverlayBottom
                              ? Get.height / 21
                              : -Get.height / 21,
                        ),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    type: MaterialType.transparency,
                    child: AnimatedSection(
                      animationDismissed: widget.hideOverlay,
                      expand: displayOverly,
                      axisAlignment: displayOverlayBottom ? 1.0 : -1.0,
                      child: SizedBox(
                        key: key2,
                        height: items.length > 4
                            ? onListDataSearch
                                ? 270
                                : 225
                            : null,
                        child: ClipRRect(
                          borderRadius: borderRadius,
                          child: NotificationListener<
                              OverscrollIndicatorNotification>(
                            onNotification: (notification) {
                              notification.disallowIndicator();
                              return true;
                            },
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                scrollbarTheme: ScrollbarThemeData(
                                  thumbVisibility: MaterialStateProperty.all(
                                    true,
                                  ),
                                  thickness: MaterialStateProperty.all(5),
                                  radius: const Radius.circular(4),
                                  thumbColor: MaterialStateProperty.all(
                                    Colors.grey[300],
                                  ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Padding(
                                  //   padding: _headerPadding,
                                  //   child: Row(
                                  //     children: [
                                  //       Expanded(
                                  //         child: Text(
                                  //           widget.hintText,
                                  //           style: TextStyle(
                                  //             fontSize: 14,
                                  //             color: ColorUtils.textGray,
                                  //             fontWeight: FontWeight.w400,
                                  //           ),
                                  //           maxLines: 1,
                                  //           overflow: TextOverflow.ellipsis,
                                  //         ),
                                  //       ),
                                  //       const SizedBox(width: 12),
                                  //       overlayIcon,
                                  //     ],
                                  //   ),
                                  // ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  if (onListDataSearch)
                                    Column(
                                      children: [
                                        _SearchField(
                                          items: filteredItems,
                                          onSearchedItems: (val) {
                                            setState(() => items = val);
                                          },
                                        ),
                                      ],
                                    ),
                                  items.length > 4
                                      ? Expanded(child: list)
                                      : list,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return GestureDetector(
      onTap: () => setState(() => displayOverly = false),
      child: widget.canCloseOutsideBounds!
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
              child: child,
            )
          : child,
    );
  }
}

class _ItemsList extends StatelessWidget {
  final ScrollController scrollController;
  final DropdownController controller;
  final List<DropDownItemModel> items;
  final bool excludeSelected;
  final DropDownItemModel selectedValue;
  final ValueSetter<DropDownItemModel> onItemSelect;
  final EdgeInsets padding;
  final TextStyle? itemTextStyle;

  const _ItemsList({
    Key? key,
    required this.scrollController,
    required this.items,
    required this.excludeSelected,
    required this.selectedValue,
    required this.onItemSelect,
    required this.padding,
    this.itemTextStyle,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listItemStyle = TextStyle(
      fontSize: 14,
      color: ColorUtils.textBlack,
    ).merge(itemTextStyle);

    return Scrollbar(
      controller: scrollController,
      child: ListView.separated(
        controller: scrollController,
        shrinkWrap: true,
        padding: padding,
        itemCount: items.length,
        separatorBuilder: (_, index) {
          return Divider(
            height: 1,
            color: ColorUtils.orange.withOpacity(0.3),
          );
        },
        itemBuilder: (_, index) {
          final selected = selectedValue == items[index];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.grey[200],
              onTap: () => onItemSelect(items[index]),
              child: Container(
                padding: _listItemPadding,
                child: Row(
                  children: [
                    if (items[index].hasIcon) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          items[index].iconPath(),
                          width: 20,
                          fit: BoxFit.cover,
                          height: 20,
                        ),
                      ),
                      const SizedBox(width: 4,),
                    ],
                    Text(
                      items[index].dropdownTitle(),
                      style: listItemStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    if (selected)
                      Icon(
                        Iconsax.tick_square,
                        color: ColorUtils.orange,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SearchField extends StatefulWidget {
  final List<DropDownItemModel> items;
  final ValueChanged<List<DropDownItemModel>> onSearchedItems;

  const _SearchField({
    Key? key,
    required this.items,
    required this.onSearchedItems,
  }) : super(key: key);

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  final searchCtrl = TextEditingController();

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  void onSearch(String str) {
    final result = widget.items
        .where((item) =>
            item.dropdownTitle().toLowerCase().contains(str.toLowerCase()))
        .toList();
    widget.onSearchedItems(result);
  }

  void onClear() {
    if (searchCtrl.text.isNotEmpty) {
      searchCtrl.clear();
      widget.onSearchedItems(widget.items);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        controller: searchCtrl,
        onChanged: onSearch,
        decoration: InputDecoration(
          filled: true,
          fillColor: ColorUtils.gray.withOpacity(0.1),
          constraints: const BoxConstraints.tightFor(height: 40),
          contentPadding: const EdgeInsets.all(8),
          hintText: 'جستجو...',
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
          prefixIcon:
              const Icon(Iconsax.search_normal, color: Colors.grey, size: 15),
          suffixIcon: GestureDetector(
            onTap: onClear,
            child: Icon(Iconsax.close_circle,
                color: ColorUtils.red.withOpacity(0.5), size: 20),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(.25),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(.25),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(.25),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
