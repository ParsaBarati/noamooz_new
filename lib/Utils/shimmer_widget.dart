import 'package:flutter/material.dart';
import 'package:noamooz/Globals/Globals.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double height;
  final double width;
  final int radius;

  const ShimmerWidget({
    Key? key,
    required this.height,
    required this.width,
    this.radius = 25,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Globals.darkModeStream.getStream,
      builder: (context, snapshot) {
        return Shimmer.fromColors(
          baseColor: Globals.darkModeStream.darkMode ? ColorUtils.blue.shade900 : Colors.grey.shade200,
          highlightColor: Globals.darkModeStream.darkMode ? ColorUtils.blue : Colors.grey.shade50,
          child: Container(
            decoration: BoxDecoration(
              color: ColorUtils.black,
              borderRadius: BorderRadius.circular(radius.toDouble()),
            ),
            height: height,
            width: width,
          ),
        );
      }
    );
  }
}
