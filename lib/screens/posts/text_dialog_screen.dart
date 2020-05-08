import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';

class TextDialogScreen extends StatelessWidget {
  final String title;
  final Widget sendWidget;
  final Widget child;

  TextDialogScreen(
      {@required this.title, @required this.sendWidget, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.instance.blockSizeVertical * 90,
      decoration: BoxDecoration(
        color: const Color(0xFFFEFFFF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: const Color(0xFFFEFFFF),
          leading: CloseButton(),
          title: Text(title),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.instance.blockSizeHorizontal * 3,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  sendWidget,
                ],
              ),
            ),
          ],
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15),
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    top: SizeConfig.instance.blockSizeVertical * 3,
                    left: SizeConfig.instance.blockSizeHorizontal * 6,
                    right: SizeConfig.instance.blockSizeHorizontal * 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: 1,
                        color: const Color(0xFFDEE0D1),
                      ),
                    ),
                  ),
                  child: child ?? Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
