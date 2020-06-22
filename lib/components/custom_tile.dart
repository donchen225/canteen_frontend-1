import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';

class CustomTile extends StatefulWidget {
  final double height;
  final Color color;
  final EdgeInsets padding;
  final Widget child;
  final Function onTap;

  CustomTile(
      {this.height = 60,
      this.color = Colors.transparent,
      this.padding,
      this.onTap,
      this.child});

  @override
  _CustomTileState createState() => _CustomTileState();
}

class _CustomTileState extends State<CustomTile> {
  Color color;

  void initState() {
    color = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          color = Palette.tabSelectedColor;
        });
      },
      onTapCancel: () {
        setState(() {
          color = widget.color;
        });
      },
      onTap: () {
        setState(() {
          color = widget.color;
          if (widget.onTap != null) {
            widget.onTap();
          }
        });
      },
      child: Container(
          height: widget.height,
          color: color,
          padding: widget.padding,
          child: Row(
            children: <Widget>[
              Expanded(
                child: widget.child ?? Container(),
              ),
            ],
          )),
    );
  }
}
