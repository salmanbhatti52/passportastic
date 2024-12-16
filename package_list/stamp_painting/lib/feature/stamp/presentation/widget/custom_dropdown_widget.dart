import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/size_box_extension.dart';

class CustomDropDownWidget<T> extends StatelessWidget {
  const CustomDropDownWidget({
    super.key,
    required this.onChange,
    required this.items,
    required this.hint,
    required this.label,
  });

  final void Function(dynamic)? onChange;
  final List<DropdownMenuItem<dynamic>> items;
  final String hint;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        addHeight(4),
        DropdownButtonFormField2<dynamic>(
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none),
          ),
          hint: Text(
            hint,
            style: const TextStyle(fontSize: 14),
          ),
          items: items,
          onChanged: (value) {
            if (onChange != null) {
              onChange!(value);
            }
            print(value);
          },
          // onSaved: (value) {
          //   selectedValue = value.toString();
          // },

          buttonStyleData: ButtonStyleData(
              height: 60,
              width: 160,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFF3F3F3),
                ),
                // color: Colors.redAccent,
              ),
              elevation: 0,
              overlayColor: const MaterialStatePropertyAll(Color(0xffF1A04C))),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xFFA7A9B7),
            ),
            iconSize: 24,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 300,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xffF1A04C))),
          ),
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.symmetric(horizontal: 16),
            overlayColor: MaterialStatePropertyAll(Color(0xffF1A04C)),
          ),
        ),
      ],
    );
  }
}
