
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passport_stamp/feature/stamp/presentation/stamp_controller.dart';

class DateAndCityNameWidget extends StatelessWidget {
  DateAndCityNameWidget({
    super.key,
    required this.width,
  });

  final double width;

  final StampController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width * .2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (controller.selectedDate != null)
            AutoSizeText(
              minFontSize: 6,
              maxFontSize: 7,
              controller.selectedDate!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          AutoSizeText(
            minFontSize: 2,
            maxFontSize: 7,
            controller.cityName,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}