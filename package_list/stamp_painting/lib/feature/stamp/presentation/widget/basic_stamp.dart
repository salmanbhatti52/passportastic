
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constant_colors.dart';
import '../stamp_controller.dart';
import 'stamp_painter.dart';

class BasicStamp extends StatelessWidget {
  const BasicStamp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GetBuilder<StampController>(
      id: 'basic_stamp',
      builder: (controller) {
        return SizedBox(
          width: width * 0.3,
          height: width * 0.3,
          child: Stack(
            fit: StackFit.expand,
            children: [
              SvgPicture.asset(
                'assets/passport/base_stamp/basic_stamp.svg',
                width: width * 0.25,
                height: width * 0.25,
                color: ConstantColors
                    .stampColors[controller.selectedColorIndex],
              ),
              if (controller.travelModeAsset != null)
                Positioned(
                  top: width * .06,
                  left: width * .1,
                  child: SvgPicture.string(
                    controller.travelModeAsset!,
                    height: width * .08,
                    width: width * .08,
                    fit: BoxFit.contain,
                  ),
                ),
              Center(
                child: Transform.translate(
                  offset: const Offset(0, 6),
                  child: Transform.rotate(
                    angle: -pi / 9,
                    child: Text(
                      controller.selectedWay ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              CustomPaint(
                painter: StampPainter(
                  country: controller.selectedCountry ?? '',
                  city: controller.cityName,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
