import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AvailabilityPicker extends StatefulWidget {
  final TimeOfDay initialTime;
  final double itemHeight;
  final ValueChanged<DateTime> onChanged;

  final double pickerHeight;

  AvailabilityPicker({
    this.initialTime,
    @required this.onChanged,
    this.itemHeight = 32,
    this.pickerHeight = 216.0,
  });

  _AvailabilityPickerState createState() => _AvailabilityPickerState();
}

class _AvailabilityPickerState extends State<AvailabilityPicker> {
  DateTime initialTime;
  final now = new DateTime.now();

  _AvailabilityPickerState();

  @override
  void initState() {
    super.initState();

    initialTime = widget.initialTime != null
        ? DateTime(now.year, now.month, now.day, widget.initialTime.hour,
            widget.initialTime.minute)
        : DateTime.fromMillisecondsSinceEpoch(0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.pickerHeight,
      color: Colors.transparent,
      child: GestureDetector(
        // Blocks taps from propagating to the modal sheet and popping.
        onTap: () {},
        child: SafeArea(
          top: false,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            initialDateTime: initialTime,
            minuteInterval: 30,
            onDateTimeChanged: (DateTime newDateTime) {
              if (mounted && widget.onChanged != null) {
                widget.onChanged(newDateTime);
              }
            },
          ),
        ),
      ),
    );
  }
}
