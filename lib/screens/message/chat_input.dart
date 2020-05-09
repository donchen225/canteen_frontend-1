import 'dart:math' as math;

import 'package:canteen_frontend/screens/message/bloc/bloc.dart';
import 'package:canteen_frontend/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatInput extends StatefulWidget {
  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController textEditingController = TextEditingController();
  MessageBloc _messageBloc;
  bool showEmojiKeyboard = false;
  Color _sendButtonColor = Colors.orange[100];

  @override
  void initState() {
    super.initState();
    _messageBloc = BlocProvider.of<MessageBloc>(context);

    textEditingController.addListener(_setColor);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void _setColor() {
    setState(() {
      _sendButtonColor = textEditingController.text.isEmpty
          ? Colors.orange[100]
          : Colors.orange[800];
    });
  }

  @override
  Widget build(BuildContext context) {
    final double additionalBottomPadding =
        math.max(SizeConfig.instance.paddingBottom, 0.0);

    return Material(
        elevation: 60.0,
        child: Container(
          padding: EdgeInsets.only(bottom: additionalBottomPadding),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  // Text input
                  Flexible(
                    child: Material(
                        child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: TextField(
                        controller: textEditingController,
                        textCapitalization: TextCapitalization.sentences,
                        autofocus: true,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Send a message...',
                          hintStyle:
                              TextStyle(color: Theme.of(context).hintColor),
                        ),
                      ),
                    )),
                  ),

                  // Send Message Button
                  Material(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: SizeConfig.instance.safeBlockHorizontal * 16,
                        child: FlatButton(
                          // color: Colors.red,
                          padding: EdgeInsets.all(0),
                          onPressed: () => sendMessage(context),
                          child: Text(
                            'Send',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: _sendButtonColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
                top:
                    BorderSide(color: Theme.of(context).hintColor, width: 0.5)),
          ),
        ));
  }

  void sendMessage(context) {
    if (textEditingController.text.isEmpty) return;
    _messageBloc.add(SendTextMessageEvent(textEditingController.text));
    textEditingController.clear();
  }
}
