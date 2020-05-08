import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class PostButton extends StatelessWidget {
  final Function(BuildContext) onTap;

  PostButton({@required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap(context);
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          top: SizeConfig.instance.blockSizeVertical * 2,
          bottom: SizeConfig.instance.blockSizeVertical * 2,
          left: SizeConfig.instance.blockSizeHorizontal * 3,
          right: SizeConfig.instance.blockSizeHorizontal * 3,
        ),
        child: Text(
          'POST',
          style: TextStyle(
            fontSize: 12,
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
