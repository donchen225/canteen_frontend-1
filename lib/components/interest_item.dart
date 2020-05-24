import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class InterestItem extends StatelessWidget {
  final String text;
  final Function onTap;
  final double verticalPadding = 6;

  InterestItem({@required this.text, this.onTap});

  Widget _buildItem({bool clickable}) {
    return Container(
      padding: EdgeInsets.only(
        left: SizeConfig.instance.blockSizeHorizontal * 2,
        right: SizeConfig.instance.blockSizeHorizontal * 2,
        top: verticalPadding,
        bottom: verticalPadding,
      ),
      margin: EdgeInsets.only(
        top: SizeConfig.instance.safeBlockVertical * 0.5,
        bottom: SizeConfig.instance.safeBlockVertical * 0.5,
      ),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '#' + text,
            style: TextStyle(
              color: Palette.textClickableColor,
            ),
          ),
          Visibility(
            visible: clickable,
            child: Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.instance.blockSizeHorizontal,
              ),
              child: Icon(
                Icons.cancel,
                color: Palette.textClickableColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        if (onTap != null) {
          return GestureDetector(
              onTap: () {
                if (onTap != null) {
                  onTap(text);
                }
              },
              child: _buildItem(clickable: true));
        } else {
          return _buildItem(clickable: false);
        }
      },
    );
  }
}
