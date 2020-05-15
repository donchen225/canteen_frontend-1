import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final double height;
  final Color color;
  final Widget child;

  const SearchBar({
    Key key,
    @required this.height,
    @required this.color,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: color,
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
                      size: SizeConfig.instance.safeBlockVertical * 4,
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
