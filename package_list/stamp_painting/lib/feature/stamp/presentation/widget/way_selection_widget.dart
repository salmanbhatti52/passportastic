import 'package:flutter/material.dart';

import '../../../../core/constants/constant_strings.dart';
import '../../../../core/helpers/size_box_extension.dart';
import '../stamp_controller.dart';

class WaySelectionWidget extends StatelessWidget {
  const WaySelectionWidget({
    super.key,
    required this.controller,
    this.onWaySelected, // Add this line
  });

  final StampController controller;
  final Function(String)? onWaySelected; // Add this line

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            Radio<String>(
              value: ConstantStrings.way.first,
              groupValue: controller.selectedWay,
              onChanged: (value) {
                controller.selectedWay = value;
                controller.update(['way_selection','basic_stamp','dynamic_stamp']);
                if (value != null) {
                  onWaySelected?.call(value); // Modify this line
                }
              },
            ),
            Text(ConstantStrings.way.first)
          ],
        ),
        addWidth(32),
        Row(
          children: [
            Radio<String>(
              value: ConstantStrings.way.last,
              groupValue: controller.selectedWay,
              onChanged: (value) {
                controller.selectedWay = value;
                controller.update(['way_selection','basic_stamp','dynamic_stamp']);
                if (value != null) {
                  onWaySelected?.call(value); // Modify this line
                }
              },
            ),
            Text(ConstantStrings.way.last)
          ],
        ),
      ],
    );
  }
}