import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DurationPicker extends StatefulWidget {
  final List<int> durationOptions;
  final double itemHeight;
  final ValueChanged<int> onChanged;

  DurationPicker({
    @required this.durationOptions,
    this.onChanged,
    this.itemHeight = 32,
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
    print('INSIDE DURATION PICKER');
    // print(_scrollController.hashCode);
    return CupertinoPicker(
      magnification: 1.0,
      scrollController: _scrollController,
      itemExtent: widget.itemHeight,
      backgroundColor: CupertinoColors.white,
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
      children:
          List<Widget>.generate(widget.durationOptions.length, (int index) {
        return Center(
          child: Text('${widget.durationOptions[index]} minutes'),
        );
      }),
    );
  }
}
