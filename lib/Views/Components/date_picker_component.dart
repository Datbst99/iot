import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Configs/constant.dart';

class DatePickerComponent extends StatefulWidget {
  final ValueChanged<DateTime?> onChange;

  const DatePickerComponent({super.key, required this.onChange});

  @override
  State<DatePickerComponent> createState() => _DatePickerComponentState();
}

class _DatePickerComponentState extends State<DatePickerComponent> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      cancelText: 'Hủy',
      confirmText: 'Chọn',
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor, // header background color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: primaryColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      widget.onChange(picked);
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: TextField(
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                border: UnderlineInputBorder(borderSide: BorderSide.none),
                contentPadding:EdgeInsets.only(bottom: 12, left: 5),
              ),
              controller: TextEditingController(
                text: DateFormat('dd/MM/yyyy').format(selectedDate),
              ),
              onTap: () => _selectDate(context),
              readOnly: true,
              textAlignVertical: TextAlignVertical.top,

            ),
          ),
          Expanded(flex: 1,child:  IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            icon: const Icon(
              Icons.calendar_today,
              size: 19,
            ),
            onPressed: () => _selectDate(context),
          ),)
        ],
      ),
    );
  }
}
