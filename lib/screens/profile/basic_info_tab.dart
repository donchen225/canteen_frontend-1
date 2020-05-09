import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class BasicInfoTab extends StatefulWidget {
  final String title;
  final String value;
  final Function onTap;

  BasicInfoTab(
      {@required this.title, @required this.value, @required this.onTap});

  @override
  _BasicInfoTabState createState() => _BasicInfoTabState();
}

class _BasicInfoTabState extends State<BasicInfoTab> {
  bool nameSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          nameSelected = true;
        });
      },
      onTapCancel: () {
        setState(() {
          nameSelected = false;
        });
      },
      onTap: () {
        setState(() {
          nameSelected = true;
        });
        widget.onTap();
      },
      child: Container(
        padding: EdgeInsets.only(
            left: SizeConfig.instance.blockSizeHorizontal * 6,
            right: SizeConfig.instance.blockSizeHorizontal * 3,
            top: SizeConfig.instance.blockSizeVertical,
            bottom: SizeConfig.instance.blockSizeVertical),
        decoration: BoxDecoration(
          color:
              nameSelected ? Colors.grey[400].withOpacity(0.6) : Colors.white,
          border: Border(
            top: BorderSide(width: 0.5, color: Colors.grey[400]),
            bottom: BorderSide(width: 0.5, color: Colors.grey[400]),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(widget.title,
                    style: TextStyle(fontWeight: FontWeight.w600)),
                Text(widget.value ?? '',
                    style: TextStyle(fontWeight: FontWeight.w400)),
              ],
            ),
            Icon(Icons.keyboard_arrow_right)
          ],
        ),
      ),
    );
  }
}
