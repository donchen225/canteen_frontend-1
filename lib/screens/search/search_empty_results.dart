import 'package:flutter/material.dart';

class SearchEmptyResults extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Icon(
                Icons.search,
                size: 50,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                "Your search didn't match any users.",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),
            Text(
              "Please try a different search.",
              style: TextStyle(
                fontSize: 13,
              ),
            )
          ]),
    );
  }
}
