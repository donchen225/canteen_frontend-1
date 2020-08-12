import 'dart:async';

import 'package:canteen_frontend/components/keyboard_visibility_builder.dart';
import 'package:canteen_frontend/models/request/request.dart';
import 'package:canteen_frontend/models/user/user.dart';
import 'package:canteen_frontend/utils/palette.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConfirmRequestDialog extends StatefulWidget {
  final User user;
  final DetailedRequest request;
  final Function onTap;

  ConfirmRequestDialog({this.user, this.request, this.onTap});

  @override
  _ConfirmRequestDialogState createState() => _ConfirmRequestDialogState();
}

class _ConfirmRequestDialogState extends State<ConfirmRequestDialog> {
  FocusNode _focus;
  TextEditingController _messageController;
  ScrollController _scrollController;
  final DateFormat timeFormat = DateFormat.jm();

  @override
  void initState() {
    super.initState();

    _focus = FocusNode();

    _scrollController = ScrollController();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _focus.dispose();
    _messageController.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  Widget _buildDescription(BuildContext context, DetailedRequest request) {
    final textStyle = Theme.of(context).textTheme.bodyText2;

    var descriptions;

    if (request is Referral) {
      var description;
      switch (request.type) {
        case "offer":
          description = " for their offering: \"${request.skill}\".";
          break;
        case "request":
          description = " for their request: \"${request.skill}\".";
          break;
        default:
          return Container();
      }

      descriptions = [
        TextSpan(
          text: '${widget.user.displayName}',
          style: textStyle.apply(
            fontWeightDelta: 2,
          ),
        ),
        TextSpan(text: " asked you for a referral to connect with "),
        TextSpan(
          text: '${request.receiver.displayName}',
          style: textStyle.apply(
            fontWeightDelta: 2,
          ),
        ),
        TextSpan(text: description),
      ];
    } else if (request is ReferredRequest) {
      var description;
      switch (request.type) {
        case "offer":
          description =
              " to connect with you for your offering: \"${request.skill}\".";
          break;
        case "request":
          description =
              " to connect with you for your request: \"${request.skill}\".";
          break;
        default:
          return Container();
      }

      descriptions = [
        TextSpan(
          text: '${request.referral.displayName}',
          style: textStyle.apply(
            fontWeightDelta: 2,
          ),
        ),
        TextSpan(text: " referred "),
        TextSpan(
          text: '${request.sender.displayName}',
          style: textStyle.apply(
            fontWeightDelta: 2,
          ),
        ),
        TextSpan(text: description),
      ];
    } else {
      var description;
      switch (request.type) {
        case "offer":
          description =
              " would like to connect with you for your offering: \"${request.skill}\".";
          break;
        case "request":
          description =
              " would like to connect with you for your request: \"${request.skill}\".";
          break;
        default:
          return Container();
      }

      descriptions = [
        TextSpan(
          text: '${widget.user.displayName}',
          style: textStyle.apply(
            fontWeightDelta: 2,
          ),
        ),
        TextSpan(text: description),
      ];
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: 5,
      ),
      child: RichText(
          textAlign: TextAlign.start,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            style: textStyle,
            children: descriptions,
          )),
    );
  }

  Widget _buildComment(BuildContext context, DetailedRequest request) {
    String comment;
    if (request is Referral) {
      if (request.referralComment != null &&
          request.referralComment.isNotEmpty) {
        comment = request.referralComment;
      }
    } else {
      if (request.comment != null && request.comment.isNotEmpty) {
        comment = request.comment;
      }
    }

    if (comment != null) {
      return Container(
        padding: EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Text(
          "\"$comment\"",
          style: Theme.of(context).textTheme.bodyText2.apply(
                fontStyle: FontStyle.italic,
                fontWeightDelta: 1,
              ),
        ),
      );
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final bodyTextStyle = Theme.of(context).textTheme.bodyText1;
    final buttonTextStyle = Theme.of(context).textTheme.button;
    final timeTextStyle = bodyTextStyle.apply(color: Colors.green);

    return AlertDialog(
      contentPadding: EdgeInsets.only(
        left: 24,
        right: 24,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: KeyboardVisibilityBuilder(
          builder: (context, child, isKeyboardVisible) {
            if (isKeyboardVisible && _focus.hasFocus) {
              // TODO: remove this hack to automatically scroll to bottom
              Timer(
                  Duration(milliseconds: 500),
                  () => _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.fastOutSlowIn,
                      ));
            }
            return child;
          },
          child: Container(
            width: double.maxFinite,
            constraints: BoxConstraints(
              maxHeight: SizeConfig.instance.safeBlockVertical * 65,
            ),
            child: ListView(
              controller: _scrollController,
              padding: EdgeInsets.only(
                top: 20,
                bottom: 24,
              ),
              shrinkWrap: true,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Request Details',
                    style: Theme.of(context).textTheme.headline5.apply(
                          fontWeightDelta: 1,
                        ),
                  ),
                ),
                _buildDescription(context, widget.request),
                _buildComment(context, widget.request),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    widget.request.skill,
                    style: bodyTextStyle.apply(
                      fontWeightDelta: 2,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Row(
                    children: <Widget>[
                      const Icon(IconData(0xf26e,
                          fontFamily: CupertinoIcons.iconFont,
                          fontPackage: CupertinoIcons.iconFontPackage)),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              SizeConfig.instance.safeBlockHorizontal * 3,
                        ),
                        child: Text(
                          '${widget.request.duration.toString()} min',
                          style: bodyTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: widget.request.time != null,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Row(
                      children: <Widget>[
                        const Icon(IconData(0xf2d1,
                            fontFamily: CupertinoIcons.iconFont,
                            fontPackage: CupertinoIcons.iconFontPackage)),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  SizeConfig.instance.safeBlockHorizontal * 3,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.request.time != null
                                      ? DateFormat('yMMMMEEEEd')
                                              .format(widget.request.time) +
                                          ', ${timeFormat.format(widget.request.time)} - ${timeFormat.format(widget.request.time.add(Duration(minutes: widget.request.duration)))} ${widget.request.time.timeZoneName}'
                                      : '',
                                  style: timeTextStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.attach_money),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              SizeConfig.instance.safeBlockHorizontal * 3,
                        ),
                        child: Text(
                          '${widget.request.price.toStringAsFixed(2)}',
                          style: bodyTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: widget.request is Referral,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(
                      top: SizeConfig.instance.safeBlockVertical * 2,
                      bottom: SizeConfig.instance.safeBlockVertical,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1, color: Palette.borderSeparatorColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _messageController,
                      focusNode: _focus,
                      textCapitalization: TextCapitalization.sentences,
                      autofocus: false,
                      maxLines: null,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 10,
                          bottom: 10,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        hintText: 'Add a message',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: RaisedButton(
                    elevation: 0,
                    focusElevation: 0,
                    disabledElevation: 0,
                    highlightElevation: 0,
                    hoverElevation: 0,
                    color: Palette.primaryColor,
                    focusColor: Palette.primaryColor.withOpacity(0.4),
                    highlightColor: Palette.primaryColor.withOpacity(0.4),
                    hoverColor: Palette.primaryColor.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: () {
                      if (widget.onTap != null) {
                        widget.onTap(_messageController.text);
                      }
                      Navigator.maybePop(context, true);
                    },
                    child: Text(
                      'Confirm',
                      style: buttonTextStyle.apply(
                        fontWeightDelta: 1,
                        color: Palette.whiteColor,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
