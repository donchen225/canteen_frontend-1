import 'package:canteen_frontend/utils/constants.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final double height;
  final double width;
  final Color color;
  final Widget child;

  const SearchBar({
    Key key,
    @required this.height,
    this.width = 300,
    @required this.color,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(height * kSearchBarBorderRadius),
      ),
      child: Row(
        children: <Widget>[
          Flexible(
            child: Container(
              padding: EdgeInsets.only(left: 10),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      right: SizeConfig.instance.safeBlockHorizontal * 2,
                    ),
                    child: Icon(
                      Icons.search,
                      size: height * 0.8,
                      color: Colors.grey[600],
                    ),
                  ),
                  Flexible(
                    child: child ?? Container(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
