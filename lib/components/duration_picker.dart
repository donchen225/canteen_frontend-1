import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DurationPicker extends StatefulWidget {
  final List<int> durationOptions;
  final double itemHeight;
  final ValueChanged<int> onChanged;
  final double magnification;
  final double pickerHeight;

  DurationPicker({
    @required this.durationOptions,
    this.magnification = 1.0,
    this.onChanged,
    this.itemHeight = 32,
    this.pickerHeight = 216.0,
  });

  _DurationPickerState createState() => _DurationPickerState();
}

class _DurationPickerState extends State<DurationPicker> {
  final FixedExtentScrollController _scrollController =
      FixedExtentScrollController();
  int _selectedDurationIndex = 0;

  _DurationPickerState();

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
          child: CupertinoPicker(
            magnification: widget.magnification,
            scrollController: _scrollController,
            itemExtent: widget.itemHeight,
            backgroundColor: Colors.transparent,
            onSelectedItemChanged: (int index) {
              if (mounted) {
                setState(() {
                  _selectedDurationIndex = index;
                  if (widget.onChanged != null) {
                    widget.onChanged(index);
                  }
                });
              }
            },
            children: List<Widget>.generate(widget.durationOptions.length,
                (int index) {
              return Center(
                child: Text(
                  '${widget.durationOptions[index]} minutes',
                  style: TextStyle(
                    fontSize: 22.0,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
