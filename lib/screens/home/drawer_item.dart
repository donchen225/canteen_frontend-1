import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';

class DrawerItem extends StatefulWidget {
  final Widget leading;
  final Widget title;
  final double height;
  final Color color;
  final EdgeInsets padding;
  final Function onTap;

  DrawerItem(
      {this.leading,
      this.title,
      this.color = Colors.transparent,
      this.padding,
      this.onTap,
      this.height = 60});

  @override
  _DrawerItemState createState() => _DrawerItemState();
}

class _DrawerItemState extends State<DrawerItem> {
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
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: widget.leading,
                ),
              ),
              Expanded(
                flex: 6,
                child: widget.title,
              ),
            ],
          )),
    );
  }
}
