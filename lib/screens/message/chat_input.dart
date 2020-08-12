import 'package:canteen_frontend/screens/message/bloc/bloc.dart';
import 'package:canteen_frontend/utils/palette.dart';
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
  Color _sendButtonColor = Palette.primaryColor;

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
          ? Palette.primaryColor.withOpacity(0.3)
          : Palette.primaryColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Palette.containerColor,
          border: Border(top: BorderSide(color: Colors.grey, width: 0.1)),
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                // Text input
                Flexible(
                  child: Material(
                      color: Palette.containerColor,
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 10, left: 20, right: 20, bottom: 10),
                        child: TextField(
                          controller: textEditingController,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          autofocus: false,
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
                  color: Palette.containerColor,
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
                            color: _sendButtonColor,
                            fontWeight: FontWeight.w600,
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
      ),
    );
  }

  void sendMessage(context) {
    if (textEditingController.text.isEmpty) return;
    _messageBloc.add(SendTextMessageEvent(textEditingController.text));
    textEditingController.clear();
  }
}
