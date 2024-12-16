import 'package:flutter/material.dart';

import '../../../../core/helpers/size_box_extension.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.hint,
      required this.label,
      required this.onChanged,
      this.prefixWidget});

  final String hint;
  final String label;
  final void Function(String) onChanged;
  final Widget? prefixWidget;

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
        TextField(
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFF65734)),
              borderRadius: BorderRadius.circular(15.0),
            ),
            // labelText: 'Email',
            hintText: "Enter City",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Color(0xFFF3F3F3),
              ),
            ),
            hintStyle: const TextStyle(
              fontSize: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          style: const TextStyle(
            fontSize: 14,
          ),
          cursorColor: const Color(0xFF000000),
          keyboardType: TextInputType.name,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
