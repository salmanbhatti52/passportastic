
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constant_colors.dart';
import '../stamp_controller.dart';

class StampBackgroundAsset extends StatelessWidget {
  StampBackgroundAsset({
    super.key,
  });

  final StampController controller = Get.find<StampController>();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: controller.stampAsset != null
          ? SvgPicture.string(
        controller.stampAsset!,
        // width: 150,
        // height: 150,
        color: ConstantColors.stampColors[controller.selectedColorIndex],
        fit: BoxFit.contain,
      )
          : const SizedBox.shrink(),
    );
  }
}
