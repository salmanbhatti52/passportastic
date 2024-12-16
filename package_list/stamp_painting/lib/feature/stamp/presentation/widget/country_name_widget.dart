import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passport_stamp/feature/stamp/presentation/stamp_controller.dart';

class CountryNameWidget extends StatelessWidget {
  CountryNameWidget({
    super.key,
  });

  final StampController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      minFontSize: 6,
      maxFontSize: 9,
      controller.selectedCountryForDynamicStamp!,
      textAlign: TextAlign.center,
      maxLines: 1,
      style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w600),
    );
  }
}