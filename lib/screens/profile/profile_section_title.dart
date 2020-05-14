import 'package:flutter/material.dart';

class ProfileSectionTitle extends StatelessWidget {
  final String text;

  ProfileSectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline6.apply(fontWeightDelta: 2),
      ),
    );
  }
}
