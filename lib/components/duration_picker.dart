import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DurationPicker extends StatefulWidget {
  final List<int> durationOptions;
  final double itemHeight;
  final ValueChanged<int> onChanged;
  final double magnification;
  final double pickerHeight;
  final Color backgroundColor;
  final int initialItem;

  DurationPicker({
    @required this.durationOptions,
    this.backgroundColor = Colors.white,
    this.magnification = 1.0,
    this.onChanged,
    this.itemHeight = 32,
    this.pickerHeight = 216.0,
    this.initialItem = 0,
  });

  _DurationPickerState createState() => _DurationPickerState();
}

class _DurationPickerState extends State<DurationPicker> {
  FixedExtentScrollController _scrollController;
  int _selectedDurationIndex;

  _DurationPickerState();

  void initState() {
    super.initState();

    _selectedDurationIndex = widget.initialItem ?? 0;
    _scrollController =
        FixedExtentScrollController(initialItem: _selectedDurationIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.pickerHeight,
      color: widget.backgroundColor,
      child: GestureDetector(
        // Blocks taps from propagating to the modal sheet and popping.
        onTap: () {},
        child: SafeArea(
          top: false,
          child: CupertinoPicker(
            magnification: widget.magnification,
            scrollController: _scrollController,
            itemExtent: widget.itemHeight,
            backgroundColor: widget.backgroundColor,
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
