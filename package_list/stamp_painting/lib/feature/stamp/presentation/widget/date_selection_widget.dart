import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelectionWidget extends StatelessWidget {
  DateSelectionWidget({super.key, required this.getDate});
  void Function(String?, String?) getDate;

  TextEditingController dateTimeTextController = TextEditingController();

  // Future<String?> pickDate(BuildContext context) async {
  //   String? selectedDateString;
  //   DateTime? selectedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime(2100),
  //   );
  //   if (selectedDate != null) {
  //     selectedDateString = DateFormat('yyyy-MM-dd').format(selectedDate);
  //     dateTimeTextController.text = selectedDateString;
  //   }
  //   return selectedDateString;
  // }

  // Future<String?> pickDateFormatted(BuildContext context) async {
  //   String? selectedDateString;
  //   DateTime? selectedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime(2100),
  //   );
  //   if (selectedDate != null) {
  //     selectedDateString = DateFormat('dd-MMMM-yyyy').format(selectedDate);
  //     dateTimeTextController.text = selectedDateString;
  //   }
  //   return selectedDateString;
  // }

  Future<void> pickAndSetDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900), // Allow past dates
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      String formattedDatePretty = DateFormat('dd-MMMM-yyyy').format(selectedDate);

      // Set the formatted date in the text controller
      dateTimeTextController.text = formattedDatePretty;

      // Pass the values to the callback
      getDate(formattedDate, formattedDatePretty);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => pickAndSetDate(context),
      // onTap: () async {
      //   String? pickedDateString = await pickDate(context);
      //   String? pickedDateFormatted = await pickDateFormatted(context);
      //
      //   getDate(pickedDateString, pickedDateFormatted);
      // },
      child: TextField(
        controller: dateTimeTextController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(color: Colors.orange),
          ),
          suffixIcon: const Icon(Icons.calendar_today_outlined),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(color: Colors.orange),
          ),
          fillColor: Colors.blue.withOpacity(0.1),
          hintText: 'Select Date',
          hintStyle: const TextStyle(color: Colors.grey),
        ),
        style: const TextStyle(color: Colors.black),
        enabled: false,
      ),
    );
  }
}

class TimeSelectionWidget extends StatelessWidget {
  TimeSelectionWidget({super.key, required this.getDate});
  void Function(String?) getDate;

  TextEditingController TimeTextController = TextEditingController();

  Future<String?> pickDate(BuildContext context) async {
    String? selectedTimeString;
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      // Use MaterialLocalizations to format the time in 24-hour format
      final MaterialLocalizations localizations =
          MaterialLocalizations.of(context);
      selectedTimeString = localizations.formatTimeOfDay(selectedTime,
          alwaysUse24HourFormat: true);
      // Assuming you have a TextEditingController for displaying the selected time
      TimeTextController.text = selectedTimeString;
    }
    return selectedTimeString;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        String? pickedDateString = await pickDate(context);
        getDate(pickedDateString);
      },
      child: TextField(
        controller: TimeTextController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(color: Colors.orange),
          ),
          suffixIcon: const Icon(Icons.calendar_today_outlined),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(color: Colors.orange),
          ),
          fillColor: Colors.blue.withOpacity(0.1),
          hintText: 'Select Time',
          hintStyle: const TextStyle(color: Colors.grey),
        ),
        style: const TextStyle(color: Colors.black),
        enabled: false,
      ),
    );
  }
}
