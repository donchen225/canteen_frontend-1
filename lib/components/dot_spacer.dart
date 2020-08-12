import 'package:canteen_frontend/utils/palette.dart';
import 'package:flutter/material.dart';

class DotSpacer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: 3,
      decoration: BoxDecoration(
        color: Palette.textSecondaryBaseColor,
        shape: BoxShape.circle,
      ),
    );
  }
}
