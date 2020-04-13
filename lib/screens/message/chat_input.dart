import 'package:canteen_frontend/screens/message/bloc/bloc.dart';
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
  @override
  void initState() {
    super.initState();
    _messageBloc = BlocProvider.of<MessageBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 60.0,
        child: Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  // Text input
                  Flexible(
                    child: Material(
                        child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      color: Colors.white70,
                      child: TextField(
                        controller: textEditingController,
                        autofocus: true,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Send a message',
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
                      child: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () => sendMessage(context),
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    color: Colors.white,
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
