import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/helpers/size_box_extension.dart';

DropdownMenuItem<dynamic> dropdownMenuItemWithSvg(dynamic item) {
  return DropdownMenuItem<dynamic>(
    value: item,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SvgPicture.asset(
            item.assetLink,
            width: 36,
            height: 36,
          ),
          addWidth(10),
          Expanded(
            child: Text(
              item.label,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

DropdownMenuItem<dynamic> dropdownMenuItem(
  dynamic text,
) {
  return DropdownMenuItem<dynamic>(
    value: text,
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 14,
      ),
    ),
  );
}
