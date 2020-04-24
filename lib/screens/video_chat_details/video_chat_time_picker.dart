import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VideoChatTimePicker extends StatefulWidget {
  final DateTime initialTime;
  final double itemHeight;
  final ValueChanged<DateTime> onChanged;

  final double pickerHeight;

  VideoChatTimePicker({
    this.initialTime,
    @required this.onChanged,
    this.itemHeight = 32,
    this.pickerHeight = 216.0,
  });

  _VideoChatTimePickerState createState() => _VideoChatTimePickerState();
}

class _VideoChatTimePickerState extends State<VideoChatTimePicker> {
  DateTime initialTime;

  _VideoChatTimePickerState();

  @override
  void initState() {
    super.initState();

    initialTime = widget.initialTime ?? DateTime.now();
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
            mode: CupertinoDatePickerMode.dateAndTime,
            initialDateTime: initialTime,
            minuteInterval: 15,
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
