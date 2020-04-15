import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class SkipUserFloatingActionButton extends StatelessWidget {
  final Function onTap;

  SkipUserFloatingActionButton({@required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding:
            EdgeInsets.only(left: SizeConfig.instance.blockSizeHorizontal * 9),
        child: FloatingActionButton(
          onPressed: onTap,
          child: Icon(Icons.clear),
        ),
      ),
    );
  }
}
